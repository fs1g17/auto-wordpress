cd /var/www/html

sudo a2dissite wordpress-ssl.conf
sudo service apache2 restart

sudo certbot certonly --non-interactive --agree-tos --register-unsafely-without-email -d $WORDPRESS_DOMAIN --webroot -w /var/www/html/
sudo a2ensite wordpress-ssl.conf

sudo service apache2 restart
