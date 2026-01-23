# 1. Usar a imagem oficial do PHP com FPM
FROM php:8.2-fpm

# 2. Instalar dependências do sistema e extensões do PHP para PostgreSQL
# O libpq-dev é essencial para o driver pdo_pgsql
RUN apt-get update && apt-get install -y \
    libpq-dev \
    git \
    unzip \
    zip \
    && docker-php-ext-install pdo pdo_pgsql

# 3. Instalar o Composer (copiando o binário oficial da versão 2)
COPY --from=composer:2.6 /usr/bin/composer /usr/bin/composer

# 4. Definir diretório de trabalho dentro do container
WORKDIR /var/www

# 5. Copiar os arquivos de dependências primeiro (otimiza o cache do Docker)
COPY composer.json composer.lock ./

# 6. Instalar dependências do PHP sem pacotes de desenvolvimento
RUN /usr/bin/composer install --no-dev --optimize-autoloader --no-scripts

# 7. Copiar todo o resto do código do projeto para o container
COPY . .

# 8. Dar permissões de escrita para as pastas que o Laravel precisa
RUN chown -R www-data:www-data /var/www/storage /var/www/bootstrap/cache
RUN chmod -R 775 /var/www/storage /var/www/bootstrap/cache

# 9. Expor a porta que o Railway utiliza por padrão
EXPOSE 8080

# 10. Comando de Inicialização:
# - Roda as migrações (cria as tabelas no Postgres)
# - Inicia o servidor do Laravel na porta 8080
CMD php artisan migrate --force && php artisan serve --host=0.0.0.0 --port=8080