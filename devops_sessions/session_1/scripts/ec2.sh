# how to use these scripts:
#   chmod +x setup_ec2.sh deploy_node.sh configure_nginx.sh enable_ssl.sh
#   ./setup_ec2.sh

echo "Updating system and installing dependencies..."
sudo apt update && sudo apt upgrade -y
sudo apt install -y nginx certbot python3-certbot-nginx

echo "Installing Node.js & PM2..."
curl -fsSL https://deb.nodesource.com/setup_18.x | sudo -E bash -
sudo apt install -y nodejs
sudo npm install -g pm2

echo "EC2 setup complete!"


cd /home/ubuntu
git clone <your-repo-url> node_app
cd node_app
npm install
pm2 start server.js --name "node-backend"
pm2 save

echo "Setting up Nginx for React and Node.js..."
sudo tee /etc/nginx/sites-available/default > /dev/null <<EOL
server {
    listen 80;
    server_name your-domain.com;

    location / {
        root /var/www/html;
        index index.html;
        try_files \$uri /index.html;
    }

    location /api/ {
        proxy_pass http://localhost:5000/;
        proxy_http_version 1.1;
        proxy_set_header Upgrade \$http_upgrade;
        proxy_set_header Connection 'upgrade';
        proxy_set_header Host \$host;
        proxy_cache_bypass \$http_upgrade;
    }
}
EOL

sudo systemctl restart nginx
echo "Nginx configuration updated!"


sudo certbot --nginx -d your-domain.com -d www.your-domain.com
sudo systemctl restart nginx
echo "SSL enabled!"


cd /home/ubuntu/react_app
npm run build
echo "React build complete!"
