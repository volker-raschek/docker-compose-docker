FROM docker.io/library/ubuntu:24.04 AS download

# renovate: datasource=github-releases depName=docker/compose
ARG DC_VERSION=v2.40.3

RUN NAME=docker-compose-$(uname | tr [:upper:] [:lower:])-$(uname -m); \
    apt update --yes && \
    apt install --yes curl && \
    curl \
      --fail \
      --output "/tmp/${NAME}" \
      --location "https://github.com/docker/compose/releases/download/${DC_VERSION}/${NAME}" && \
    curl \
      --fail \
      --output /tmp/checksums.txt \
      --location "https://github.com/docker/compose/releases/download/${DC_VERSION}/checksums.txt" && \
    (cd /tmp && sha256sum --ignore-missing --check checksums.txt) && \
    ln -s "${NAME}" /tmp/docker-compose && \
    chmod +x /tmp/docker-compose

FROM scratch

COPY --from=download /tmp/docker-compose /usr/bin/docker-compose
ENTRYPOINT [ "/usr/bin/docker-compose" ]
