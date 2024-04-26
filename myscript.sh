#!/bin/bash
#update all properties
sudo apt install software-properties-common -y
#update packages
sudo apt update

# Add Ond�~Yej Surý's PPA for latest PHP versions (replace with your preferred PPA if needed)
sudo add-apt-repository ppa:ondrej/php -y

# Update package lists to include new PPA packages
sudo apt update

# Install PHP 8.2 and important extensions
sudo apt install -y php8.2 php8.2-xml php8.2-mbstring php8.2-dom php8.2-zip php8.2-curl php8.2-redis php8.2-gd php8.2-intl php8.2-bcmath php8.2-mysql zip unzip


# Install Apache2 web server
sudo apt install apache2 -y

# Enable mod_rewrite for URL rewriting (essential for Laravel)
sudo a2enmod rewrite -y

# Restart Apache2 to apply changes
#sudo systemctl restart apache2

echo "PHP 8.2 installation complete!"
echo "To verify PHP version, run: php -m"
echo "To test Apache2, open http://localhost in the web browser."

cd /usr/local/bin

#install composer for PHP dependencies
install composer globally -y
curl -sS https://getcomposer.org/installer | sudo php -q

#change location of default composer.phar to composer to differentiate it for PHP dependencies
sudo mv composer.phar composer

#check and confirm that git is installed, if not install it to clone remote directory.
sudo apt install git -y

#change to new directory to clone repo in /var/www
cd /var/www/
sudo git clone https://github.com/laravel/laravel.git
sudo chown -R $USER:$USER /var/www/laravel
cd laravel/
install composer autoloader
composer install --optimize-autoloader --no-dev --no-interaction
composer update --no-interaction
#copy contents of default .env file to new .env file
sudo cp .env.example .env
sudo php artisan key:generate

sudo chown -R www-data storage
sudo chown -R www-data bootstrap/cache
cd ~
cd /etc/apache2/sites-available/
sudo touch laravel.conf
sudo echo '<VirtualHost *:80>
    ServerName localhost
        DocumentRoot /var/www/laravel/public

            <Directory /var/www/laravel>
                    AllowOverride All
                        </Directory>

                            ErrorLog ${APACHE_LOG_DIR}/laravel-error.log
                                CustomLog ${APACHE_LOG_DIR}/laravel-access.log combined
                                </VirtualHost>' | sudo tee /etc/apache2/sites-available/laravel.conf

                                sudo a2dissite 000-default.conf
                                sudo a2ensite laravel.conf
                                sudo systemctl restart apache2
                                cd
                                #Install mysql
                                sudo apt install mysql-server -y
                                sudo apt install mysql-client -y
                                sudo systemctl start mysql


                                # Secure MySQL Installation
                                # Note: Obong, Dan, dev are placeholders for the secure installation prompts and can be
                                sudo mysql -uroot -e "CREATE DATABASE Obong;"
                                sudo mysql -uroot -e "CREATE USER 'Dan'@'localhost' IDENTIFIED BY 'Dev';"
                                sudo mysql -uroot -e "GRANT ALL PRIVILEGES ON Obong.* TO 'Dan'@'localhost';"
                                cd /var/www/laravel
                                #edit laravel document to include new additions
                                sudo sed -i "23 s/^#//g" /var/www/laravel/.env
                                sudo sed -i "24 s/^#//g" /var/www/laravel/.env
                                sudo sed -i "25 s/^#//g" /var/www/laravel/.env
                                sudo sed -i "26 s/^#//g" /var/www/laravel/.env
                                sudo sed -i "27 s/^#//g" /var/www/laravel/.env
                                sudo sed -i '22 s/=sqlite/=mysql/' /var/www/laravel/.env
                                sudo sed -i '23 s/=127.0.0.1/=localhost/' /var/www/laravel/.env
                                sudo sed -i '25 s/=laravel/=Obong/' /var/www/laravel/.env
                                sudo sed -i '26 s/=root/=Dan/' /var/www/laravel/.env
                                sudo sed -i '27 s/=/=Dev/' /var/www/laravel/.env
				  sudo php artisan migrate
                                sudo php artisan storage:link
                                sudo php artisan db:seed
                                #restart apache2 to apply new changes
                                sudo systemctl restart apache2


