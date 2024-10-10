#!/bin/bash

# Variables - modify these to match your settings
DOMAIN="example.com" # Replace with your domain or server IP
LARAVEL_PATH="/var/www/laravel" # Replace with the path to your Laravel project
PHP_VERSION="7.4" # Set the correct PHP version

# Update package lists and install prerequisites
echo "Updating system packages..."
apt update && apt upgrade -y

# Install Nginx
echo "Installing Nginx..."
apt install -y nginx

# Install PHP and extensions
echo "Installing PHP and required extensions..."
add-apt-repository ppa:ondrej/php -y
apt update
apt install -y php${PHP_VERSION}-fpm php${PHP_VERSION}-mysql php${PHP_VERSION}-xml php${PHP_VERSION}-mbstring php${PHP_VERSION}-curl php${PHP_VERSION}-zip

# Install Composer
echo "Installing Composer..."
curl -sS https://getcomposer.org/installer | php
mv composer.phar /usr/local/bin/composer

# Create Nginx configuration for Laravel
echo "Configuring Nginx for Laravel..."
cat > /etc/nginx/sites-available/laravel <<EOF
server {
    listen 80;
    server_name ${DOMAIN};

    root ${LARAVEL_PATH}/public;
    index index.php index.html index.htm;

    location / {
        try_files \$uri \$uri/ /index.php?\$query_string;
    }

    location ~ \.php\$ {
        include snippets/fastcgi-php.conf;
        fastcgi_pass unix:/var/run/php/php${PHP_VERSION}-fpm.sock;
        fastcgi_param SCRIPT_FILENAME \$document_root\$fastcgi_script_name;
        include fastcgi_params;
    }

    location ~ /\.ht {
        deny all;
    }
}
EOF

# Enable the Laravel site and restart Nginx
ln -s /etc/nginx/sites-available/laravel /etc/nginx/sites-enabled/
nginx -t && systemctl restart nginx

# Clone Laravel project
if [ ! -d "$LARAVEL_PATH" ]; then
    echo "Cloning Laravel project..."
    git clone https://github.com/your-repo/laravel.git ${LARAVEL_PATH}
fi

# Set permissions for Laravel directories
echo "Setting permissions..."
chown -R www-data:www-data ${LARAVEL_PATH}
chmod -R 755 ${LARAVEL_PATH}

# Install Laravel dependencies
echo "Installing Laravel dependencies with Composer..."
cd ${LARAVEL_PATH}
composer install

# Configure environment file
echo "Setting up environment file..."
cp .env.example .env
php artisan key:generate

# Update .env file (you can automate this part by modifying this section)
echo "Please edit your .env file to set up your database and other environment variables."
nano .env

# Run Laravel migrations
echo "Running Laravel migrations..."
php artisan migrate

# Allow Nginx through firewall
echo "Allowing Nginx through the firewall..."
ufw allow 'Nginx Full'

# Option to set up HTTPS with Let's Encrypt
read -p "Do you want to set up HTTPS with Let's Encrypt? (y/n): " ssl_choice
if [ "$ssl_choice" = "y" ]; then
    echo "Installing Certbot..."
    apt install -y certbot python3-certbot-nginx
    certbot --nginx -d ${DOMAIN}
fi

# Completion message
echo "Laravel application has been deployed successfully!"
echo "Access your application at http://${DOMAIN}"
