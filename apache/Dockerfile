FROM debian:jessie

MAINTAINER Hugues Lepesant <hugues@lepesant.com>

ENV RELEASE_DATE 2016-05-07
ENV DEBIAN_FRONTEND noninteractive
ENV APACHE_HTTPD "exec /usr/sbin/apache2"

RUN apt-get update && \
  apt-get -y install apache2 php5 libapache2-mod-php5 php5-mysql php5-json php5-curl php5-gd php5-cli && \
  apt-get clean

VOLUME /var/www/html/
#VOLUME ["/etc/apache2/sites-available", "/etc/apache2/sites-enabled"]

EXPOSE 80

CMD ["/usr/sbin/apache2ctl", "-D", "FOREGROUND"]
