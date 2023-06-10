#!/bin/sh

# Start Cloud SQL Proxy
/cloud_sql_proxy -instances=buwangin:asia-southeast2:buwangin-cc-db=tcp:3306 &

# Run database migrations
php artisan migrate:fresh --seed

# Start PHP-FPM
php-fpm
