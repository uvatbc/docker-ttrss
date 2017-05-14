build:
	docker build -t uvatbc/docker-ttrss .

up:
	docker-compose up

down:
	-docker-compose down
