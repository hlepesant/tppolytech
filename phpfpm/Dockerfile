FROM debian:buster-slim

ENV DEBIAN_FRONTEND=noninteractive

RUN apt-get update \
    && apt-get -y install apt-transport-https lsb-release ca-certificates gnupg2 procps vim \
    && apt-get -y install php7.3-common \
        php7.3-cli \
        php7.3-fpm \
        php7.3-mysql \
        php7.3-apcu \
        php7.3-gd \
        php7.3-imagick \
        php7.3-curl \
        php7.3-intl \
        php-redis \
        net-tools \
        default-mysql-client \
    && apt-get clean \
    && apt-get autoclean

ADD ./config/php.ini /etc/php/7.3/fpm/php.ini
ADD ./config/php-fpm.conf /etc/php/7.3/fpm/php-fpm.conf
ADD ./config/www.conf /etc/php/7.3/fpm/pool.d/www.conf

RUN mkdir /var/run/php

VOLUME /usr/share/nginx/html

EXPOSE 9000

CMD ["/usr/sbin/php-fpm7.3", "--nodaemonize"]
