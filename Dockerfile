FROM php:8.2-fpm-alpine

ARG UID
ARG GID

ENV UID=${UID}
ENV GID=${GID}
ENV TZ=Europe/Rome

# Updating the packages
RUN apk update && \
    apk upgrade --available && \
    sync && \
    apk add nodejs \
        npm \
        bzip2-dev \
        libzip-dev \
        zlib-dev \
        libpng-dev \
        jpeg-dev \
        freetype-dev \
        libjpeg-turbo-dev \
        postgresql-dev \
        libxml2-dev

RUN docker-php-ext-configure gd --with-freetype --with-jpeg


RUN apk --no-cache add pcre-dev ${PHPIZE_DEPS} \
  && pecl install redis  \
  && docker-php-ext-install -j$(nproc) bz2 gd zip pdo pdo_pgsql pgsql pdo_mysql bcmath opcache intl xml \
  && docker-php-ext-enable redis bz2 gd zip pdo pdo_mysql pdo_pgsql bcmath opcache intl xml \
  && apk del pcre-dev ${PHPIZE_DEPS} \
  && rm -rf /tmp/pear

RUN cd /usr/local/etc/php/conf.d/ && \
  echo 'memory_limit = 4096M' >> /usr/local/etc/php/conf.d/docker-php-memlimit.ini


RUN addgroup -g ${GID} laravel
RUN adduser -G laravel -D -s /bin/sh -u ${UID} laravel

COPY ./php/opcache.ini /usr/local/etc/php/conf.d/opcache.ini
COPY ./php/datetime.ini /usr/local/etc/php/conf.d/datetime.ini

# check
# docker-compose exec laravel-php php --ini

# vi: ft=dockerfile
