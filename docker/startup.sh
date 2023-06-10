#!/bin/sh

sed -i "s,LISTEN_PORT,$PORT,g" /etc/nginx/nginx.conf

# Move .env.docker to .env
mv /app/.env.docker /app/.env

php-fpm -D

nginx
