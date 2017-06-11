#!/bin/bash
#

# package update
yum update -y

# setup clock
timedatectl set-timezone Asia/Tokyo

# selinux disabled
sed -i "s/SELINUX=enforcing/SELINUX=disabled/g" /etc/selinux/config

# TODO: NetworkManager and firewalld disabled

# install php
yum -y install php-mysql php php-gd php-mbstring

# install mariadb
yum -y install mariadb mariadb-server

systemctl start mariadb
systemctl enable mariadb

mysql -u root -e "create database wordpress;"
mysql -u root -e "grant all privileges on wordpress.* to wordpress@'localhost' identified by 'wppassword';"
mysql -u root -e "flush privileges;"

# install httpd
yum -y install httpd

cat <<EOS > /var/www/html/index.php
<?php echo phpinfo(); ?>

EOS

systemctl enable httpd

# install wordpress
curl -fSkL --tlsv1.2 https://ja.wordpress.org/latest-ja.tar.gz -o /tmp/latest-ja.tar.gz
tar zxvf /tmp/latest-ja.tar.gz -C /var/www/html/ 
cp /var/www/html/wordpress/wp-config-sample.php /var/www/html/wordpress/wp-config.php
sed -i 's/database_name_here/wordpress/g' /var/www/html/wordpress/wp-config.php
sed -i 's/username_here/wordpress/g' /var/www/html/wordpress/wp-config.php
sed -i 's/password_here/wppassword/g' /var/www/html/wordpress/wp-config.php

