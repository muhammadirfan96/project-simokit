FROM php:8.0-apache

# Install ekstensi PHP yang dibutuhkan
RUN apt-get update && apt-get install -y \
    zip unzip libzip-dev libonig-dev libxml2-dev libgd-dev libicu-dev \
    && docker-php-ext-install pdo pdo_mysql mysqli zip gd intl

# Aktifkan Apache rewrite module
RUN a2enmod rewrite

# Install Composer
COPY --from=composer:2 /usr/bin/composer /usr/bin/composer

# Salin source code ke dalam container
COPY . /var/www/html

# Ubah root Apache ke folder /public
RUN sed -i 's!/var/www/html!/var/www/html/public!g' /etc/apache2/sites-available/000-default.conf

# Beri hak akses ke writable folder dan subfoldernya
RUN chown -R www-data:www-data /var/www/html/writable && \
    chmod -R 755 /var/www/html/writable && \
    find /var/www/html/writable -type d -exec chmod 755 {} \; && \
    find /var/www/html/writable -type f -exec chmod 644 {} \;

# Beri hak akses write, read & execute ke folder public dan subfoldernya
RUN chown -R www-data:www-data /var/www/html/public && \
    chmod -R 755 /var/www/html/public && \
    find /var/www/html/public -type d -exec chmod 755 {} \; && \
    find /var/www/html/public -type f -exec chmod 644 {} \;

WORKDIR /var/www/html
