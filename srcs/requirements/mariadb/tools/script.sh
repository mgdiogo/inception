#!/bin/sh

if [ ! -d "/var/lib/mysql/$MYSQL_DATABASE" ]; then

service mariadb start

mysql_secure_installation << END

Y
$MYSQL_ROOTPASSWORD
$MYSQL_ROOTPASSWORD
Y
Y
Y
Y
END
echo "Creating database $MYSQL_DATABASE..."
    sleep 1
    mysql -u root -e "CREATE DATABASE $MYSQL_DATABASE;"
    mysql -u root -e "CREATE USER '$MYSQL_USER'@'%' IDENTIFIED BY '$MYSQL_PASSWORD';"
    mysql -u root -e "GRANT ALL PRIVILEGES ON *.* TO '$MYSQL_USER'@'%';"
    mysql -u root -e "FLUSH PRIVILEGES;"

    mysql -u root -e "ALTER USER 'root'@'localhost' IDENTIFIED BY '$MYSQL_ROOTPASSWORD';"
    mysql -u root -p$MYSQL_ROOTPASSWORD -e "FLUSH PRIVILEGES;"
    mysqladmin -u root -p$MYSQL_ROOTPASSWORD shutdown

	echo "Finished creating database, user privileges granted\n"
else
    sleep 1
    echo "Database already exists... continuing"
fi


# Keeps mariadb server running

exec mysqld --user=mysql --console