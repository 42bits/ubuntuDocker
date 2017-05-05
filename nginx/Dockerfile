FROM hub.c.163.com/netease_comb/debian:7.9

MAINTAINER jshawcx jshawcx@gmail.com


#开启端口

EXPOSE 80

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


#可以先下载文件到本地,然后关联进来,为Dockerfile所在目录的相对路径

WORKDIR /soft

#COPY . /soft



#nginx相关

RUN wget http://tengine.taobao.org/download/tengine-2.2.0.tar.gz

RUN wget http://www.zlib.net/zlib-1.2.11.tar.gz

RUN wget ftp://ftp.csx.cam.ac.uk/pub/software/programming/pcre/pcre-8.40.tar.gz

RUN wget https://www.openssl.org/source/openssl-1.0.2k.tar.gz



#编译

#nginx使用的模块,移动相关模块到指定目录,编译nginx

RUN cp zlib-1.2.11.tar.gz pcre-8.40.tar.gz openssl-1.0.2k.tar.gz /home/nginx-lib

WORKDIR /home/nginx-lib

RUN tar zxf zlib-1.2.11.tar.gz;tar zxf pcre-8.40.tar.gz;tar zxf openssl-1.0.2k.tar.gz;

WORKDIR /home

RUN chmod -R 755 nginx-lib/

WORKDIR /soft

RUN tar zxf tengine-2.2.0.tar.gz

#make 错误 执行make clean

RUN cd tengine-2.2.0 ; ./configure --prefix=/usr/local/tengine --user=www-data --group=www-data --with-zlib=/home/nginx-lib/zlib-1.2.11 --with-pcre=/home/nginx-lib/pcre-8.40 --with-openssl=/home/nginx-lib/openssl-1.0.2k && make && make install




