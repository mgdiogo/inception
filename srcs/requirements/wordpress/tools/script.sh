#!/bin/bash

sleep 2

# Creates php directory if it does not exist

if [ ! -d /run/php ]; then
    mkdir /run/php
fi

# If wp-config.php is not found, WordPress will be installed and the said config will be created
if [ ! -e /var/www/html/wp-config.php ]; then

	printf "\nWordPress configuration will now begin! Don't close this process...\n\n"

	# Updates WordPress command line interface to latest version
    wp cli update --yes --allow-root

	# Downloads WordPress files into /var/www/html since it's our working directory
    wp core download --allow-root

	# Creates wp-config.php and ensures it is stored in the correct path
    wp config create --dbhost=$MYSQL_HOST \
                    --dbname=$MYSQL_DATABASE \
                    --dbuser=$MYSQL_USER \
                    --dbpass=$MYSQL_PASSWORD \
                    --path='/var/www/html' \
                    --allow-root

	# Installs WordPress, sets up website details and creates the admin account
    wp core install --title=$WP_TITLE \
                    --admin_user=$WP_ADMIN \
                    --admin_password=$WP_ADMIN_PASS \
                    --admin_email=$WP_ADMIN_EMAIL \
                    --url=$WP_URL \
                    --allow-root
	# Creates second user, which is only needed due to the subject
    wp user create $WP_USER $WP_USER_EMAIL \
                    --user_pass=$WP_USER_PASS \
                    --allow-root

	wp theme install astra --activate --allow-root
	wp theme status astra --allow-root
	wp option update home "https://${WP_URL}" --allow-root
    wp option update siteurl "https://${WP_URL}" --allow-root
else
	printf "WordPress configuration is already present, all services are now up and running!\n"
fi

/usr/sbin/php-fpm7.4 -F