#!/bin/sh

# Check if WordPress config file exists
if [ -f ./wp-config.php ]
then
	echo "[Wordpress startup 0] WordPress config file already present."
else
	echo "Setting up WordPress"
	wp cli update --yes --allow-root
	wp core download --allow-root
	echo "Creating wp-config.php"
	wp config create \
	--dbname=${MYSQL_DATABASE} \
	--dbuser=${MYSQL_USER} \
	--dbpass=${MYSQL_PASSWORD} \
	--dbhost=${MYSQL_HOST} --allow-root
	
	# Check if wp-config.php was created successfully
	if [ -f ./wp-config.php ]
	then
		echo "WordPress config file created successfully."
		echo "Installing WordPress core"
		wp core install \
		--url=${WP_URL} \
		--title=${WP_TITLE} \
		--admin_user=${WP_ADMIN} \
		--admin_password=${WP_ADMIN_PASS} \
		--admin_email=${WP_ADMIN_EMAIL} --allow-root
		echo "Creating WordPress default user"
		wp user create \
		${WP_USER} ${WP_USER_EMAIL} --user_pass=${WP_USER_PASSWORD} --role=author --allow-root
		echo "Installing WordPress theme"
		wp theme install bravada --activate --allow-root
		wp theme status bravada --allow-root
		echo "Setting WP_HOME and WP_SITEURL"
		wp option update home "https://${WP_URL}" --allow-root
		wp option update siteurl "https://${WP_URL}" --allow-root
	else
		echo "Error: WordPress config file was not created. Exiting."
		exit 1
	fi
fi

echo "Starting WordPress fastCGI on port 9000."

/usr/sbin/php-fpm7.4 -F