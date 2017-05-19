#!/bin/bash

echo 'stop nginx'

/usr/local/tengine/sbin/nginx -s stop

echo 'stop php'

kill -INT `cat /var/log/php/php-fpm.pid`

echo 'stop mysql'

/usr/local/mysql/support-files/mysql.server stop

echo 'stop redis'

/usr/local/redis/sbin/redis-cli shutdown

echo 'ok'
