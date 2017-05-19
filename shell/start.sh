#!/bin/bash

echo 'start nginx'

/usr/local/tengine/sbin/nginx

echo 'start php'

/usr/local/php/sbin/php-fpm

echo 'start mysql'

/usr/local/mysql/support-files/mysql.server start

echo 'start redis'

/usr/local/redis/sbin/redis-server /usr/local/redis/etc/redis.conf

echo 'ok'
