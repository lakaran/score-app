FROM php:8.2-cli

# Dependências do sistema
RUN apt-get update && apt-get install -y \
    git unzip zip sqlite3 libsqlite3-dev libzip-dev \
    && docker-php-ext-install pdo pdo_sqlite zip

# Instalar Composer
COPY --from=composer:2 /usr/bin/composer /usr/bin/composer

WORKDIR /app

# Copiar projeto
COPY . .

# Instalar dependências PHP
RUN composer install --no-dev --optimize-autoloader

# Criar base de dados SQLite
RUN mkdir -p /data && touch /data/database.sqlite

# Permissões
RUN chown -R www-data:www-data /data storage bootstrap/cache

# Variáveis de ambiente
ENV APP_ENV=production
ENV APP_DEBUG=false
ENV DB_CONNECTION=sqlite
ENV DB_DATABASE=/data/database.sqlite
ENV CACHE_DRIVER=file
ENV SESSION_DRIVER=file
ENV LOG_CHANNEL=stderr

EXPOSE 8080

# 🚀 Comando que mantém o container vivo
CMD php artisan migrate --force && \
    php artisan serve --host=0.0.0.0 --port=${PORT}

