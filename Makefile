.PHONY: docker-build docker-clean docker-push-registry version

DOCKER_REGISTRY?=
DOCKER_IMG_NAME?=mediacloudai/rabbitmq
ifneq ($(DOCKER_REGISTRY), ) 
	DOCKER_IMG_NAME := /${DOCKER_IMG_NAME}
endif
VERSION="3.8.5"

ENV?=local

docker-build:
	@docker build -t ${DOCKER_REGISTRY}${DOCKER_IMG_NAME}:${VERSION} .

docker-clean:
	@docker rmi ${DOCKER_REGISTRY}${DOCKER_IMG_NAME}:${VERSION}

docker-registry-login:
	@docker login --username "${DOCKER_REGISTRY_LOGIN}" -p"${DOCKER_REGISTRY_PWD}" ${DOCKER_REGISTRY}
	
docker-push-registry: 
	@docker push ${DOCKER_REGISTRY}${DOCKER_IMG_NAME}:${VERSION}

version:
	@echo ${VERSION}
