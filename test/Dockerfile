FROM hub.c.163.com/netease_comb/debian:7.9

MAINTAINER jshawcx jshawcx@gmail.com


#开启端口

EXPOSE 80

EXPOSE 8000

EXPOSE 8080

EXPOSE 3360

EXPOSE 6379


#可以修改源,安装必须软件

RUN apt-get update

RUN apt-get -y install wget

RUN wget http://mirrors.163.com/.help/sources.list.wheezy

RUN mv sources.list.wheezy sources.list

RUN mv /etc/apt/sources.list /etc/apt/sources.list.bak

RUN cp sources.list /etc/apt/

RUN apt-get update ; apt-get -y upgrade

RUN apt-get -y install zip vim git 

RUN apt-get -y install gcc automake autoconf libtool make cmake libncurses5-dev build-essential

RUN apt-get -y install libxml2-dev libssl-dev libcurl4-openssl-dev pkg-config libsslcommon2-dev libbz2-dev libjpeg8-dev libpng12-dev libfreetype6-dev libmcrypt-dev psmisc


#添加用户(www-data 好像已经有了),构建目录

#RUN groupadd www-data

#RUN useradd -r -g www-data www-data

RUN groupadd mysql

RUN useradd -r mysql -g mysql

WORKDIR /usr/local

RUN mkdir -p tengine ; mkdir -p mysql ; mkdir -p php ; mkdir -p redis/sbin ; mkdir -p redis/etc ; mkdir -p go

WORKDIR /home

RUN mkdir -p nginx-lib

WORKDIR /data

RUN mkdir -p mysql;mkdir -p redis

RUN chown -R mysql:mysql mysql

RUN chmod -R 700 mysql

WORKDIR /tmp

RUN mkdir -p mysql

RUN chown -R mysql:mysql mysql

WORKDIR /var/log

RUN mkdir -p redis;mkdir -p php;mkdir -p nginx;mkdir -p mysql

RUN chown -R mysql:mysql mysql

WORKDIR 




