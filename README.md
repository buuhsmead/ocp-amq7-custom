# ocp-amq7-custom
AMQ7 on OCP and customizing



curl -O https://raw.githubusercontent.com/jboss-container-images/jboss-amq-7-broker-openshift-image/75-7.5.0.GA/templates/amq-broker-75-persistence-clustered-ssl.yaml

cp amq-broker-75-persistence-clustered-ssl.yaml amq-broker-75-custom.yaml




oc new-app https://github.com/buuhsmead/ocp-amq7-custom

