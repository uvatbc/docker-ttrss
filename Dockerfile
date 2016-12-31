FROM debian:jessie
MAINTAINER Peter Reuterås <peter@reuteras.net>

## Install tools and libraries
RUN apt-get update -yqq && \
    apt-get install -yqq --no-install-recommends \
        apache2 \
        ca-certificates \
        git \
        php5 \
        libapache2-mod-php5 \
        libxml2-utils \
        php5-curl \
        php5-gd \
        php5-pgsql \
        php5-mcrypt \
        postgresql-client \
        supervisor \
        tidy && \
# Checkout TT-RSS and plugins
    git clone https://tt-rss.org/gitlab/fox/tt-rss.git /var/www/html/ttrss && \
    git clone https://github.com/reuteras/ttrss_plugin-af_feedmod.git /var/www/html/ttrss/plugins.local/af_feedmod && \
    git clone https://github.com/fastcat/tt-rss-ff-xmllint /tmp/ff_xmllint && \
    mv /tmp/ff_xmllint/ff_xmllint /var/www/html/ttrss/plugins.local && \
# Clean up
    rm -rf /var/www/html/ttrss/.git && \
    rm -rf /var/www/html/ttrss/plugins.local/af_feedmod/.git && \
    apt-get remove -y git && \
    apt-get autoremove -y && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/* &&
    rm -rf /tmp/* && \
    rm -rf /usr/share/doc /usr/local/share/man /var/cache/debconf/*-old

# Copy files to docker
COPY ttrss.conf /etc/apache2/sites-available/ttrss.conf
COPY config.php /var/www/html/ttrss/config.php
COPY supervisord.conf /etc/supervisor/supervisord.conf
COPY entrypoint.sh /entrypoint.sh

# Configure Apache
RUN chmod 644 /etc/apache2/sites-available/ttrss.conf && \
    a2ensite ttrss.conf && \
    a2dissite 000-default && \
    a2dissite default-ssl && \
    chmod +x /entrypoint.sh && \
    chown -R www-data:www-data /var/www/html/ttrss

EXPOSE 80

ENTRYPOINT ["/entrypoint.sh"]
CMD ["/usr/bin/supervisord", "-c", "/etc/supervisor/supervisord.conf"]
