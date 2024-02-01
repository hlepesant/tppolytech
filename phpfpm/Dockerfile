FROM debian:bullseye-slim

ENV DEBIAN_FRONTEND=noninteractive

RUN apt-get update \
    && apt-get -y install apt-transport-https lsb-release ca-certificates gnupg2 procps vim \
    && apt-get -y install php8.2-common \
        php8.2-cli \
        php8.2-fpm \
        php8.2-mysql \
        php8.2-apcu \
        php8.2-gd \
        php8.2-imagick \
        php8.2-curl \
        php8.2-intl \
        php-redis \
        net-tools \
        default-mysql-client \
    && apt-get clean \
    && apt-get autoclean

ADD ./config/php.ini /etc/php/8.2/fpm/php.ini
ADD ./config/php-fpm.conf /etc/php/8.2/fpm/php-fpm.conf
ADD ./config/www.conf /etc/php/8.2/fpm/pool.d/www.conf

RUN mkdir /var/run/php

VOLUME /usr/share/nginx/html

EXPOSE 9000

CMD ["/usr/sbin/php-fpm8.2", "--nodaemonize"]
