# Base image
FROM php:8.1-fpm-alpine

# Install system dependencies
RUN apk add --no-cache nginx wget

RUN mkdir -p /run/nginx

COPY docker/nginx.conf /etc/nginx/nginx.conf

# Install PHP extensions
RUN docker-php-ext-install pdo_mysql

# Install Cloud SQL Proxy
RUN wget https://dl.google.com/cloudsql/cloud_sql_proxy.linux.amd64 -O /usr/local/bin/cloud_sql_proxy
RUN chmod +x /usr/local/bin/cloud_sql_proxy

# Install Composer
RUN sh -c "wget http://getcomposer.org/composer.phar && chmod a+x composer.phar && mv composer.phar /usr/local/bin/composer"

# Set working directory
WORKDIR /app

# Copy application files
COPY src /app
COPY ./src /app

# Install project dependencies
RUN composer install --no-dev --no-scripts --no-autoloader

# Copy .env.docker as .env in the src folder
COPY .env.docker /app/src/.env

# Copy startup.sh
COPY docker/startup.sh /app/startup.sh
RUN chmod +x /app/startup.sh

# Copy nginx.conf
COPY docker/nginx.conf /etc/nginx/nginx.conf

# Run database migrations and start services
CMD /app/startup.sh
