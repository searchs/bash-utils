#!/bin/bash

# Server: Ubuntu 24.04

# ACTION: Make this script executable: chmod +x nginx-wordpress-ubuntu-installer.sh

## NGINX and WordPress Installation on Ubuntu Script
# Update system
sudo apt update && sudo apt upgrade -y

# Install Nginx
sudo apt install nginx -y
sudo systemctl start nginx
sudo systemctl enable nginx

# Install MySQL Server
sudo apt install mysql-server -y
sudo systemctl start mysql
sudo systemctl enable mysql

# Create MySQL Database and User for WordPress
DB_NAME="database_name"
DB_USER="db_user"
DB_PASSWORD="db_complex+password"

sudo mysql -e "CREATE DATABASE ${DB_NAME};"
sudo mysql -e "CREATE USER '${DB_USER}'@'localhost' IDENTIFIED BY '${DB_PASSWORD}';"
sudo mysql -e "GRANT ALL PRIVILEGES ON ${DB_NAME}.* TO '${DB_USER}'@'localhost';"
sudo mysql -e "FLUSH PRIVILEGES;"

# Install PHP and dependencies
sudo apt install php-fpm php-mysql php-cli -y

# Download WordPress
wget -c http://wordpress.org/latest.tar.gz
tar -xzvf latest.tar.gz
mv wordpress sitename
sudo mv sitename /var/www/html/

# Set proper permissions
sudo chown -R www-data:www-data /var/www/html/sitename
sudo chmod -R 755 /var/www/html/sitename

# Configure Nginx for WordPress
cat <<EOL | sudo tee /etc/nginx/sites-available/sitename
server {
    listen 80;
    root /var/www/html/sitename;
    index index.php index.html index.htm;
    server_name _;

    location / {
        try_files \$uri \$uri/ /index.php?\$args;
    }

    location ~ \.php\$ {
        include snippets/fastcgi-php.conf;
        fastcgi_pass unix:/var/run/php/php-fpm.sock;
    }

    location ~ /\.ht {
        deny all;
    }
}
EOL

# Enable the WordPress Nginx config and restart Nginx
sudo ln -s /etc/nginx/sites-available/sitename /etc/nginx/sites-enabled/
sudo systemctl reload nginx

# Output WordPress installation details
echo "Nginx and WordPress installation completed."
echo "MySQL Database: ${DB_NAME}"
echo "MySQL User: ${DB_USER}"
echo "MySQL Password: ${DB_PASSWORD}"

# Add Letsencrypt SSL certificate - TODO: you need an email address for this step
sudo apt install certbot python3-certbot-nginx -y
sudo certbot --nginx -d sitename.tld -d www.sitename.tld --agree-to-tos

