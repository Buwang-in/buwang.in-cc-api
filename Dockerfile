FROM php:8.1-fpm-alpine

RUN apk add --no-cache nginx wget \
    && apk add --no-cache --virtual .build-deps $PHPIZE_DEPS \
    && docker-php-ext-install pdo_mysql \
    && apk del .build-deps

RUN mkdir -p /run/nginx

COPY docker/nginx.conf /etc/nginx/nginx.conf

RUN mkdir -p /app
COPY . /app
COPY ./src /app

# Move .env.docker to .env
RUN mv /app/.env.docker /app/.env

RUN sh -c "wget http://getcomposer.org/composer.phar && chmod a+x composer.phar && mv composer.phar /usr/local/bin/composer"
RUN cd /app && \
    /usr/local/bin/composer install

RUN chown -R www-data: /app

EXPOSE 3306

CMD php artisan migrate:fresh --seed

CMD sh /app/docker/startup.sh
