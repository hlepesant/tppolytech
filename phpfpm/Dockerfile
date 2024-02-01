FROM debian:bullseye-slim

ENV DEBIAN_FRONTEND=noninteractive

RUN apt-get update

# To complete
# [ ... ]

RUN mkdir /var/run/php

ADD ./config/php.ini /etc/php/8.2/fpm/php.ini
ADD ./config/php-fpm.conf /etc/php/8.2/fpm/php-fpm.conf
ADD ./config/pool.d/www.conf /etc/php/8.2/fpm/pool.d/www.conf

# To complete
# [ ... ]
VOLUME [...]

EXPOSE [...]

CMD ["/usr/sbin/php-fpm8.2", "--nodaemonize"]
