#!/bin/bash

echo 'restart nginx'

/usr/local/tengine/sbin/nginx -s reload

echo 'restart php'

kill -USR2 `cat /var/log/php/php-fpm.pid`

echo 'restart mysql'

/usr/local/mysql/support-files/mysql.server restart

echo 'restart redis'

/usr/local/redis/sbin/redis-cli shutdown

/usr/local/redis/sbin/redis-server /usr/local/redis/etc/redis.conf

echo 'ok'
