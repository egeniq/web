FROM php:7.1-apache

# Install some packages and extensions
RUN apt-get -qq update && \
    apt-get -y install curl git wget zlib1g-dev mysql-client libxml2-dev locales vim rsyslog && \
    docker-php-ext-configure pdo_mysql --with-pdo-mysql=mysqlnd && \
    docker-php-ext-configure mysqli --with-mysqli=mysqlnd && \
    docker-php-ext-install zip && \
    docker-php-ext-install pcntl && \
    docker-php-ext-install calendar && \
    docker-php-ext-install pdo_mysql && \
    docker-php-ext-install soap && \
    docker-php-ext-install opcache && \
    docker-php-ext-enable opcache && \
    docker-php-ext-enable soap && \
    a2enmod rewrite deflate

# Locales
COPY assets/locale.gen /etc/locale.gen
RUN locale-gen

# Copy assets and sources
COPY assets/default.conf /etc/apache2/sites-available/000-default.conf
COPY assets/security.conf /etc/apache2/conf-available/security.conf
COPY assets/apache2.conf /etc/apache2/apache2.conf

EXPOSE 80
CMD ["apache2-foreground"]
