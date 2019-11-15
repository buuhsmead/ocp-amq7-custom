# ocp-amq7-custom
AMQ7 on OCP and customizing

oc new-project amq-custom

create a jenkins emphemeral with 1Gi memory


# Give jenkins SA enough rights (fine tuning still needed)
oc policy add-role-to-user admin system:serviceaccount:$(oc project -q):jenkins



oc new-app https://github.com/buuhsmead/ocp-amq7-custom

