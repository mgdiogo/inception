FROM debian:bullseye

WORKDIR /var/www/html

# Install required packages
RUN apt-get update && apt-get install -y \
    curl \
    php-fpm \
    php-mysql

# Install wp-cli and make it available in the PATH
RUN curl -O https://raw.githubusercontent.com/wp-cli/builds/gh-pages/phar/wp-cli.phar \
    && chmod +x wp-cli.phar \
    && mv wp-cli.phar /usr/local/bin/wp

# This will be the location for the socket file
RUN mkdir /run/php/ && chmod 755 /run/php/

# Change the default port for php-fpm
RUN sed -i 's+listen = /run/php/php7.4-fpm.sock+listen = 9000+g' /etc/php/7.4/fpm/pool.d/www.conf

COPY /tools/script.sh /

RUN chmod +x /script.sh

EXPOSE 9000

ENTRYPOINT ["/script.sh"]
