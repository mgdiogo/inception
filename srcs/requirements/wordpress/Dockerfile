FROM debian:bullseye

WORKDIR /var/www/html

RUN apt-get update -y && \
    apt-get upgrade -y

RUN apt-get install -y wget php-fpm php-mysql mariadb-client curl 

COPY tools/script.sh /script.sh
RUN sed -i 's/\r//' /script.sh
RUN chmod +x /script.sh
RUN sed -i 's+listen = /run/php/php7.4-fpm.sock+listen = 9000+g' /etc/php/7.4/fpm/pool.d/www.conf

RUN chown -R www-data:www-data /var/www/html && \
    find /var/www/html -type d -exec chmod 755 {} \; && \
    find /var/www/html -type f -exec chmod 644 {} \;

RUN apt-get update && apt-get install -y curl && \
    curl -O https://raw.githubusercontent.com/wp-cli/builds/gh-pages/phar/wp-cli.phar && \
    chmod +x wp-cli.phar && \
    mv wp-cli.phar /usr/local/bin/wp

RUN chown -R www-data:www-data /var/www/html

RUN chmod -R 755 /var/www/html/

EXPOSE 9000

ENTRYPOINT ["/script.sh"]