FROM php:8.2-cli

RUN apt-get update && apt-get install -y \
    git unzip zip sqlite3 libsqlite3-dev libzip-dev \
    && docker-php-ext-install pdo pdo_sqlite zip

COPY --from=composer:2 /usr/bin/composer /usr/bin/composer

WORKDIR /app
COPY . .

RUN composer install --no-dev --optimize-autoloader

RUN mkdir -p /data \
 && touch /data/database.sqlite \
 && chown -R www-data:www-data /data storage bootstrap/cache

ENV APP_ENV=production
ENV APP_DEBUG=false
ENV CACHE_DRIVER=file
ENV SESSION_DRIVER=file
ENV LOG_CHANNEL=stderr

EXPOSE 8080

CMD php artisan migrate --force || true && \
    php -S 0.0.0.0:${PORT} -t public

