#!/usr/bin/env bash


keytool -genkey -alias broker -keyalg RSA -keystore broker.ks -storepass password -keypass password -dname CN=broker.amq.custom.ocp.example.com -storetype pkcs12


#keytool -export -alias broker -keystore broker.ks -file broker_cert

#keytool -genkey -alias client -keyalg RSA -keystore client.ks

#keytool -import -alias broker -keystore client.ts -file broker_cert


oc create secret generic amq-app-secret --from-file=broker.ks

