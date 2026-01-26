FROM php:8.2-cli

RUN apt-get update && apt-get install -y \
    unzip zip curl git \
    libmariadb-dev \
    sqlite3 libsqlite3-dev \
    && docker-php-ext-install pdo pdo_mysql pdo_sqlite

COPY --from=composer:latest /usr/bin/composer /usr/bin/composer

RUN curl -sl https://deb.nodesource.com/setup_18.x | bash && \ apt-get update && apt-get install -y nodejs

WORKDIR /var/www/html
COPY . .

EXPOSE 8000

RUN composer install --no-dev --optimize-autoloader
RUN npm install
RUN chown -R www-data:www-data storage bootstrap/cache database

CMD php artisan migrate --force && php artisan serve --host=0.0.0.0 --port=8000
