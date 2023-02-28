FROM debian:bullseye-slim

ENV DEBIAN_FRONTEND=noninteractive

RUN apt-get update

# To complete
# [ ... ]

RUN mkdir /var/run/php

ADD ./config/php.ini /etc/php/7.4/fpm/php.ini
ADD ./config/php-fpm.conf /etc/php/7.4/fpm/php-fpm.conf
ADD ./config/pool.d/www.conf /etc/php/7.4/fpm/pool.d/www.conf

# To complete
# [ ... ]
VOLUME [...]

EXPOSE [...]

CMD ["/usr/sbin/php7.4-fpm", "--nodaemonize"]
