FROM php:8.2-fpm

# Instalar dependências de sistema e o driver do Postgres
RUN apt-get update && apt-get install -y \
    libpq-dev \
    git \
    unzip \
    && docker-php-ext-configure pgsql -with-pgsql=/usr/local/pgsql \
    && docker-php-ext-install pdo pdo_pgsql

# Instalar Composer
COPY --from=composer:latest /usr/bin/composer /usr/bin/composer

WORKDIR /var/www
COPY . .

# Instalar dependências do projeto
RUN composer install --no-dev --optimize-autoloader

# Ajustar permissões (Crucial para o erro 502/500)
RUN chown -R www-data:www-data /var/www/storage /var/www/bootstrap/cache

EXPOSE 8080

# Comando para ligar
CMD php artisan migrate --force && php artisan serve --host=0.0.0.0 --port=8080