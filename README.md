# docker-ttrss

I'm moving more of the services I use to Docker. This my Docker container for [tt-rss](https://tt-rss.org/). This container only supports Postgresql.

## Usage

First start a Postgresql instance (or use a regular instance):

    sudo docker run -d --name ttrssdb postgres

Then start docker-ttrss with Postgresql in a container:

    sudo docker run -d -p 80:80 --name ttrss --link ttrssdb:db reuteras/docker-ttrss

If you have an existing database server:

    sudo docker run -d --name ttrss -e TTRSS_DB_HOST=<hostname> -e TTRSS_DB_USER=<username> -e TTRSS_DB_NAME=<database name> -e TTRSS_DB_PASS="<database password>" -e TTRSS_FEED_CRYPT_KEY="<feed crypt key" reuteras/docker-ttrss

You can specify the following parameters:

* `-e TTRSS_DB_HOST=<database host>` (defaults to $DB_PORT_5432_TCP_ADDR)
* `-e TTRSS_DB_NAME="<database name>"` (defaults to "ttrss")
* `-e TTRSS_DB_PORT="<database port>"` ( defaults to "5432")
* `-e TTRSS_DB_USER="<database username>"` (defaults to "$DB_ENV_POSTGRES_USER")
* `-e TTRSS_DB_PASS="<database password>"` (defaults to "$DB_ENV_POSTGRES_PASSWORD")
* `-e TTRSS_FEED_CRYPT_KEY="<FEED_CRYPT_KEY>"` (defaults to "")
* `-e TTRSS_HOST_URL="<HOST URL>"` (defaults to "http://localhost/")

