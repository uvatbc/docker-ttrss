FROM accupara/ubuntu:17.04

## Install tools and libraries
RUN sudo apt-get update -y && \
    sudo apt-get install -y --no-install-recommends \
        apache2 \
        ca-certificates \
        git \
        libapache2-mod-php \
        libxml2-utils \
        php-curl \
        php-gd \
        php-pgsql \
        php-mcrypt \
        postgresql-client \
        supervisor \
        tidy && \
# Checkout TT-RSS and plugins
    sudo git clone https://tt-rss.org/gitlab/fox/tt-rss.git /var/www/html/ttrss && \
    sudo git clone https://github.com/reuteras/ttrss_plugin-af_feedmod.git /var/www/html/ttrss/plugins.local/af_feedmod && \
    sudo git clone https://github.com/fastcat/tt-rss-ff-xmllint /tmp/ff_xmllint && \
    sudo mv /tmp/ff_xmllint/ff_xmllint /var/www/html/ttrss/plugins.local && \
# Clean up
    sudo rm -rf /var/www/html/ttrss/.git && \
    sudo rm -rf /var/www/html/ttrss/plugins.local/af_feedmod/.git && \
    sudo apt-get remove -y git && \
    sudo apt-get autoremove -y && \
    sudo apt-get clean && \
    sudo rm -rf /var/lib/apt/lists/* && \
    sudo rm -rf /tmp/* && \
    sudo rm -rf /usr/share/doc /usr/local/share/man /var/cache/debconf/*-old

# Copy files to docker
COPY ttrss.conf /etc/apache2/sites-available/ttrss.conf
COPY config.php /var/www/html/ttrss/config.php
COPY supervisord.conf /etc/supervisor/supervisord.conf
COPY entrypoint.sh /entrypoint.sh

# Configure Apache
RUN sudo chmod 644 /etc/apache2/sites-available/ttrss.conf && \
    sudo a2ensite ttrss.conf && \
    sudo a2dissite 000-default && \
    sudo a2dissite default-ssl && \
    sudo chmod +x /entrypoint.sh && \
    sudo chown -R www-data:www-data /var/www/html/ttrss

EXPOSE 80

ENTRYPOINT ["/entrypoint.sh"]
CMD ["/usr/bin/supervisord", "-c", "/etc/supervisor/supervisord.conf"]
