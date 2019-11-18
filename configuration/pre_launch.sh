#!/bin/sh

echo "PRE LAUNCH START"

INSTANCE_DIR=/home/jboss/broker


function replaceVars() {
  sed -i "s/\${LDAP_BIND_PASSWORD}/$LDAP_BIND_PASSWORD/g" $1
}

replaceVars $INSTANCE_DIR/etc/login.config

