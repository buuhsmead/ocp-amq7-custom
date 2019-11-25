#!/bin/sh

echo "PRE LAUNCH START : ${INSTANCE_DIR}"

BROKER_DIR=/home/jboss/${AMQ_NAME}


function replaceVars() {
  sed -i "s/\${LDAP_BIND_PASSWORD}/$LDAP_BIND_PASSWORD/g" $1
}

replaceVars $BROKER_DIR/etc/login.config

