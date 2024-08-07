FROM debian:bullseye

# Install packages and dependencies

RUN apt update -y && apt upgrade -y && apt install -y nginx openssl

# Create directories to save private key and certificate generated from openssl

RUN mkdir -p /etc/nginx/ssl/certs && mkdir -p /etc/nginx/ssl/private && mkdir -p /var/run/nginx && mkdir -p /var/www

# Generate private key and certificate

RUN openssl req -newkey rsa:4096 -nodes -sha256 -x509 -days 365 -keyout /etc/nginx/ssl/private/server-key.key -out /etc/nginx/ssl/certs/server-crt.crt \
-subj "/C=PT/ST=Setubal/L=Caparica/O=42Lisboa/OU=42/CN=mpedroso.42.fr"

# Copy NGINX configuration file from host machine to container

COPY tools/nginx.conf /etc/nginx/conf.d

RUN mkdir -p /run/nginx

EXPOSE 443

# Here we tell NGINX to not run as a background process but as a foreground process (makes it so the container does not exit when the process is complete)

CMD ["nginx", "-g", "daemon off;"]