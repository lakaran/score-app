FROM php:8.2-cli

# Dependências do sistema
RUN apt-get update && apt-get install -y \
    git \
    curl \
    zip \
    unzip \
    sqlite3 \
    libsqlite3-dev \
    libmariadb-dev \
    && docker-php-ext-install pdo pdo_mysql pdo_sqlite

# Composer
COPY --from=composer:latest /usr/bin/composer /usr/bin/composer

# Node.js 20
RUN curl -fsSL https://deb.nodesource.com/setup_20.x | bash - \
    && apt-get install -y nodejs

WORKDIR /var/www/html
COPY . .

# Permissões Laravel
RUN chmod -R 775 storage bootstrap/cache database || true

# Instalar dependências Laravel
RUN composer install --no-dev --optimize-autoloader || true

# Expor a porta que o Render vai usar
EXPOSE 4000

# Comando final
CMD php artisan serve --host=0.0.0.0 --port=$PORT


