DOCKER_IMAGE_VERSION=latest
DOCKER_IMAGE_NAME=henryabra/rpi-mosquitto
DOCKER_IMAGE_TAGNAME=$(DOCKER_IMAGE_NAME):$(DOCKER_IMAGE_VERSION)

current_dir := $(shell pwd)
uid := $(shell id -u)
gid := $(shell id -g)

default: build

build:
	docker build -t $(DOCKER_IMAGE_TAGNAME) .
	docker image tag $(DOCKER_IMAGE_TAGNAME) $(DOCKER_IMAGE_NAME):latest

push:
	docker image push $(DOCKER_IMAGE_NAME)

test:
	docker container run --rm $(DOCKER_IMAGE_TAGNAME) /bin/echo "Success."
run:
	docker container run --rm --name mqtt -d -p 1883:1883 -p 8883:8883 -p 9001:9001 -v "$(current_dir)/mqtt/log:/mqtt/log" -v "$(current_dir)/mqtt/data:/mqtt/data" -u $(uid):$(gid) $(DOCKER_IMAGE_TAGNAME)

rmi:
	docker rmi $(DOCKER_IMAGE_TAGNAME)

rebuild: rmi build
