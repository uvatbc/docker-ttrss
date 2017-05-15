# docker-ttrss

This is a fork of [reuteras/docker-ttrss](https://github.com/reuteras/docker-ttrss) because the original did not work out-of-the-box for me and I needed the usage to be much simpler.

The original readme message from was:  
I'm moving more of the services I use to Docker. This my Docker container for [tt-rss](https://tt-rss.org/). This container only supports Postgresql.

## What is it?
[Tiny Tiny RSS](https://tt-rss.org/) is a "self-hosted" RSS application written in PHP.  
When Google shut down Reader, TTRSS was the only reasonable alternative that I could find.  

TTRSS has a lot of features and can work with multiple DBs.  
This project is only concerned with making it work with Postgres.  

The first step is to make an image that packages the latest TTRSS source into a container.   
The Docker Compose file sets up the postgres container, the TTRSS container and links them together.   

Everything is unencrypted (no HTTPS), so **DO NOT USE THIS IN PRODUCTION**.   
You have been warned.

## Usage

### Docker Compose and Makefile (aka The Simple Way)
To start the Postgres and TTRSS containers:

    make up

Now open a browser to [localhost:10000](http://localhost:10000)   
That is all.

### Run Manually
First start a Postgresql instance (or use a regular instance):

    sudo docker run \
         -d \
         --name ttrssdb \
         postgres

Then start docker-ttrss with Postgresql in a container:

    sudo docker run \
         -d \
         -p 80:80 \
         --name ttrss \
         --link ttrssdb:db \
         uvatbc/docker-ttrss

If you have an existing database server:

    sudo docker run \
         -d \
         --name ttrss \
         -p 8000:8000 \
         -e TTRSS_DB_HOST=<hostname> \
         -e TTRSS_DB_USER=<username> \
         -e TTRSS_DB_NAME=<database name> \
         -e TTRSS_DB_PASS="<database password>" \
         -e TTRSS_FEED_CRYPT_KEY="<feed crypt key" \
         uvatbc/docker-ttrss

As seen in the two examples above the web server listens on both port 80 and 8000. Select the one that works best with your proxy settings.

You can specify the following parameters:

* `-e TTRSS_DB_HOST=<database host>` (defaults to $DB_PORT_5432_TCP_ADDR)
* `-e TTRSS_DB_NAME="<database name>"` (defaults to "ttrss")
* `-e TTRSS_DB_PORT="<database port>"` ( defaults to "5432")
* `-e TTRSS_DB_USER="<database username>"` (defaults to "$DB_ENV_POSTGRES_USER")
* `-e TTRSS_DB_PASS="<database password>"` (defaults to "$DB_ENV_POSTGRES_PASSWORD")
* `-e TTRSS_FEED_CRYPT_KEY="<FEED_CRYPT_KEY>"` (defaults to "")
* `-e TTRSS_HOST_URL="<HOST URL>"` (defaults to "http://localhost/")