# Imagem base do PHP com Apache
FROM php:7.4-apache

# Instalar dependências
RUN apt-get update && apt-get install -y \
  libpng-dev \
  libjpeg-dev \
  libfreetype6-dev \
  zip \
  git

# Configurar extensões do PHP
RUN docker-php-ext-configure gd --with-freetype --with-jpeg \
  && docker-php-ext-install gd pdo pdo_mysql

# Habilitar mod_rewrite do Apache
RUN a2enmod rewrite

# Instalar Composer globalmente
RUN curl -sS https://getcomposer.org/installer | php -- --install-dir=/usr/local/bin --filename=composer

# Definir o diretório de trabalho temporário
WORKDIR /var/www

# Instalar UVdesk via Composer
RUN composer create-project uvdesk/community-skeleton helpdesk-project

# Mover os arquivos para o diretório correto
RUN mv helpdesk-project/* /var/www/html/ \
  && mv helpdesk-project/.[!.]* /var/www/html/
