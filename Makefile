KUBELET_VERSION=v1.18.12

IMAGE_NAME=kubelet
REPO=k1slow

.PHONY: help build push all

help:
	    @echo "Makefile commands:"
	    @echo "build"
	    @echo "push"

build:
		@docker build -t $(REPO)/$(IMAGE_NAME):$(KUBELET_VERSION) -f Dockerfile .

push:
		@docker push $(REPO)/$(IMAGE_NAME):$(KUBELET_VERSION)
