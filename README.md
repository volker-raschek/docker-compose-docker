# docker-compose

[![Docker Pulls](https://img.shields.io/docker/pulls/volkerraschek/docker-compose)](https://hub.docker.com/r/volkerraschek/docker-compose)

This project contains all sources to build the container image `git.cryptic.systems/volker.raschek/docker-compose`. The
primary goal of this project is to package the binary `docker-compose` as container image. The source code of the binary
can be found in the upstream project of [docker/compose](https://github.com/docker/compose).

The workflow or how `docker-compose` can in general be used is documented at
[docs.docker.com](https://docs.docker.com/compose/). Nevertheless, here are some examples of how to use the container
image.

```bash
IMAGE_VERSION=2.40.2
docker run \
  --rm \
  --volume ./path/to/docker-compose.yml:/workdir/docker-compose.yml:ro \
  --volume /var/run/docker.sock:/var/run/docker.sock \
  --workdir /workdir \
    git.cryptic.systems/volker.raschek/docker-compose:${IMAGE_VERSION} \
      ps
```
