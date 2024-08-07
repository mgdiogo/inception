#!/bin/sh

# Checks if path exists, if not it means mysql is not installed and begins to install it

if [ ! -d /run/mysqld ]
then

	mysql_install_db --basedir=/usr --datadir=/var/lib/mysql
fi

# If there is no initial script then we will create it, the script creates the database, users, and grants previleges

if [ ! -d init.sql ]
then
echo 'Data not found... creating initializing script!'
cat << EOF > init.sql
	USE mysql;
	FLUSH PRIVILEGES;
	ALTER USER 'root'@'localhost' IDENTIFIED BY '$MYSQL_ROOTPASSWORD';
	CREATE DATABASE IF NOT EXISTS $MYSQL_DATABASE;
	CREATE USER IF NOT EXISTS '$MYSQL_USER'@'%';
	SET PASSWORD FOR '$MYSQL_USER'@'%' = PASSWORD('$MYSQL_PASSWORD');
	GRANT ALL PRIVILEGES ON wordpress.* TO '$MYSQL_USER'@'%';
	FLUSH PRIVILEGES;
EOF

sed -i 's/^[ \t]*//' init.sql

mysqld --user=mysql --bootstrap < init.sql

fi

exec mysqld --user=mysql --console