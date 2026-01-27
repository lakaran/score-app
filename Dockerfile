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

# Node.js 18 (forma correta)
RUN curl -fsSL https://deb.nodesource.com/setup_18.x | bash - \
    && apt-get install -y nodejs

WORKDIR /var/www/html
COPY . .

# Permissões Laravel
RUN chown -R www-data:www-data storage bootstrap/cache database

# Dependências
RUN composer install --no-dev --optimize-autoloader
RUN npm install && npm run build

EXPOSE 8000

CMD php artisan migrate --force && php artisan serve --host=0.0.0.0 --port=${PORT:-8000}

