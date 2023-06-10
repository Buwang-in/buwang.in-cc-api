#!/bin/sh

sed -i "s,LISTEN_PORT,$PORT,g" /etc/nginx/nginx.conf && \
    php-fpm -D -F -R --php-ini=/usr/local/etc/php/php.ini --fpm-config=/usr/local/etc/php-fpm.conf --pid=/usr/local/var/run/php-fpm.pid -c /usr/local/etc/php/php.ini -y /usr/local/etc/php-fpm.conf --listen 0.0.0.0:8000

# Move .env.docker to .env
mv /app/.env.docker /app/.env

php-fpm -D

nginx
