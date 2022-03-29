FROM php:8.1-fpm

RUN apt update
RUN apt install -y git unzip libzip-dev
RUN docker-php-ext-install pdo pdo_mysql zip && \
    docker-php-ext-enable pdo pdo_mysql zip

COPY --from=composer:2 /usr/bin/composer /usr/bin/composer

WORKDIR /app
