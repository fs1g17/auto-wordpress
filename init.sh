#!/bin/sh

sudo apt update -y
sudo apt upgrade -y

sudo apt install apache2 -y

# Get helper files from repo
sudo cp /home/wlspro/source/wordpress.conf /etc/apache2/sites-available/wordpress.conf

# the wordpress-ssl is slightly wrong - it need to have 
sudo a2enmod rewrite
sudo a2enmod ssl
sudo a2ensite wordpress.conf
sudo service apache2 restart

# Mysql
sudo apt install mysql-server -y
sudo mysql -e "CREATE DATABASE wordpress;"
sudo mysql -e "CREATE USER 'wp_user'@'localhost' IDENTIFIED BY 'password';"
sudo mysql -e "GRANT ALL ON wordpress.* TO 'wp_user'@'localhost';"
sudo mysql -e "FLUSH PRIVILEGES;"

# PHP default version install
sudo apt install php -y
sudo apt install php-curl php-gd php-mbstring php-xml php-xmlrpc php-soap php-intl php-zip -y
sudo apt install libapache2-mod-php -y
sudo apt install php-mysql -y
sudo apt install php-imagick -y

cd /etc/php/7.4/apache2
sudo cp php.ini phpoldini.txt
sudo cp /home/wlspro/source/php74.ini /etc/php/7.4/apache2/php.ini

# delete the apache default index.html
sudo rm /var/www/html/index.html

# checks for syntax errors in apache conf
sudo apache2ctl configtest
sudo systemctl restart apache2

cd /home/wlspro
sudo curl -O https://raw.githubusercontent.com/wp-cli/builds/gh-pages/phar/wp-cli.phar
sudo chmod +x wp-cli.phar
sudo mv wp-cli.phar /usr/local/bin/wp

cd /var/www/html
sudo chown -R www-data:www-data /var/www
sudo -u www-data wp core download
sudo -u www-data wp core config --dbname='wordpress' --dbuser='wp_user' --dbpass='password' --dbhost='localhost' --dbprefix='wp_'

sudo chmod -R 755 /var/www/html/wp-content

sudo -u www-data wp core install --url="$URL" --title="$TITLE" --admin_user="$ADMIN_USER" --admin_password="$ADMIN_PASSWORD" --admin_email="$ADMIN_EMAIL"

sudo systemctl restart apache2

sudo snap install --classic certbot
sudo ln -s /snap/bin/certbot /usr/bin/certbot
sudo certbot certonly --non-interactive --agree-tos --register-unsafely-without-email -d randomgarbage.site --webroot -w /var/www/html/

# Copy ssl conf file
sudo cp /home/wlspro/source/wordpress-ssl.conf /etc/apache2/sites-available/wordpress-ssl.conf

# activate the ssl site and restart apache
sudo a2ensite wordpress-ssl.conf
sudo service apache2 restart
