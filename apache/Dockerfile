FROM debian:stretch

MAINTAINER Hugues Lepesant <hugues@lepesant.com>

ENV RELEASE_DATE 2019-05-03
ENV DEBIAN_FRONTEND noninteractive
ENV APACHE_HTTPD "exec /usr/sbin/apache2"

RUN apt-get update && \
  apt-get -y install apache2 php7.0 libapache2-mod-php7.0 php7.0-mysql php7.0-json php7.0-curl php7.0-gd php7.0-cli && \
  apt-get clean

VOLUME /var/www/html/

EXPOSE 80

CMD ["/usr/sbin/apache2ctl", "-D", "FOREGROUND"]
