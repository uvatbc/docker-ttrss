FROM accupara/ubuntu:18.04

# Copy files to docker
COPY ttrss.conf config.php supervisord.conf entrypoint.sh /tmp/

## Install tools and libraries
RUN set -x \
 && export DEBIAN_FRONTEND="noninteractive" \
 && sudo apt-get update -y \
 && sudo apt-get install -y --no-install-recommends \
        apache2 \
        ca-certificates \
        cron \
        git \
        libapache2-mod-php \
        libxml2-utils \
        php-curl \
        php-gd \
        php-intl \
        php-mbstring \
        php-pgsql \
        php-xml \
        postgresql-client \
        supervisor \
        tidy \
# Checkout TT-RSS and plugins
 && sudo git clone -v https://git.tt-rss.org/fox/tt-rss.git /var/www/html/ttrss \
# Copy all the files to their appropriate directories
 && sudo mv /tmp/ttrss.conf       /etc/apache2/sites-available/ttrss.conf \
 && sudo mv /tmp/config.php       /var/www/html/ttrss/config.php \
 && sudo mv /tmp/supervisord.conf /etc/supervisor/supervisord.conf \
 && sudo mv /tmp/entrypoint.sh    /entrypoint.sh \
# Clean up
 && sudo apt-get autoremove -y \
 && sudo apt-get clean \
 && sudo rm -rf /var/lib/apt/lists/* \
 && sudo rm -rf /tmp/* \
 && sudo rm -rf /usr/share/doc /usr/local/share/man /var/cache/debconf/*-old \
# Configure Apache
 && sudo chmod 644 /etc/apache2/sites-available/ttrss.conf \
 && sudo a2ensite ttrss.conf \
 && sudo a2dissite 000-default \
 && sudo a2dissite default-ssl \
 && sudo chmod +x /entrypoint.sh \
 && sudo chown -R www-data:www-data /var/www/html/ttrss \
# Prep the crontab
 && sudo touch /var/log/cron.log \
 && echo "*/30 * * * * /usr/bin/php /var/www/html/ttrss/update.php --feeds --quiet" | sudo tee /etc/cron.d/update-ttrss \
 && sudo crontab /etc/cron.d/update-ttrss

EXPOSE 80

ENTRYPOINT ["/entrypoint.sh"]
CMD ["/usr/bin/supervisord", "-c", "/etc/supervisor/supervisord.conf"]
