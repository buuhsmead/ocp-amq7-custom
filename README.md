# ocp-amq7-custom
AMQ7 on OCP and customizing

oc new-project amq-custom

create a jenkins emphemeral with 1Gi memory


# Give jenkins SA enough rights (fine tuning still needed)
oc policy add-role-to-user admin system:serviceaccount:$(oc project -q):jenkins

oc create secret generic ldap-secret --from-literal=LDAP_BIND_PASSWORD=secret

oc new-app https://github.com/buuhsmead/ocp-amq7-custom


# Testing
oc create configmap broker-config --from-file=probeer1=configuration/probeer1.yaml --from-file=probeer2=configuration/probeer2.yaml

oc set volume sts/amq-broker-amq --add --name=broker-config --mount-path=/opt/amq/etc/configmap
