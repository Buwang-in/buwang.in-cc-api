FROM php:8.1-fpm-alpine

RUN apk add --no-cache nginx wget

RUN mkdir -p /run/nginx

COPY docker/nginx.conf /etc/nginx/nginx.conf

RUN mkdir -p /app
WORKDIR /app

# Copy the Laravel source code
COPY ./src .

# Copy the .env.docker file as .env
COPY .env.docker .env

# Install the Cloud SQL Proxy
RUN wget https://dl.google.com/cloudsql/cloud_sql_proxy.linux.amd64 -O cloud_sql_proxy \
    && chmod +x cloud_sql_proxy \
    && mv cloud_sql_proxy /usr/local/bin/

# Expose port for the Cloud SQL Proxy
EXPOSE 3306

# Start the Cloud SQL Proxy and then the PHP-FPM server
CMD ["sh", "-c", "/usr/local/bin/cloud_sql_proxy -instances=buwangin:asia-southeast2:buwangin-cc-db=tcp:3306 & php-fpm"]
