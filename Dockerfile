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
RUN curl -fsSL https://deb.nodesource.com/setup_20.x | bash - \
    && apt-get install -y nodejs

WORKDIR /var/www/html
COPY . .

# Permissões Laravel
RUN chown -R www-data:www-data storage bootstrap/cache database
RUN chmod -R 775 storage bootstrap/cache

# Dependências
RUN composer install --no-dev --optimize-autoloader
#RUN npm install && npm run build || true


#EXPOSE 8080
EXPOSE 10000


# Limpa caches antigos e garante que as novas rotas sejam lidas

#CMD php artisan config:clear && \
   # php artisan route:clear && \
   # php artisan view:clear && \
   # php artisan cache:clear && \
    #php artisan migrate --force && \
    #php -S 0.0.0.0:${PORT:-8080} -t public

CMD php artisan serve --host=0.0.0.0 --port=$PORT


