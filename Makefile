IMAGE ?= harbor.jupiter.mein.nl/osiris/app
TAG ?= latest
PLATFORMS ?= linux/amd64,linux/arm64
KUBE_NAMESPACE ?= osiris-prod
KUBE_DEPLOYMENT ?= osiris-prod
DEFAULT_MAP_LATITUDE ?= 53.3898
DEFAULT_MAP_LONGITUDE ?= 6.2347
DEFAULT_MAP_ZOOM ?= 14.5
BUILD_ARGS = --build-arg NEXT_PUBLIC_OSIRIS_DEFAULT_MAP_LATITUDE=$(DEFAULT_MAP_LATITUDE) --build-arg NEXT_PUBLIC_OSIRIS_DEFAULT_MAP_LONGITUDE=$(DEFAULT_MAP_LONGITUDE) --build-arg NEXT_PUBLIC_OSIRIS_DEFAULT_MAP_ZOOM=$(DEFAULT_MAP_ZOOM)

.PHONY: build push buildx deploy restart status

build:
	docker build $(BUILD_ARGS) -t $(IMAGE):$(TAG) .

push:
	docker push $(IMAGE):$(TAG)

buildx:
	docker buildx build --builder default --platform $(PLATFORMS) $(BUILD_ARGS) -t $(IMAGE):$(TAG) --push .

deploy: buildx restart status

restart:
	kubectl rollout restart deployment/$(KUBE_DEPLOYMENT) -n $(KUBE_NAMESPACE)

status:
	kubectl rollout status deployment/$(KUBE_DEPLOYMENT) -n $(KUBE_NAMESPACE)
