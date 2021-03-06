# ocp-amq7-custom
AMQ7 on OCP and customizing

oc new-project amq-custom

create a jenkins ephemeral with 1Gi memory


# Give jenkins SA enough rights (fine tuning still needed)
oc policy add-role-to-user admin system:serviceaccount:$(oc project -q):jenkins

oc create secret generic ldap-secret --from-literal=LDAP_BIND_PASSWORD=secret

oc new-app https://github.com/buuhsmead/ocp-amq7-custom



# From CLI
oc new-build amq-broker:7.5~https://github.com/buuhsmead/ocp-amq7-custom.git --name=amq7-custom

oc create secret generic ldap-secret --from-literal=LDAP_BIND_PASSWORD=secret

oc create configmap broker-extra-config \
--from-file=addresses.xml=extra-config/xinclude-config-addresses.xml \
--from-file=address.xml=extra-config/xinclude-config-address-settings.xml \
--from-file=security.xml=extra-config/xinclude-config-security-settings.xml


# broker.ks and broker.ts via tls/gen-tls.sh
oc create secret generic amq-app-secret --from-file=broker.ks --from-file=broker.ts

oc secrets add sa/${APPLICATION_NAME}-service-account secret/amq-app-secret


oc process -f ./templates/amq-broker-75-custom.yaml \
    -p APPLICATION_NAME="amq-broker" \
    -p AMQ_QUEUES=demoQueue \
    -p AMQ_ADDRESSES=demoTopic \
    -p AMQ_USER=admin \
    -p AMQ_PASSWORD=admin \
    -p AMQ_ROLE=OT-ADMIN,OT-VIEW,OT-DEV,admin \
    -p AMQ_SECRET=amq-app-secret \
    -p AMQ_DATA_DIR=/opt/amq/data \
    -p AMQ_TRUSTSTORE_PASSWORD=password \
    -p AMQ_KEYSTORE_PASSWORD=password \
    -p AMQ_DATA_DIR_LOGGING=true \
    -p IMAGE=172.30.1.1:5000/$(oc project -q)/amq7-custom:latest \
    -p AMQ_PROTOCOL=amqp \
    -p AMQ_CLUSTERED=true \
    -p AMQ_REPLICAS=1 \
    -o yaml | oc apply -f -

oc process -f ./templates/amq-broker-75-custom.yaml \
    -p APPLICATION_NAME="amq-broker" \
    -p AMQ_QUEUES=demoQueue \
    -p AMQ_ADDRESSES=demoTopic \
    -p AMQ_USER=amq-demo-user \
    -p AMQ_PASSWORD=passw0rd \
    -p AMQ_ROLE=OT-ADMIN,OT-VIEW,OT-DEV,admin \
    -p AMQ_SECRET=amq-app-secret \
    -p AMQ_DATA_DIR=/opt/amq/data \
    -p AMQ_TRUSTSTORE_PASSWORD=password \
    -p AMQ_KEYSTORE_PASSWORD=password \
    -p AMQ_DATA_DIR_LOGGING=true \
    -p IMAGE=172.30.1.1:5000/$(oc project -q)/amq7-custom:latest \
    -p AMQ_PROTOCOL=amqp \
    -p AMQ_CLUSTERED=true \
    -p AMQ_REPLICAS=0 \
    -p STORAGE_CLASS_NAME=glusterfs-dev \
    -o yaml | oc apply -f -





oc scale --replicas=1 sts amq-broker-amq


# LDAP 
./configuration/login.config

## User
dn: uid=john,dc=example,dc=com
changetype: add
objectClass: account
objectClass: top
objectClass: simpleSecurityObject
uid: john
userPassword:: R2VoZWlt

## Group / Role
dn: cn=OT-ADMIN,dc=example,dc=com
changetype: add
objectClass: groupOfNames
objectClass: top
member: uid=john,dc=example,dc=com
cn: OT-ADMIN



# Access from within Pod

./bin/artemis producer --url tcp://amq-broker-amq-1.broker-amq-headless.amq-custom.svc.cluster.local:61616 --user john --password Geheim


# Testing
oc create configmap broker-config --from-file=probeer1=configuration/probeer1.yaml --from-file=probeer2=configuration/probeer2.yaml

oc set volume sts/amq-broker-amq --add --name=broker-config --mount-path=/opt/amq/etc/configmap
