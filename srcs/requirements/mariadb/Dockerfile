FROM debian:bullseye

# Install packages and dependencies

RUN	apt update -y && apt upgrade -y && apt install -y mariadb-server

# Create directories and grant privileges

RUN mkdir -p /run/mysqld && \
	chown -R mysql:mysql /run/mysqld && \
    chown -R mysql:mysql /var/lib/mysql

# Copy script from host machine to container and executes it

COPY tools/script.sh /

RUN chmod +x /script.sh

EXPOSE 3306

ENTRYPOINT ["/script.sh"]

# Start MariaDB in safe mode with internet access

CMD ["mysqld_safe", "--bind-address=0.0.0.0"]