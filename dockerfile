FROM debian:buster

RUN apt-get -y update
RUN apt-get -y upgrade
RUN apt-get -y install nginx
RUN apt-get -y install openssl
RUN apt-get -y install php7.3-fpm
RUN apt-get -y install mariadb-server php-mysql
RUN apt-get -y install wget

COPY ./srcs/start.sh ./
COPY ./srcs/wp-config.php ./tmp
COPY ./srcs/config.inc.php ./tmp
COPY ./srcs/default ./tmp

cmd bash ./start.sh
