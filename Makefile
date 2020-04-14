IMAGE=uvatbc/docker-ttrss

build:
	docker build -t $(IMAGE) .

push:
	docker push $(IMAGE)

pull:
	docker pull $(IMAGE)

it:
	docker run --rm -it $(IMAGE) bash

up:
	docker-compose up

down:
	-docker-compose down
