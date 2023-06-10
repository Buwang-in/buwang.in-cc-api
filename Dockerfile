# Base image
FROM php:8.1-fpm-alpine3.15

# Install system dependencies
RUN apk add --no-cache nginx wget \
    && apk add --no-cache --virtual .build-deps \
        $PHPIZE_DEPS \
        curl \
        libpng-dev \
        libxml2-dev \
        oniguruma-dev \
        zip \
        unzip \
    && docker-php-ext-install pdo_mysql mbstring exif pcntl bcmath gd \
    && apk del -f .build-deps

# Install Composer
RUN curl -sS https://getcomposer.org/installer | php -- --install-dir=/usr/local/bin --filename=composer

# Set working directory
WORKDIR /app

# Copy nginx.conf
COPY docker/nginx.conf /etc/nginx/nginx.conf

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
EXPOSE 9000

# Run Nginx and PHP-FPM
CMD envsubst '$$DB_HOST' < /etc/nginx/nginx.conf > /etc/nginx/nginx.conf && \
    service nginx start && \
    php-fpm
