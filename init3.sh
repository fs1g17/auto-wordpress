cd /var/www/html

sudo certbot certonly --non-interactive --agree-tos --register-unsafely-without-email -d $WORDPRESS_DOMAIN --webroot -w /var/www/html/ && \
# env subst WORDPRESS_DOMAIN
sed -i "s/\${WORDPRESS_DOMAIN}/$WORDPRESS_DOMAIN/g" /home/wlspro/source/wordpress-ssl.conf && \
# Copy ssl conf file
sudo cp /home/wlspro/source/wordpress-ssl.conf /etc/apache2/sites-available/wordpress-ssl.conf && \
# activate the ssl site and restart apache
sudo a2enmod ssl && \
sudo a2ensite wordpress-ssl.conf && \
sudo service apache2 restart
