#!/bin/sh

# Extract the hostname from METADATA_SERVER
METADATA_HOST=$(echo "$METADATA_SERVER" | sed -E 's|https?://([^/]+).*|\1|')

# Replace placeholders in the nginx configuration
sed -i "s|\[METADATA_SERVER\]|${METADATA_SERVER}|g" /etc/nginx/nginx.conf
sed -i "s|\[METADATA_HOST\]|${METADATA_HOST}|g" /etc/nginx/nginx.conf

# Start nginx
exec nginx -g 'daemon off;'
