# sabnzbd

[![GitHub](https://img.shields.io/badge/source-github-lightgrey?style=flat-square)](https://github.com/hotio/docker-sabnzbd)
[![Docker Pulls](https://img.shields.io/docker/pulls/hotio/sabnzbd?style=flat-square)](https://hub.docker.com/r/hotio/sabnzbd)
[![Drone (cloud)](https://img.shields.io/drone/build/hotio/docker-sabnzbd?style=flat-square)](https://cloud.drone.io/hotio/docker-sabnzbd)

## Starting the container

Just the basics to get the container running:

```shell
docker run --rm --name sabnzbd -p 8080:8080 -v /tmp/sabnzbd:/config -e TZ=Etc/UTC hotio/sabnzbd
```

The environment variables below are all optional, the values you see are the defaults.

```shell
-e PUID=1000
-e PGID=1000
-e UMASK=022
-e VERSION=image
```

Possible values for `VERSION`:

```shell
VERSION=image
VERSION=stable
VERSION=unstable
VERSION=https://github.com/sabnzbd/sabnzbd/releases/download/2.3.4/SABnzbd-2.3.4-src.tar.gz
VERSION=file:///config/SABnzbd-2.3.4-src.tar.gz
```

## Executing your own scripts

If you have a need to do additional stuff when the container starts or stops, you can mount your script with `-v /docker/host/my-script.sh:/etc/cont-init.d/99-my-script` to execute your script on container start or `-v /docker/host/my-script.sh:/etc/cont-finish.d/99-my-script` to execute it when the container stops. An example script can be seen below.

```shell
#!/usr/bin/with-contenv bash

echo "Hello, this is me, your script."
```
