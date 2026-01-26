FROM php:8.2-cli

RUN apt-get update && apt-get install -y \
    git unzip zip libpq-dev libzip-dev \
    && docker-php-ext-install pdo pdo_pgsql zip

COPY --from=composer:2 /usr/bin/composer /usr/bin/composer

WORKDIR /app
COPY . .

RUN composer install --no-dev --optimize-autoloader
RUN chown -R www-data:www-data storage bootstrap/cache

EXPOSE 8080

CMD php artisan migrate --force && \
    php artisan serve --host=0.0.0.0 --port=${PORT}
