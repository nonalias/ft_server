# give privileges
chmod 775 /start.sh

chmod 775 -R /var/www/
chown -R www-data:www-data /var/www/

# copy ssl certificate
openssl req -newkey rsa:4096 -days 365 -nodes -x509 -subj "/C=KR/ST=Seoul/L=Seoul/O=42Seoul/OU=Lee/CN=localhost" -keyout localhost.dev.key -out localhost.dev.crt
mv localhost.dev.crt /etc/ssl/certs/
mv localhost.dev.key /etc/ssl/private/
chmod 600 /etc/ssl/certs/localhost.dev.crt etc/ssl/private/localhost.dev.key

# copy configurations of nginx
cp -rp /tmp/default /etc/nginx/sites-available/


# copy configurations of phpmyadmin
wget https://files.phpmyadmin.net/phpMyAdmin/5.0.2/phpMyAdmin-5.0.2-all-languages.tar.gz
tar -xvf phpMyAdmin-5.0.2-all-languages.tar.gz
mv phpMyAdmin-5.0.2-all-languages phpmyadmin
mv phpmyadmin /var/www/html/
rm phpMyAdmin-5.0.2-all-languages.tar.gz
cp -rp /tmp/config.inc.php /var/www/html/phpmyadmin/

# mysql usering
service mysql start
CREATE_WORDPRESS_DATABASE="create database if not exists wordpress;"
echo $CREATE_WORDPRESS_DATABASE | mysql -u root --skip-password
CREATE_PERSONAL_USER="CREATE USER IF NOT EXISTS 'nonalias'@'%' IDENTIFIED BY '1q2w3e4r';"
echo $CREATE_PERSONAL_USER | mysql -u root --skip-password
GIVE_PRIVILEGES="grant all privileges on wordpress.* to 'nonalias'@'%';"
echo $GIVE_PRIVILEGES | mysql -u root --skip-password

# copy configurations of wordpress
wget https://wordpress.org/latest.tar.gz
tar -xvf latest.tar.gz
mv wordpress/ /var/www/html/
chown -R www-data:www-data /var/www/html/wordpress
cp -rp ./tmp/wp-config.php /var/www/html/wordpress/

service nginx start 
service php7.3-fpm start
service mysql restart
bash
