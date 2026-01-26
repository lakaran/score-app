FROM php:8.2-cli

# System deps
RUN apt-get update && apt-get install -y \
    git \
    curl \
    zip \
    unzip \
    sqlite3 \
    libsqlite3-dev \
    default-mysql-client \
    libmysqlclient-dev \
    nodejs \
    npm

# PHP extensions
RUN docker-php-ext-install pdo pdo_mysql pdo_sqlite

# Composer
COPY --from=composer:latest /usr/bin/composer /usr/bin/composer

# Workdir
WORKDIR /var/www/html

# Copy project
COPY . .

# Install PHP deps
RUN composer install --no-dev --optimize-autoloader

# Install Node deps
RUN npm install && npm run build || true

# Permissions
RUN chown -R www-data:www-data storage bootstrap/cache database

# Expose port
EXPOSE 8000

# Start app
CMD php artisan key:generate --force && \
    php artisan migrate --force && \
    php artisan serve --host=0.0.0.0 --port=8000

