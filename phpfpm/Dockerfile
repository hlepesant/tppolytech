#
FROM debian:stretch

ENV DEBIAN_FRONTEND noninteractive

ADD https://packages.sury.org/php/apt.gpg /tmp/sury.gpg

RUN apt-get update \
    && apt-get -y install apt-transport-https lsb-release ca-certificates gnupg2 procps vim \
    && apt-key add /tmp/sury.gpg \
    && rm -f /tmp/sury.gpg \
    && sh -c 'echo "deb https://packages.sury.org/php/ $(lsb_release -sc) main" > /etc/apt/sources.list.d/php-sury.list' \
    && apt-get update \
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
        mysql-client \
    && apt-get clean \
    && apt-get autoclean

ADD ./config/php.ini /etc/php/7.3/fpm/php.ini
ADD ./config/php-fpm.conf /etc/php/7.3/fpm/php-fpm.conf
ADD ./config/www.conf /etc/php/7.3/fpm/pool.d/www.conf

# RUN find /etc/php/7.3/cli/conf.d/ -name "*.ini" -exec sed -i -re 's/^(\s*)#(.*)/\1;\2/g' {} \;

RUN mkdir /var/run/php

VOLUME /usr/share/nginx/html

EXPOSE 9000

CMD ["/usr/sbin/php-fpm7.3", "--nodaemonize"]
