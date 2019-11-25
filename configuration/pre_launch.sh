#!/bin/sh

BROKER_DIR=/home/jboss/${AMQ_NAME}

echo "PRE LAUNCH START : ${BROKER_DIR}"

function replaceVars() {
  sed -i "s/\${LDAP_BIND_PASSWORD}/$LDAP_BIND_PASSWORD/g" $1
  sed -i "s/\${role}/$AMQ_ROLE/g" $1
  sed -i "s/\${user}/$AMQ_USER/g" $1

}

replaceVars $BROKER_DIR/etc/login.config

