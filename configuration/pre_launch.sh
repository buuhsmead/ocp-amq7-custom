#!/bin/sh

echo "POST START LAUNCH"

INSTANCE_DIR=/home/jboss/broker


function swapVars() {
  sed -i "s/\${LDAP_BIND_PASSWORD}/$LDAP_BIND_PASSWORD/g" $1
}

swapVars $INSTANCE_DIR/etc/login.config

