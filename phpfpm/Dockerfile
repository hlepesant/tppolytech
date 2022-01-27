FROM debian:bullseye-slim

ENV DEBIAN_FRONTEND noninteractive

RUN apt-get update \
    && apt-get -y install apt-transport-https lsb-release ca-certificates gnupg2 procps vim \
    && apt-get -y install php7.4-common \
        php7.4-cli \
        php7.4-fpm \
        php7.4-mysql \
        php7.4-apcu \
        php7.4-gd \
        php7.4-imagick \
        php7.4-curl \
        php7.4-intl \
        php-redis \
        net-tools \
        default-mysql-client \
    && apt-get clean \
    && apt-get autoclean

ADD ./config/php.ini /etc/php/7.4/fpm/php.ini
ADD ./config/php-fpm.conf /etc/php/7.4/fpm/php-fpm.conf
ADD ./config/www.conf /etc/php/7.4/fpm/pool.d/www.conf

RUN mkdir /var/run/php

VOLUME /usr/share/nginx/html

EXPOSE 9000

CMD ["/usr/sbin/php-fpm7.4", "--nodaemonize"]
