# Helm Chart for deploying ECO server

You've probably got your eco server container in a private registry ... so first:

```
$ kubectl create namespace eco
$ kubectl -n eco create secret generic regcred \
    --from-file=.dockerconfigjson=~/.docker/config.json \
    --type=kubernetes.io/dockerconfigjson
secret/regcred created
```
