#!/bin/bash
set -e

/etc/init.d/php7.0-fpm start
chmod 777 /run/php7-fpm.sock
/usr/sbin/nginx -g 'daemon off;'
