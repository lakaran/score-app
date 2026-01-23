FROM php:8.2-fpm

# 1. Instalar dependências do sistema e extensões para PostgreSQL
RUN apt-get update && apt-get install -y \
    git \
    unzip \
    libpq-dev \
    && docker-php-ext-install pdo pdo_pgsql

# 2. Instalar o Composer (Copiando o binário oficial)
COPY --from=composer:2.6 /usr/bin/composer /usr/bin/composer

# 3. Definir o diretório de trabalho
WORKDIR /var/www

# 4. Copiar primeiro os ficheiros de dependências
# Isso ajuda o Railway a fazer o build mais rápido (cache)
COPY composer.json composer.lock ./

# 5. Instalar as dependências ANTES de copiar o resto do código
# Usamos o caminho completo /usr/bin/composer para não haver erro
RUN /usr/bin/composer install --no-dev --optimize-autoloader --no-scripts

# 6. Copiar o restante do projeto
COPY . .

# 7. Ajustar permissões para o Laravel
RUN chown -R www-data:www-data /var/www/storage /var/www/bootstrap/cache

# Porta do Railway
EXPOSE 8080

# Comando para iniciar
CMD php artisan serve --host=0.0.0.0 --port=8080