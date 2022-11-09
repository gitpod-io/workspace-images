ARG base
FROM ${base}

USER root

# Dazzle does not rebuild a layer until one of its lines are changed. Increase this counter to rebuild this layer.
ENV TRIGGER_REBUILD=2

# Install composer
COPY --from=composer:2 /usr/bin/composer /usr/bin/composer

RUN for _ppa in 'ppa:ondrej/php' 'ppa:ondrej/apache2' 'ppa:ondrej/nginx-mainline'; do add-apt-repository -y "$_ppa"; done \
    && install-packages \
        apache2 \
        nginx \
        nginx-extras \
        nginx-doc \
        php \
        php-all-dev \
        php-bcmath \
        php-common \
        php-curl \
        php-date \
        php-fpm \
        php-gd \
        php-intl \
        php-json \
        php-mbstring \
        php-mysql \
        php-net-ftp \
        php-pgsql \
        php-pear \
        php-sqlite3 \
        php-tokenizer \
        php-xml \
        php-zip \
    && mkdir -p /var/run/nginx \
    && ln -s /etc/apache2/mods-available/rewrite.load /etc/apache2/mods-enabled/rewrite.load \
    && chown -R gitpod:gitpod /etc/apache2 /var/run/apache2 /var/lock/apache2 /var/log/apache2 \
    && chown -R gitpod:gitpod /etc/nginx /var/run/nginx /var/lib/nginx/ /var/log/nginx/
COPY --chown=gitpod:gitpod apache2/ /etc/apache2/
COPY --chown=gitpod:gitpod nginx /etc/nginx/

## The directory relative to your git repository that will be served by Apache / Nginx
ENV APACHE_DOCROOT_IN_REPO="public"
ENV NGINX_DOCROOT_IN_REPO="public"

USER gitpod
