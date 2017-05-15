IMAGE=uvatbc/docker-ttrss

build:
	docker build -t $(IMAGE) .

push:
	docker push $(IMAGE)

up:
	docker-compose up

down:
	-docker-compose down
