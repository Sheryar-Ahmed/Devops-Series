#!/bin/bash

DOMAIN="your-domain.com"
EMAIL="your-email@example.com"

echo "Installing Certbot for Let's Encrypt SSL..."
sudo apt install certbot python3-certbot-nginx -y

echo "Requesting SSL certificate for $DOMAIN..."
sudo certbot --nginx -d $DOMAIN -d www.$DOMAIN --email $EMAIL --agree-tos --non-interactive

echo "SSL setup complete!"
