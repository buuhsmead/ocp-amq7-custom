# ocp-amq7-custom
AMQ7 on OCP and customizing



# Give jenkins SA enough rights (fine tuning still needed)
oc policy add-role-to-user edit system:serviceaccount:$(oc project -q):jenkins



oc new-app https://github.com/buuhsmead/ocp-amq7-custom

