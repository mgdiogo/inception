#!/bin/bash

sleep 5

if [ ! -d /run/php ]; then
    mkdir /run/php
fi

if [ ! -e /var/www/html/wp-config.php ]; then
    wp cli update --yes --allow-root

    wp core download --allow-root

    wp config create --dbhost=$MYSQL_HOST \
                    --dbname=$MYSQL_DATABASE \
                    --dbuser=$MYSQL_USER \
                    --dbpass=$MYSQL_PASSWORD \
                    --path='/var/www/html' \
                    --allow-root

    wp core install --title=$WP_TITLE \
                    --admin_user=$WP_ADMIN \
                    --admin_password=$WP_ADMIN_PASS \
                    --admin_email=$WP_ADMIN_EMAIL \
                    --url=$WP_URL \
                    --allow-root

    wp user create $WP_USER $WP_USER_EMAIL \
                    --role=author --user_pass=$WP_USER_PASS \
                    --allow-root

	wp theme install bravada --activate --allow-root
	wp theme status bravada --allow-root
	wp option update home "https://${WP_URL}" --allow-root
    wp option update siteurl "https://${WP_URL}" --allow-root

fi

/usr/sbin/php-fpm7.4 -F