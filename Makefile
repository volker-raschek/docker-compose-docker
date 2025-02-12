# DC_VERSION
# Only required to install a specifiy version
DC_VERSION?=v2.33.0 # renovate: datasource=github-releases depName=docker/compose

# CONTAINER_RUNTIME
# The CONTAINER_RUNTIME variable will be used to specified the path to a container runtime. This is needed to start and
# run a container image.
CONTAINER_RUNTIME?=$(shell which podman)

# DC_IMAGE_REGISTRY_NAME
# Defines the name of the new container to be built using several variables.
DC_IMAGE_REGISTRY_NAME:=git.cryptic.systems
DC_IMAGE_REGISTRY_USER:=volker.raschek

DC_IMAGE_NAMESPACE?=${DC_IMAGE_REGISTRY_USER}
DC_IMAGE_NAME:=docker-compose
DC_IMAGE_VERSION?=latest
DC_IMAGE_FULLY_QUALIFIED=${DC_IMAGE_REGISTRY_NAME}/${DC_IMAGE_NAMESPACE}/${DC_IMAGE_NAME}:${DC_IMAGE_VERSION}

# BUILD CONTAINER IMAGE
# =====================================================================================================================
PHONY:=container-image/build
container-image/build:
	${CONTAINER_RUNTIME} build \
		--build-arg DC_VERSION=${DC_VERSION} \
		--file Dockerfile \
		--no-cache \
		--pull \
		--tag ${DC_IMAGE_FULLY_QUALIFIED} \
		.

# DELETE CONTAINER IMAGE
# =====================================================================================================================
PHONY:=container-image/delete
container-image/delete:
	- ${CONTAINER_RUNTIME} image rm ${DC_IMAGE_FULLY_QUALIFIED}
	- ${CONTAINER_RUNTIME} image rm ${BASE_IMAGE_FULL}

# PUSH CONTAINER IMAGE
# =====================================================================================================================
PHONY+=container-image/push
container-image/push:
	echo ${DC_IMAGE_REGISTRY_PASSWORD} | ${CONTAINER_RUNTIME} login ${DC_IMAGE_REGISTRY_NAME} --username ${DC_IMAGE_REGISTRY_USER} --password-stdin
	${CONTAINER_RUNTIME} push ${DC_IMAGE_FULLY_QUALIFIED}

# PHONY
# =====================================================================================================================
# Declare the contents of the PHONY variable as phony. We keep that information in a variable so we can use it in
# if_changed.
.PHONY: ${PHONY}