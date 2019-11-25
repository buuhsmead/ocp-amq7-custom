#!/bin/sh

BROKER_DIR=/home/jboss/${AMQ_NAME}

echo "PRE LAUNCH START : ${BROKER_DIR}"

function replaceVars() {
  sed -i "s/\${LDAP_BIND_PASSWORD}/$LDAP_BIND_PASSWORD/g" $1
  sed -i "s/\${role}/$AMQ_ROLE/g" $1
  sed -i "s/\${user}/$AMQ_USER/g" $1

}

replaceVars $BROKER_DIR/etc/login.config



sed -i '/<security-settings>/,/<\/security-settings>/d' $BROKER_DIR/etc/broker.xml

sed -i '/<address-settings>/,/<\/address-settings>/d' $BROKER_DIR/etc/broker.xml

sed -i '/<addresses>/,/<\/addresses>/d' $BROKER_DIR/etc/broker.xml

sed -i '/<\/core>/i  <xi:include href="/home/jboss/broker-extra-config/address.xml"/><xi:include href="/home/jboss/broker-extra-config/security.xml"/><xi:include href="/home/jboss/broker-extra-config/addresses.xml"/>' $BROKER_DIR/etc/broker.xml

touch $BROKER_DIR/etc/broker.xml
