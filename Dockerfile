# Base image
FROM php:8.1-fpm

# Install system dependencies
RUN apt-get update && apt-get install -y \
    curl \
    libpng-dev \
    libonig-dev \
    libxml2-dev \
    zip \
    unzip \
    && rm -rf /var/lib/apt/lists/*

# Install PHP extensions
RUN docker-php-ext-install pdo_mysql mbstring exif pcntl bcmath gd

# Install Composer
RUN curl -sS https://getcomposer.org/installer | php -- --install-dir=/usr/local/bin --filename=composer

# Set working directory
WORKDIR /var/www/html

# Copy application files
COPY . /var/www/html

# Copy composer files
COPY composer.json composer.lock ./

# Install project dependencies
RUN composer install --no-scripts --no-autoloader

# Generate autoload files
RUN composer dump-autoload --optimize

# Set permissions
RUN chown -R www-data:www-data storage bootstrap/cache

# Copy .env.docker as .env
COPY .env.docker .env

# Expose port 9000 for PHP-FPM
EXPOSE 8080

# Run Cloud SQL Proxy and database migrations
CMD /usr/local/bin/cloud_sql_proxy -instances=buwangin:asia-southeast2:buwangin-cc-db=tcp:3306 & php artisan migrate:fresh --seed && php-fpm
