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


#mysql相关

RUN wget https://dev.mysql.com/get/Downloads/MySQL-5.7/mysql-boost-5.7.17.tar.gz

RUN wget http://sourceforge.net/projects/boost/files/boost/1.59.0/boost_1_59_0.tar.gz





#编译mysql如果编译错误 make clean;rm CMakeCache.txt

WORKDIR /soft

RUN tar zxf mysql-boost-5.7.17.tar.gz

RUN tar zxf mysql-boost-5.7.17.tar.gz

WORKDIR mysql-5.7.17

RUN cmake -DCMAKE_INSTALL_PREFIX=/usr/local/mysql -DMYSQL_DATADIR=/data/mysql -DSYSCONFDIR=/usr/local/mysql/etc  -DMYSQL_USER=mysql -DMYSQL_TCP_PORT=3306  -DDEFAULT_CHARSET=utf8 -DDEFAULT_COLLATION=utf8_general_ci -DMYSQL_UNIX_ADDR=/tmp/mysql/mysqld.sock -DEXTRA_CHARSETS=all -DWITH_MYISAM_STORAGE_ENGINE=1 -DWITH_INNOBASE_STORAGE_ENGINE=1 -DWITH_EMBEDDED_SERVER=1 -DENABLED_LOCAL_INFILE=1 -DWITH_ARCHIVE_STORAGE_ENGINE=1 -DWITH_MEMORY_STORAGE_ENGINE=1 -DWITH_READLINE=1 -DWITH_SSL:STRING=bundled -DWITH_ZLIB:STRING=bundled  -DENABLE_DOWNLOADS=1 -DDOWNLOAD_BOOST=1 -DWITH_BOOST=/soft

RUN make && make install

WORKDIR /usr/local/mysql

RUN mkdir -p etc

RUN mv support-files/my-default.cnf etc/

RUN cd etc && mv my-default.cnf my.cnf

RUN /usr/local/mysql/bin/mysqld --basedir=/usr/local/mysql --datadir=/data/mysql --user=mysql --initialize-insecure




