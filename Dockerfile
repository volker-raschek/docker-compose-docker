FROM docker.io/library/ubuntu:26.04 AS download

ARG DC_VERSION=v5.1.4

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

ARG DC_VERSION=v5.1.4
ARG BUILD_DATE

LABEL io.artifacthub.package.readme-url="https://raw.githubusercontent.com/docker/compose/refs/tags/${DC_VERSION}/README.md" \
      org.opencontainers.image.created="${BUILD_DATE}" \
      org.opencontainers.image.description="Define and run multi-container applications with Docker" \
      org.opencontainers.image.version=${DC_VERSION}

COPY --from=download /tmp/docker-compose /usr/bin/docker-compose
ENTRYPOINT [ "/usr/bin/docker-compose" ]
