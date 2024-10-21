#!/bin/bash

# Update and upgrade the system
sudo apt update && sudo apt upgrade -y

# Install PHP and required extensions
sudo apt install -y php php-cli php-fpm php-json php-common php-mysql php-zip php-gd php-mbstring php-curl php-xml php-pear php-bcmath

# Install Composer
php -r "copy('https://getcomposer.org/installer', 'composer-setup.php');"
php -r "if (hash_file('sha384', 'composer-setup.php') === '55ce33d7678c5a611085589f1f3ddf8b3c52d662cd01d4ba75c0ee0459970c2200a51f492d557530c71c15d8dba01eae') { echo 'Installer verified'; } else { echo 'Installer corrupt'; unlink('composer-setup.php'); } echo PHP_EOL;"
php composer-setup.php
php -r "unlink('composer-setup.php');"
sudo mv composer.phar /usr/local/bin/composer

# Install Node.js and npm (required for Statamic's asset compilation)
curl -sL https://deb.nodesource.com/setup_14.x | sudo -E bash -
sudo apt install -y nodejs

# Create a new Statamic project
read -p "Enter your Statamic project name: " project_name
composer create-project statamic/statamic "$project_name"

# Navigate to the project directory
cd "$project_name"

# Set appropriate permissions
sudo chown -R $USER:www-data .
sudo find . -type f -exec chmod 664 {} \;
sudo find . -type d -exec chmod 775 {} \;
sudo chmod -R ug+rwx storage bootstrap/cache

# Install dependencies and compile assets
npm install
npm run dev

# Create an .env file
cp .env.example .env
php artisan key:generate

# Set up a local development server
echo "Your Statamic project has been set up."
echo "To start a development server, run:"
echo "php artisan serve"

# Optionally, you can automatically start the server
# php artisan serve