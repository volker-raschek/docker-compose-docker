FROM docker.io/library/golang:1.24.1-alpine3.21 AS build

ARG DC_VERSION=main

RUN set -ex && \
    apk update && \
    apk upgrade && \
    apk add git make

RUN git clone https://github.com/docker/compose.git --branch ${DC_VERSION} docker-compose && \
    cd docker-compose && \
    make DESTDIR=/cache

FROM docker.io/library/alpine:3.21

COPY --from=build /cache/docker-compose /usr/bin/docker-compose

ENTRYPOINT [ "/usr/bin/docker-compose" ]
