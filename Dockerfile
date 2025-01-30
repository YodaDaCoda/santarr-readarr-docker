FROM lscr.io/linuxserver/readarr:develop

# Install Nginx, OpenSSL, and CA certificates utilities
RUN apk add --no-cache nginx openssl ca-certificates

# Create directories for CA and certificates
RUN mkdir -p /etc/nginx/ssl /etc/nginx/ca

# Generate a local CA key and certificate
RUN openssl genrsa -out /etc/nginx/ca/ca.key 2048 && \
    openssl req -x509 -new -nodes -key /etc/nginx/ca/ca.key -sha256 -days 3650 \
    -subj "/C=US/ST=State/L=City/O=Organization/CN=LocalCA" \
    -out /etc/nginx/ca/ca.crt

# Generate a private key and certificate for api.bookinfo.club
RUN openssl genrsa -out /etc/nginx/ssl/api.bookinfo.club.key 2048 && \
    openssl req -new -key /etc/nginx/ssl/api.bookinfo.club.key \
    -subj "/C=US/ST=State/L=City/O=Organization/CN=api.bookinfo.club" \
    -out /etc/nginx/ssl/api.bookinfo.club.csr && \
    openssl x509 -req -in /etc/nginx/ssl/api.bookinfo.club.csr -CA /etc/nginx/ca/ca.crt \
    -CAkey /etc/nginx/ca/ca.key -CAcreateserial -out /etc/nginx/ssl/api.bookinfo.club.crt \
    -days 3650 -sha256

# Generate a private key and certificate for www.goodreads.com
RUN openssl genrsa -out /etc/nginx/ssl/www.goodreads.com.key 2048 && \
    openssl req -new -key /etc/nginx/ssl/www.goodreads.com.key \
    -subj "/C=US/ST=State/L=City/O=Organization/CN=www.goodreads.com" \
    -out /etc/nginx/ssl/www.goodreads.com.csr && \
    openssl x509 -req -in /etc/nginx/ssl/www.goodreads.com.csr -CA /etc/nginx/ca/ca.crt \
    -CAkey /etc/nginx/ca/ca.key -CAcreateserial -out /etc/nginx/ssl/www.goodreads.com.crt \
    -days 3650 -sha256

# Add the CA certificate to the system's trust store
RUN cp /etc/nginx/ca/ca.crt /usr/local/share/ca-certificates/local_ca.crt && \
    update-ca-certificates

# Copy custom Nginx configuration
COPY nginx.conf /etc/nginx/nginx.conf

# Expose HTTPS port
EXPOSE 443

# Set environment variable for METADATA_SERVER
ENV METADATA_SERVER=""

COPY start-nginx.sh /usr/local/bin/
RUN chmod +x /usr/local/bin/start-nginx.sh
ENTRYPOINT ["/bin/sh", "-c", "/usr/local/bin/start-nginx.sh & /init"]
