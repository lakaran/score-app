# Imagem base do PHP
FROM php:8.2-fpm

# Dependências do sistema
RUN apt-get update && apt-get install -y \
    git \
    curl \
    zip \
    unzip \
    sqlite3 \
    libsqlite3-dev \
    libmariadb-dev \
    libpq-dev \
    && docker-php-ext-install pdo pdo_mysql pdo_sqlite pdo_pgsql

# Instalar Node.js 20
RUN curl -fsSL https://deb.nodesource.com/setup_20.x | bash - && \
    apt-get install -y nodejs

# Instalar Composer
RUN curl -sS https://getcomposer.org/installer | php -- --install-dir=/usr/local/bin --filename=composer

# Definir diretório de trabalho
WORKDIR /var/www/html

# Copiar arquivos do projeto
COPY . .

# Instalar dependências do Laravel
RUN composer install --no-dev --optimize-autoloader

# Instalar dependências do frontend (se existirem)
RUN npm install && npm run build || true

# Dar permissões às pastas necessárias
RUN chmod -R 775 storage bootstrap/cache

# Gerar cache de configuração
RUN php artisan config:cache || true

# Rodar migrations automaticamente e iniciar o servidor
CMD php artisan migrate --force && php artisan serve --host=0.0.0.0 --port=$PORT