ARG base
FROM ${base}

USER root

# Dazzle does not rebuild a layer until one of its lines are changed. Increase this counter to rebuild this layer.
ENV TRIGGER_REBUILD=4

# Install composer
COPY --from=composer:2 /usr/bin/composer /usr/bin/composer

RUN for _ppa in 'ppa:ondrej/php' 'ppa:ondrej/apache2' 'ppa:ondrej/nginx'; do add-apt-repository -y "$_ppa"; done \
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
        # php-all-dev installs PHP 8.5, but metapackages only install extensions for 8.4, so explicitly install 8.5 extensions
        php8.5-bcmath \
        php8.5-curl \
        php8.5-fpm \
        php8.5-gd \
        php8.5-intl \
        php8.5-mbstring \
        php8.5-mysql \
        php8.5-pgsql \
        php8.5-sqlite3 \
        php8.5-xml \
        php8.5-zip \
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
