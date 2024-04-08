FROM debian:bullseye

# Install packages and dependencies

RUN	apt update -y && apt upgrade -y && apt install -y nginx openssl

# Create directories to save private key and certificate generated from openssl

RUN mkdir -p /etc/nginx/ssl/certs && mkdir -p /etc/nginx/ssl/private

# Generate private key and certificate

RUN openssl req -new -newkey rsa:2048 -nodes -sha256 -x509 -keyout /etc/nginx/ssl/private/server-key.key -out /etc/nginx/ssl/certs/server-crt.crt \
-subj "/C=PT/ST=Setubal/L=Caparica/O=42Lisboa/OU=42/CN=mpedroso.42.fr"

# Copy NGINX configuration file from host machine to container

COPY tools/nginx.conf /etc/nginx/conf.d

EXPOSE 443

CMD ["nginx", "-g", "daemon off;"]