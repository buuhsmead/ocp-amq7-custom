#!/bin/sh

# have to find another way of doing this, maybe an initContainer


BROKER_DIR="/home/jboss/${AMQ_NAME}"

echo "PRE LAUNCH START : ${BROKER_DIR}"

function replaceVars() {
  sed -i "s/\${LDAP_BIND_PASSWORD}/$LDAP_BIND_PASSWORD/g" $1
  sed -i "s/\${role}/$AMQ_ROLE/g" $1
  sed -i "s/\${user}/$AMQ_USER/g" $1
  sed -i "s/\${BROKER_IP}/0.0.0.0/g" $1
  sed -i "s/\${AMQ_KEYSTORE_PASSWORD}/$AMQ_KEYSTORE_PASSWORD/g" $1
  sed -i "s/\${AMQ_NAME}/$AMQ_NAME/g" $1
  sed -i "s]\${AMQ_DATA_DIR}]$AMQ_DATA_DIR]g" $1
}



# Remove all 'security-settings'
sed -i '/<security-settings>/,/<\/security-settings>/d' "$BROKER_DIR/etc/broker.xml"
# Remove all 'address-settings'
sed -i '/<address-settings>/,/<\/address-settings>/d' "$BROKER_DIR/etc/broker.xml"
# Remove all 'addresses'
sed -i '/<addresses>/,/<\/addresses>/d' "$BROKER_DIR/etc/broker.xml"
# Insert previously removed XML as include
sed -i '/<\/core>/i  <xi:include href="/home/jboss/broker-extra-config/address.xml"/><xi:include href="/home/jboss/broker-extra-config/security.xml"/><xi:include href="/home/jboss/broker-extra-config/addresses.xml"/>' "$BROKER_DIR/etc/broker.xml"

FILES="$BROKER_DIR/etc/*"

# pre_launch.sh MUST NOT be replaced vars

for item in $FILES
do
	if [[ "$(basename $item)" != "pre_launch.sh" ]]
	then
		replaceVars "${item}"
	fi	
done



touch $BROKER_DIR/etc/broker.xml

# cp /opt/amq/lib/artemis-prometheus-metrics-plugin-*.jar ${BROKER_DIR}/lib



