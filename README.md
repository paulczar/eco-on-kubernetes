# Eco in Docker

Download the game server from the [strangeloop eco]() website and unzip it into `./server`.

Build your docker image.

```console
$ docker build -t eco/server .
```

Run it in docker

```console
$ docker run -ti --rm -p 3000:3000/udp -p 3001:3001 eco/server
```

## kubernetes via helm

Push the docker image up to a docker registry, but not to a public one ...  its not 
your game server executable to share!!!

```
$ docker tag eco/server registry.com/eco/server
$ docker push registry.com/eco/server
```

Deploy with helm

```console
$ helm install --namespace eco --name eco \
    --set image.repository=registry.com/eco/server helm/eco

```

