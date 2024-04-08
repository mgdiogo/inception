FROM debian:bullseye

# Install packages and dependencies

RUN apt update -y && apt upgrade -y && apt install -y mariadb-server

# Copy script from host machine to container and executes it

COPY tools/script.sh /

COPY tools/50-server.cnf /etc/mysql/mariadb.conf.d/50-server.cnf

RUN chmod +x /script.sh

# Create directories and grant privileges

RUN mkdir -p /run/mysqld && \
    chown -R mysql:mysql /run/mysqld && \
    chown -R mysql:mysql /var/lib/mysql

EXPOSE 3306

ENTRYPOINT ["/script.sh"]
