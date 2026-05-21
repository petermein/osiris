IMAGE ?= harbor.jupiter.mein.nl/osiris/app
TAG ?= latest
PLATFORMS ?= linux/amd64,linux/arm64
KUBE_NAMESPACE ?= osiris-prod
KUBE_DEPLOYMENT ?= osiris-prod

.PHONY: build push buildx deploy restart status

build:
	docker build -t $(IMAGE):$(TAG) .

push:
	docker push $(IMAGE):$(TAG)

buildx:
	docker buildx build --builder default --platform $(PLATFORMS) -t $(IMAGE):$(TAG) --push .

deploy: buildx restart status

restart:
	kubectl rollout restart deployment/$(KUBE_DEPLOYMENT) -n $(KUBE_NAMESPACE)

status:
	kubectl rollout status deployment/$(KUBE_DEPLOYMENT) -n $(KUBE_NAMESPACE)
