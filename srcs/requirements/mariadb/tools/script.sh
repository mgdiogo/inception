#!/bin/sh

if [ ! -d /run/mysqld ]
then

	mysql_install_db --basedir=/usr --datadir=/var/lib/mysql
fi

if [ ! -d init.sql ]
then
echo 'Creating the init.sql file.'
cat << EOF > init.sql
	USE mysql;
	FLUSH PRIVILEGES;
	ALTER USER 'root'@'localhost' IDENTIFIED BY '$MYSQL_ROOTPASSWORD';
	CREATE DATABASE IF NOT EXISTS $MYSQL_DATABASE;
	CREATE USER IF NOT EXISTS '$MYSQL_USER'@'%';
	SET PASSWORD FOR '$MYSQL_USER'@'%' = PASSWORD('$MYSQL_PASSWORD');
	CREATE USER IF NOT EXISTS '$WP_ADMIN'@'%';
	SET PASSWORD FOR '$WP_ADMIN'@'%' = PASSWORD('$WP_ADMIN_PASS');
	GRANT ALL PRIVILEGES ON wordpress.* TO '$MYSQL_USER'@'%';
	GRANT ALL PRIVILEGES ON wordpress.* TO '$WP_ADMIN'@'%';
	FLUSH PRIVILEGES;
EOF

sed -i 's/^[ \t]*//' init.sql

mysqld --user=mysql --bootstrap < init.sql

fi

exec mysqld --user=mysql --console