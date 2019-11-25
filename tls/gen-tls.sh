#!/usr/bin/env bash

keytool -genkey -alias broker -keyalg RSA -keystore broker.ks -storepass password -keypass password -dname CN=broker.amq.custom.ocp.example.com -storetype pkcs12

keytool -export -alias broker -keystore broker.ks -file broker_cert

keytool -genkey -alias client -keyalg RSA -keystore client.ks -storepass password -keypass password -dname CN=client.example.com -storetype pkcs12

keytool -import -alias broker -keystore client.ts -file broker_cert

keytool -export -alias client -keystore client.ks -file client_cert

keytool -import -alias client -keystore broker.ts -file client_cert


oc create secret generic amq-app-secret --from-file=broker.ks --from-file=broker.ts

oc secrets add sa/${APPLICATION_NAME}-service-account secret/amq-app-secret



Please be sure to create a secret named "amq-app-secret" containing the trust store
and key store files ("broker.ts" and "broker.ks") used for serving secure content.


amq-app-secret
Name of a secret containing SSL related files


amq-credential-secret
Name of a secret containing credential data such as usernames and passwords


jndi.properties
# Set the InitialContextFactory class to use
java.naming.factory.initial = org.apache.qpid.jms.jndi.JmsInitialContextFactory

# Define the required ConnectionFactory instances
# connectionfactory.<JNDI-lookup-name> = <URI>
connectionfactory.myFactoryLookup = amqps://broker-amq-ssl.192.168.99.105.nip.io:443?transport.verifyHost=false

# Configure the necessary Queue and Topic objects
# queue.<JNDI-lookup-name> = <queue-name>
# topic.<JNDI-lookup-name> = <topic-name>
queue.myQueueLookup = queue
topic.myTopicLookup = topic


java -Djavax.net.ssl.keyStore=/Users/hdaems/customers/dji/client.ks \
  -Djavax.net.ssl.keyStorePassword=password \
  -Djavax.net.ssl.trustStore=/Users/hdaems/customers/dji/client.ts \
  -Djavax.net.ssl.trustStorePassword=password \
  -DUSER=admin \
  -DPASSWORD=admin \
  -cp "target/classes/:target/dependency/*" org.apache.qpid.jms.example.Sender 1000



# SSL/TLS Route
apiVersion: route.openshift.io/v1
kind: Route
metadata:
  annotations:
    openshift.io/host.generated: 'true'
  labels:
    app: broker-ssl
    application: broker-ssl
    template: amq-broker-75-persistence-ssl
    xpaas: 1.4.16
  name: broker
spec:
  port:
    targetPort: all-ssl
  tls:
    termination: passthrough
  to:
    kind: Service
    name: broker-ssl-amq-headless
    weight: 100
  wildcardPolicy: None
