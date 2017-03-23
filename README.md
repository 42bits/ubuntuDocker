FROM hub.c.163.com/netease_comb/debian:7.9

MAINTAINER jshawcx jshawcx@gmail.com

#开启端口

EXPORT 80

EXPORT 8080

EXPORT 3360

EXPORT 6379

#添加用户(www-data 好像已经有了)

#RUN groupadd www-data

#RUN useradd -r -g www-data www-data

RUN groupadd mysql

RUN useradd -r mysql -g mysql

#创建目录

RUN cd /usr/local;mkdir -p tengine2.2;mkdir -p mysql5.7;mkdir -p php7.1

RUN cd /home;mkdir -p nginx-lib

RUN cd /;mkdir -p data/mysql

RUN cd /data;chown -R mysql:mysql mysql/;chmod -R 700 mysql/

RUN cd /tmp;mkdir -p mysql;chown -R mysql:mysql mysql/

RUN cd /var/log/;mkdir -p mysql;chown -R mysql:mysql mysql/

RUN cd /; mkdir -p soft;cd soft

#可以修改源

#RUN wget http://mirrors.163.com/.help/sources.list.wily

#RUN mv sources.list.wily sources.list

#RUN mv /etc/apt/sources.list /etc/apt/sources.list.bak

#RUN cp sources.list /etc/apt/

RUN apt-get update

RUN apt-get install gcc automake autoconf libtool make build-essential zip vim wget git

#可以先下载文件到本地,然后关联进来,为Dockerfile所在目录的相对路径

#COPY ["soft/", "/soft"]

#nginx相关

#RUN wget http://tengine.taobao.org/download/tengine-2.2.0.tar.gz

#RUN wget http://www.zlib.net/zlib-1.2.11.tar.gz

#RUN wget ftp://ftp.csx.cam.ac.uk/pub/software/programming/pcre/pcre-8.40.tar.gz

#RUN wget https://www.openssl.org/source/openssl-1.0.2k.tar.gz

#redis相关
#RUN wget http://download.redis.io/releases/redis-3.2.1.tar.gz

#mysql相关

#RUN wget https://dev.mysql.com/get/Downloads/MySQL-5.7/mysql-boost-5.7.17.tar.gz

#php相关

#RUN wget http://jp2.php.net/distributions/php-7.1.3.tar.gz

#RUN wget https://github.com/laruence/yaf/archive/yaf-3.0.4.zip

#RUN wget https://github.com/swoole/swoole-src/archive/v2.0.7.zip

#golang相关

#RUN wget https://storage.googleapis.com/golang/go1.8.linux-amd64.tar.gz


#nginx使用的模块

RUN cp zlib-1.2.11.tar.gz pcre-8.40.tar.gz openssl-1.1.0e.tar.gz /home/nginx-lib

#移动相关模块到指定目录

RUN cd /home/nginx-lib;tar zxf zlib-1.2.11.tar.gz;tar zxf pcre-8.40.tar.gz;tar zxf openssl-1.0.2k.tar.gz;chmod -R 755 nginx-lib/;cd /soft

#编译nginx

RUN tar zxf tengine-2.2.0.tar.gz

RUN cd /tengine-2.2.0

RUN ./configure --prefix=/usr/local/tengine2.2 --user=www-data --group=www-data --with-zlib=/home/nginx-lib/zlib-1.2.11 --with-pcre=/home/nginx-lib/pcre-8.40 --with-openssl=/home/nginx-lib/openssl-1.0.2k

#make 错误 执行make clean

RUN make & make install

#编译redis

#编译mysql

#编译php和扩展

#编译golang







