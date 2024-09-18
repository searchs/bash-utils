### Runbook: Configuring and Deploying Laravel on Nginx

Here's a detailed runbook for configuring and deploying a Laravel application on Nginx. This guide assumes you have a basic setup with Nginx and PHP already installed. If not, you may need to install these components first.

#### **1. Prerequisites**

1. **Server Requirements:**
   - Ubuntu 24.04 or later
   - Nginx
   - PHP 8.3 or later
   - Composer
   - MySQL or PostgreSQL

2. **Installed Software:**
   - Nginx
   - PHP
   - Composer
   - MySQL or PostgreSQL

#### **2. Install Nginx**

1. **Update Package List:**

   ```bash
   sudo apt update
   ```

2. **Install Nginx:**

   ```bash
   sudo apt install nginx
   ```

3. **Start and Enable Nginx:**

   ```bash
   sudo systemctl start nginx
   sudo systemctl enable nginx
   ```

4. **Allow Nginx Through Firewall:**

   ```bash
   sudo ufw allow 'Nginx Full'
   ```

#### **3. Install PHP**

1. **Add PHP Repository:**

   ```bash
   sudo add-apt-repository ppa:ondrej/php
   sudo apt update
   ```

2. **Install PHP and Required Extensions:**

   ```bash
   sudo apt install php-fpm php-mysql php-xml php-mbstring php-curl php-zip
   ```

3. **Start and Enable PHP-FPM:**

   ```bash
   sudo systemctl start php8.3-fpm
   sudo systemctl enable php8.3-fpm
   ```

#### **4. Install Composer**

1. **Download and Install Composer:**

   ```bash
   curl -sS https://getcomposer.org/installer | php
   sudo mv composer.phar /usr/local/bin/composer
   ```

2. **Verify Installation:**

   ```bash
   composer --version
   ```

#### **5. Configure Nginx for Laravel**

1. **Create Nginx Server Block Configuration:**

   Create a new configuration file for your Laravel site:

   ```bash
   sudo nano /etc/nginx/sites-available/laravel
   ```

   Add the following configuration:

   ```nginx
   server {
       listen 80;
       server_name example.com;  # Replace with your domain or IP address

       root /var/www/laravel/public;  # Replace with the path to your Laravel project
       index index.php index.html index.htm;

       location / {
           try_files $uri $uri/ /index.php?$query_string;
       }

       location ~ \.php$ {
           include snippets/fastcgi-php.conf;
           fastcgi_pass unix:/var/run/php/php8.3-fpm.sock;
           fastcgi_param SCRIPT_FILENAME $document_root$fastcgi_script_name;
           include fastcgi_params;
       }

       location ~ /\.ht {
           deny all;
       }
   }
   ```

2. **Enable the Configuration:**

   ```bash
   sudo ln -s /etc/nginx/sites-available/laravel /etc/nginx/sites-enabled/
   ```

3. **Test Nginx Configuration:**

   ```bash
   sudo nginx -t
   ```

4. **Restart Nginx:**

   ```bash
   sudo systemctl restart nginx
   ```

#### **6. Set Up Laravel**

1. **Clone Laravel Project:**

   Navigate to the directory where you want to install Laravel and clone your project:

   ```bash
   cd /var/www
   sudo git clone https://github.com/your-repo/laravel.git
   cd laravel
   ```

2. **Set Permissions:**

   Ensure the correct permissions for Laravel directories:

   ```bash
   sudo chown -R www-data:www-data /var/www/laravel
   sudo chmod -R 755 /var/www/laravel
   ```

3. **Install Dependencies:**

   ```bash
   composer install
   ```

4. **Create Environment File:**

   Copy the example environment file and configure it:

   ```bash
   cp .env.example .env
   nano .env
   ```

   Configure your `.env` file with your database and other environment settings.

5. **Generate Application Key:**

   ```bash
   php artisan key:generate
   ```

6. **Run Migrations:**

   ```bash
   php artisan migrate
   ```

#### **7. Final Steps**

1. **Check Laravel Installation:**

   Navigate to your domain in a web browser and ensure Laravel is running properly.

2. **Secure Your Application:**

   Consider setting up HTTPS using Certbot for Let's Encrypt:

   ```bash
   sudo apt install certbot python3-certbot-nginx
   sudo certbot --nginx
   ```

3. **Monitor Logs:**

   Check Nginx and Laravel logs for any issues:
   - Nginx logs: `/var/log/nginx/error.log` and `/var/log/nginx/access.log`
   - Laravel logs: `storage/logs/laravel.log`

This runbook should guide you through the process of deploying a Laravel application on Nginx. Adjust paths and configurations as needed for your specific environment.
