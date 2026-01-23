FROM dunglas/frankenphp:php8.2


WORKDIR /app


COPY . .


RUN install-php-extensions pdo pdo_mysql


RUN composer install --no-dev --optimize-autoloader


RUN php artisan key:generate


EXPOSE 8000


CMD php artisan migrate --force && php artisan serve --host=0.0.0.0 --port=8000