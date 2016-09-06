# Egeniq Web Stack
# Version 0.1

# Start with Ubuntu 14.04 LTS
FROM ubuntu:14.04

MAINTAINER Peter Verhage <peter@egeniq.com>

ENV DEBIAN_FRONTEND noninteractive

# Install Nginx, PHP5, node, ...
RUN apt-get -qq update && \
    apt-get install -qq software-properties-common && \
    apt-key adv --keyserver keyserver.ubuntu.com --recv-keys 4F4EA0AAE5267A6C && \
    apt-get update -qq && \
    apt-get install -qq wget nginx nginx-extras php5-cli php5-fpm php5-mysql php5-curl php5-intl git nodejs npm && \
    usermod -u 1000 www-data && \
    locale-gen nl_NL.UTF-8 && \ 
    npm install --global n && \
    n 6.2.1 && \
    npm install --global gulp-cli
    
# Update configuration
RUN echo "daemon off;" >> /etc/nginx/nginx.conf && \
    sed -i "s/;date.timezone =.*/date.timezone = UTC/" /etc/php5/fpm/php.ini && \
    sed -i "s/;date.timezone =.*/date.timezone = UTC/" /etc/php5/cli/php.ini && \
    sed -i "s/pm.max_children = 5/pm.max_children = 50/" /etc/php5/fpm/pool.d/www.conf && \
    sed -i "s/pm.start_servers = 2/pm.start_servers = 10/" /etc/php5/fpm/pool.d/www.conf && \
    sed -i "s/pm.min_spare_servers = 1/pm.min_spare_servers = 5/" /etc/php5/fpm/pool.d/www.conf && \
    sed -i "s/pm.max_spare_servers = 3/pm.max_spare_servers = 20/" /etc/php5/fpm/pool.d/www.conf

# Install assets
COPY assets/start.sh /start.sh
COPY assets/vhost-default /etc/nginx/sites-available/default

# Defaults
WORKDIR /src
EXPOSE 80
CMD "/start.sh"
