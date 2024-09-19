Here’s a runbook for configuring Apache, MariaDB, and deploying a Laravel application on Ubuntu:

### Prerequisites:
- Ubuntu Server (18.04/20.04/22.04)
- Root or a user with sudo privileges
- Basic knowledge of the terminal

---

## 1. **Update the system**

Before you begin, ensure your system is up to date.

```bash
sudo apt update && sudo apt upgrade -y
```

---

## 2. **Install Apache**

Apache is the web server we'll use to serve the Laravel application.

### Install Apache:
```bash
sudo apt install apache2 -y
```

### Enable Apache to start at boot:
```bash
sudo systemctl enable apache2
```

### Start Apache:
```bash
sudo systemctl start apache2
```

### Allow Apache through the firewall:
```bash
sudo ufw allow in "Apache Full"
```

You can confirm that Apache is running by visiting `http://your_server_ip/` in your browser. You should see the Apache default page.

---

## 3. **Install PHP**

Laravel requires PHP, so install PHP and its extensions.

```bash
sudo apt install php libapache2-mod-php php-mysql php-xml php-cli php-mbstring php-zip php-curl php-gd php-bcmath -y
```

Check PHP version:

```bash
php -v
```

---

## 4. **Install MariaDB**

MariaDB will serve as the database for the Laravel application.

### Install MariaDB:
```bash
sudo apt install mariadb-server mariadb-client -y
```

### Secure the installation:
```bash
sudo mysql_secure_installation
```

Follow the prompts to set up the root password and secure the MariaDB instance.

### Start and enable MariaDB:
```bash
sudo systemctl start mariadb
sudo systemctl enable mariadb
```

---

## 5. **Create a Database for Laravel**

You need to create a database and user for Laravel.

### Log in to MariaDB:
```bash
sudo mysql -u root -p
```

### Create the database:
```sql
CREATE DATABASE laravel_db;
```

### Create a database user and give privileges:
```sql
CREATE USER 'laravel_user'@'localhost' IDENTIFIED BY 'password';
GRANT ALL PRIVILEGES ON laravel_db.* TO 'laravel_user'@'localhost';
FLUSH PRIVILEGES;
EXIT;
```

---

## 6. **Install Composer**

Composer is a dependency manager for PHP, required to install Laravel and its packages.

### Install Composer:
```bash
sudo apt install curl -y
curl -sS https://getcomposer.org/installer | php
sudo mv composer.phar /usr/local/bin/composer
sudo chmod +x /usr/local/bin/composer
```

Check Composer version:

```bash
composer -v
```

---

## 7. **Download and Set Up Laravel**

### Navigate to the web root directory:
```bash
cd /var/www/html
```

### Create a new Laravel project:
```bash
composer create-project --prefer-dist laravel/laravel laravel-app
```

### Set the correct permissions for the Laravel directory:
```bash
sudo chown -R www-data:www-data /var/www/html/laravel-app
sudo chmod -R 775 /var/www/html/laravel-app/storage
```

---

## 8. **Configure Apache for Laravel**

### Create a virtual host for the Laravel project:
```bash
sudo nano /etc/apache2/sites-available/laravel-app.conf
```

Add the following configuration:

```apache
<VirtualHost *:80>
    ServerAdmin admin@your_domain.com
    ServerName your_domain.com
    DocumentRoot /var/www/html/laravel-app/public

    <Directory /var/www/html/laravel-app>
        AllowOverride All
        Require all granted
    </Directory>

    ErrorLog ${APACHE_LOG_DIR}/laravel-app_error.log
    CustomLog ${APACHE_LOG_DIR}/laravel-app_access.log combined
</VirtualHost>
```

### Enable the site and the rewrite module:

```bash
sudo a2ensite laravel-app
sudo a2enmod rewrite
```

### Disable the default site if necessary:
```bash
sudo a2dissite 000-default.conf
```

### Restart Apache:
```bash
sudo systemctl restart apache2
```

---

## 9. **Configure Laravel Environment**

### Set up the `.env` file for Laravel to connect to MariaDB:

```bash
sudo nano /var/www/html/laravel-app/.env
```

Update the database settings as follows:

```env
DB_CONNECTION=mysql
DB_HOST=127.0.0.1
DB_PORT=3306
DB_DATABASE=laravel_db
DB_USERNAME=laravel_user
DB_PASSWORD=password
```

### Run Laravel migrations to set up the database:
```bash
cd /var/www/html/laravel-app
php artisan migrate
```

---

## 10. **Set Permissions for Laravel**

### Ensure proper ownership and permissions:
```bash
sudo chown -R www-data:www-data /var/www/html/laravel-app
sudo chmod -R 755 /var/www/html/laravel-app
sudo chmod -R 775 /var/www/html/laravel-app/storage
```

---

## 11. **Test the Laravel App**

Visit `http://your_server_ip/` or `http://your_domain.com/` in a browser, and you should see the default Laravel welcome page.

---

## 12. **Set Up a Swap File (Optional)**

If your server has low memory, creating a swap file can prevent Composer from running out of memory.

### Create a swap file:
```bash
sudo fallocate -l 1G /swapfile
```

### Set the proper permissions:
```bash
sudo chmod 600 /swapfile
```

### Enable the swap:
```bash
sudo mkswap /swapfile
sudo swapon /swapfile
```

Make the swap permanent by adding it to `/etc/fstab`:

```bash
echo '/swapfile none swap sw 0 0' | sudo tee -a /etc/fstab
```

---

## 13. **Optimize Laravel (Optional)**

To optimize Laravel for production, run:

```bash
php artisan config:cache
php artisan route:cache
php artisan view:cache
```

---

### Troubleshooting:

1. **Permission Issues:** Double-check ownership and permissions of Laravel directories, especially `storage` and `bootstrap/cache`.
2. **500 Internal Server Error:** Check Apache logs at `/var/log/apache2/laravel-app_error.log` for detailed error messages.
3. **Database Connection Issues:** Ensure your `.env` file database credentials are correct and the MariaDB service is running properly.

---

With this runbook, you can successfully configure Apache, MariaDB, and deploy a Laravel application on Ubuntu.
