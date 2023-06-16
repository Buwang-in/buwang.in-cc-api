#!/bin/sh

sed -i "s,LISTEN_PORT,$PORT,g" /etc/nginx/nginx.conf

# Move .env.docker to .env
mv /app/.env.docker /app/.env

RUN php artisan cache:clear && php artisan view:clear

php-fpm -D

nginx

# php artisan migrate:fresh --seed