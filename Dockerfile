FROM hub.c.163.com/netease_comb/debian:7.9

MAINTAINER jshawcx jshawcx@gmail.com


#开启端口

EXPOSE 80


#可以修改源,安装必须软件
RUN buildDeps='wget zip vim git gcc automake autoconf libtool make cmake libncurses5-dev build-essential ghostscript libxml2-dev libssl-dev libcurl4-openssl-dev pkg-config libsslcommon2-dev libbz2-dev libjpeg8-dev libpng12-dev libfreetype6-dev libmcrypt-dev psmisc' \
    
    && apt-get update \

    && apt-get -y install $buildDeps \

    && wget http://mirrors.163.com/.help/sources.list.wheezy \

    && mv sources.list.wheezy sources.list \

    && mv /etc/apt/sources.list /etc/apt/sources.list.bak \

    && cp sources.list /etc/apt/ \

    && apt-get update \

    && apt-get -y upgrade \
    
    && apt-get purge -y --auto-remove $buildDeps

#添加用户(www-data 好像已经有了),构建目录

#RUN groupadd www-data

#RUN useradd -r -g www-data www-data

RUN groupadd mysql useradd -r mysql -g mysql

WORKDIR /usr/local

RUN mkdir -p tengine ; mkdir -p mysql/etc ; mkdir -p boost ; mkdir -p php ; mkdir -p redis/sbin ; mkdir -p redis/etc ; mkdir -p go

WORKDIR /home

RUN mkdir -p nginx-lib

WORKDIR /data

RUN mkdir -p mysql;mkdir -p redis \

    && chown -R mysql:mysql mysql \

    && chmod -R 700 mysql

WORKDIR /tmp

RUN mkdir -p mysql \

    && chown -R mysql:mysql mysql

WORKDIR /var/log

RUN mkdir -p redis;mkdir -p php;mkdir -p nginx;mkdir -p mysql \

    && chown -R mysql:mysql mysql


#可以先下载文件到本地,然后关联进来,为Dockerfile所在目录的相对路径

WORKDIR /soft

#COPY . /soft



#nginx相关(可以提前准备，用完rm掉)

RUN wget http://tengine.taobao.org/download/tengine-2.2.0.tar.gz

RUN wget http://www.zlib.net/zlib-1.2.11.tar.gz

RUN wget ftp://ftp.csx.cam.ac.uk/pub/software/programming/pcre/pcre-8.40.tar.gz

RUN wget https://www.openssl.org/source/openssl-1.0.2k.tar.gz



#redis相关(可以提前准备，用完rm掉)

RUN wget http://download.redis.io/releases/redis-3.2.1.tar.gz



#golang相关(可以提前准备，用完rm掉)

RUN wget https://storage.googleapis.com/golang/go1.8.linux-amd64.tar.gz



#mysql相关(可以提前准备，用完rm掉)

RUN wget https://dev.mysql.com/get/Downloads/MySQL-5.7/mysql-boost-5.7.17.tar.gz

RUN wget http://sourceforge.net/projects/boost/files/boost/1.59.0/boost_1_59_0.tar.gz



#php相关(可以提前准备，用完rm掉)

RUN wget http://jp2.php.net/distributions/php-7.1.3.tar.gz

RUN wget https://github.com/laruence/yaf/archive/yaf-3.0.4.zip

RUN wget https://github.com/laruence/yac/archive/yac-2.0.1.tar.gz

RUN wget https://github.com/laruence/yaconf/archive/yaconf-1.0.4.tar.gz

RUN wget https://github.com/msgpack/msgpack-php/archive/msgpack-2.0.2.tar.gz

RUN wget https://github.com/laruence/yar/archive/yar-2.0.2.tar.gz

RUN wget https://github.com/laruence/taint/archive/taint-2.0.2.tar.gz

RUN wget https://github.com/swoole/swoole-src/archive/v2.0.7.zip

RUN wget https://github.com/phpredis/phpredis/archive/3.1.2.zip



#编译

#nginx使用的模块,移动相关模块到指定目录,编译nginx

RUN cp zlib-1.2.11.tar.gz pcre-8.40.tar.gz openssl-1.0.2k.tar.gz /home/nginx-lib

WORKDIR /home/nginx-lib

RUN tar zxf zlib-1.2.11.tar.gz;tar zxf pcre-8.40.tar.gz;tar zxf openssl-1.0.2k.tar.gz

WORKDIR pcre-8.40

RUN autoreconf -ivf

WORKDIR /home

RUN chmod -R 755 nginx-lib/

WORKDIR /soft

RUN tar zxf tengine-2.2.0.tar.gz

#make 错误 执行make clean

RUN cd tengine-2.2.0 ; ./configure --prefix=/usr/local/tengine --user=www-data --group=www-data --with-zlib=/home/nginx-lib/zlib-1.2.11 --with-pcre=/home/nginx-lib/pcre-8.40 --with-openssl=/home/nginx-lib/openssl-1.0.2k && make && make install



#编译redis

WORKDIR /soft

RUN tar zxf redis-3.2.1.tar.gz

RUN cd redis-3.2.1 && make

RUN cd /soft/redis-3.2.1/src ; cp mkreleasehdr.sh redis-benchmark redis-check-aof redis-check-rdb redis-cli redis-sentinel redis-server redis-trib.rb /usr/local/redis/sbin/

WORKDIR /soft/redis-3.2.1

RUN cp redis.conf /usr/local/redis/etc/

#如果不行只能放在shell脚本里随应用启动时一起修改

RUN echo 'vm.overcommit_memory = 1' >> /etc/sysctl.conf



#编译golang

WORKDIR /soft

RUN tar zxf go1.8.linux-amd64.tar.gz

RUN cp -rf go/* /usr/local/go/


#编译mysql如果编译错误 make clean;rm CMakeCache.txt

WORKDIR /soft

RUN cp boost_1_59_0.tar.gz /usr/loca/boost/ 

RUN tar zxf mysql-boost-5.7.17.tar.gz

WORKDIR mysql-5.7.17

RUN cmake -DCMAKE_INSTALL_PREFIX=/usr/local/mysql -DMYSQL_DATADIR=/data/mysql -DSYSCONFDIR=/usr/local/mysql/etc  -DMYSQL_USER=mysql -DMYSQL_TCP_PORT=3306  -DDEFAULT_CHARSET=utf8 -DDEFAULT_COLLATION=utf8_general_ci -DMYSQL_UNIX_ADDR=/tmp/mysql/mysqld.sock -DEXTRA_CHARSETS=all -DWITH_MYISAM_STORAGE_ENGINE=1 -DWITH_INNOBASE_STORAGE_ENGINE=1 -DWITH_EMBEDDED_SERVER=1 -DENABLED_LOCAL_INFILE=1 -DWITH_ARCHIVE_STORAGE_ENGINE=1 -DWITH_MEMORY_STORAGE_ENGINE=1 -DWITH_READLINE=1 -DWITH_SSL:STRING=bundled -DWITH_ZLIB:STRING=bundled  -DENABLE_DOWNLOADS=1 -DDOWNLOAD_BOOST=1 -DWITH_BOOST=/usr/local/boost/

RUN make && make install

WORKDIR /usr/local/mysql

RUN mkdir -p etc

RUN mv support-files/my-default.cnf etc/

RUN cd etc && mv my-default.cnf my.cnf

RUN /usr/local/mysql/bin/mysqld --basedir=/usr/local/mysql --datadir=/data/mysql --user=mysql --initialize-insecure



#编译php

WORKDIR /soft

RUN tar zxf php-7.1.3.tar.gz

WORKDIR php-7.1.3

RUN ./configure --prefix=/usr/local/php --with-config-file-path=/usr/local/php/etc --enable-fpm --with-fpm-user=www-data --with-fpm-group=www-data --with-zlib --enable-mbstring --with-openssl --enable-ftp --with-curl --with-gd --enable-gd-native-ttf  --with-mysqli=mysqlnd  --with-pdo-mysql=mysqlnd --enable-pdo --with-mysql-sock --enable-sockets --with-gettext --enable-bcmath --enable-xml --with-bz2 --enable-zip --enable-shmop --with-iconv --enable-mbregex --enable-pcntl --enable-sysvmsg --enable-sysvsem --enable-sysvshm --with-freetype-dir --with-jpeg-dir --with-png-dir --disable-fileinfo --with-mhash --enable-pcntl --with-mcrypt --enable-inline-optimization --enable-exif --disable-rpath 

RUN make && make install

RUN cp php.ini-production php.ini-development  /usr/local/php/etc/

WORKDIR /usr/local/php/etc

RUN mv php-fpm.conf.default php-fpm.conf

RUN mv php.ini-development php.ini

WORKDIR php-fpm.d
 
RUN mv www.conf.default www.conf


#可以使用上面也可以写入系统文件

RUN echo 'export NGINXROOT=/usr/local/tengine' >> /etc/profile

RUN echo 'export REDISROOT=/usr/local/redis' >> /etc/profile

RUN echo 'export MYSQLROOT=/usr/local/mysql' >> /etc/profile

RUN echo 'export PHPROOT=/usr/local/php' >> /etc/profile

RUN echo 'export GOROOT=/usr/local/go' >> /etc/profile

RUN echo 'export GOPATH=/work/golang' >> /etc/profile

RUN echo 'export PATH=$PATH:$NGINXROOT/sbin:$REDISROOT/sbin:$MYSQLROOT/bin:$MYSQLROOT/support-files:$PHPROOT/bin:$PHPROOT/sbin:$GOROOT/bin:$GOPATH/bin' >> /etc/profile

RUN /bin/bash -c 'source  /etc/profile'


#编译php扩展

#yaf

WORKDIR /soft

RUN unzip yaf-3.0.4.zip

RUN cd yaf-3.0.4

RUN /usr/local/php/bin/phpize

RUN ./configure && make && make install


#yac

WORKDIR /soft

RUN tar zxf yac-2.0.1.tar.gz

RUN cd yac-2.0.1

RUN /usr/local/php/bin/phpize

RUN ./configure && make && make install


#yaconf

WORKDIR /soft

RUN tar zxf yaconf-1.0.4.tar.gz

RUN cd yaconf-1.0.4

RUN /usr/local/php/bin/phpize

RUN ./configure && make && make install


#msgpack

WORKDIR /soft

RUN tar zxf msgpack-2.0.2.tar.gz

RUN cd msgpack-2.0.2

RUN /usr/local/php/bin/phpize

RUN ./configure && make && make install


#yar

WORKDIR /soft

RUN tar zxf yar-2.0.2.tar.gz

RUN cd yar-2.0.2

RUN /usr/local/php/bin/phpize

RUN ./configure && make && make install


#taint

WORKDIR /soft

RUN tar zxf taint-2.0.2.tar.gz

RUN cd taint-2.0.2

RUN /usr/local/php/bin/phpize

RUN ./configure && make && make install


#swoole

WORKDIR /soft

RUN unzip v2.0.7.zip

RUN cd v2.0.7

RUN /usr/local/php/bin/phpize

RUN ./configure && make && make install


#redis

WORKDIR /soft

RUN unzip 3.1.2.zip

RUN cd 3.1.2

RUN /usr/local/php/bin/phpize

RUN ./configure && make && make install




