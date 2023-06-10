# Base image
FROM php:8.1-fpm-alpine

# Install system dependencies
RUN apk add --no-cache nginx wget

# Set working directory
WORKDIR /app

# Copy nginx.conf
COPY docker/nginx.conf /etc/nginx/nginx.conf

# Install PHP extensions
RUN docker-php-ext-install pdo_mysql

# Copy Laravel project files
COPY src/ /app

# Copy .env.docker as .env
COPY .env.docker /app/.env

# Install project dependencies
RUN composer install --no-scripts --no-autoloader

# Generate autoload files
RUN composer dump-autoload --optimize

# Set permissions
RUN chown -R www-data: /app

# Expose port 80 for Nginx
EXPOSE 80

# Run Nginx and PHP-FPM
CMD envsubst '$$DB_HOST' < /etc/nginx/nginx.conf > /etc/nginx/nginx.conf && \
    service nginx start && \
    php-fpm
