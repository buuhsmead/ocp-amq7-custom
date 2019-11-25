#!/bin/sh

echo "PRE LAUNCH START : ${INSTANCE_DIR}"

#INSTANCE_DIR=/home/jboss/${AMQ_NAME}


function replaceVars() {
  sed -i "s/\${LDAP_BIND_PASSWORD}/$LDAP_BIND_PASSWORD/g" $1
}

replaceVars $INSTANCE_DIR/etc/login.config

