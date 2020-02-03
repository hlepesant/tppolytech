#
FROM debian:buster-slim

ENV DEBIAN_FRONTEND noninteractive

RUN apt-get update

# To complete
# [ ... ]

ADD ./config/php.ini /etc/php/7.3/fpm/php.ini
ADD ./config/php-fpm.conf /etc/php/7.3/fpm/php-fpm.conf
ADD ./config/www.conf /etc/php/7.3/fpm/pool.d/www.conf

RUN mkdir /var/run/php

# To complete
# [ ... ]
VOLUME [...]

EXPOSE [...]

CMD ["/usr/sbin/php7.3-fpm", "--nodaemonize"]
