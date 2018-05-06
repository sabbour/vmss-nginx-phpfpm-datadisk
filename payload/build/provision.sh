#!/bin/bash

IMAGENAMEVAR=$1
printf "\nAdding image name $IMAGENAMEVAR to /tmp/payload/app/buildnumber.txt"
echo $IMAGENAMEVAR > /tmp/payload/app/buildnumber.txt

yum update -y

# Run Autopart to partition and mount Data Disks
printf "\nRun Autopart to partition and mount Data Disks"
chmod +x /tmp/payload/build/autopart.sh
/tmp/payload/build/autopart.sh

# Add EPEL repository
printf "\nAdd EPEL repository"
yum install -y epel-release

# Install nginx
printf "\nInstall nginx"
yum install -y nginx

# Add Webtatic repository for PHP-FPM 7
printf "\nAdd Webtatic repository for php-fpm7 7"
rpm -Uvh https://mirror.webtatic.com/yum/el7/webtatic-release.rpm

# Install the required PHP modules
printf "\nInstall php-fpm 7 and the required PHP modules"
yum -y install php70w-fpm php70w-mcrypt php70w-curl php70w-cli php70w-mysql php70w-gd php70w-xsl php70w-json php70w-intl php70w-pear php70w-devel php70w-mbstring php70w-zip php70w-soap php70w-opcache

# Install SELinux tools
printf "\nInstall SELinux tools"
yum -y install policycoreutils-python

# Overwrite /etc/php.ini
printf "\nOverwrite /etc/php.ini"
yes | cp /tmp/payload/config/php.ini /etc/php.ini

# Overwrite /etc/php-fpm.d/www.conf
printf "\nCopy /tmp/payload/config/www.conf to /etc/php-fpm.d/www.conf"
yes | cp /tmp/payload/config/www.conf /etc/php-fpm.d/www.conf

# Overwrite /etc/php.d/opcache.ini
printf "\nCopy /tmp/payload/config/opcache.ini to /etc/php.d/opcache.ini"
yes | cp /tmp/payload/config/opcache.ini /etc/php.d/opcache.ini

# Copy nginx.conf to /etc/nginx/nginx.conf
printf "\nCopy /tmp/payload/config/nginx.conf to /etc/nginx/nginx.conf"
yes | cp /tmp/payload/config/nginx.conf /etc/nginx/nginx.conf

# Copy default.conf to /etc/nginx/conf.d/default.conf
printf "\nCopy /tmp/payload/config/default.conf to /etc/nginx/conf.d/default.conf"
yes | cp /tmp/payload/config/default.conf /etc/nginx/conf.d/default.conf

# Create directory for session path
printf "\nCreating directory for session path /var/lib/php/session"
mkdir -p /var/lib/php/session/
chown -R nginx:nginx /var/lib/php/session/

# Remove the /usr/share/nginx/html/ directory
printf "\nRemoving existing /usr/share/nginx/html/ directory"
rm -rf  /usr/share/nginx/html/

# Create web application directory
printf "\nCreate web application directory /media/data1/html on the data disk"
mkdir -p /media/data1/html

# Create a symlink instead to /media/data1/html
printf "\nCreate a symlink /usr/share/nginx/html to /media/data1/html"
ln -s /media/data1/html /usr/share/nginx/html

# Create the webapp folder
printf "\nCreate web app directory /usr/share/nginx/html/default"
mkdir /usr/share/nginx/html/default

# Move the application files to the proper location
printf "\nCopy uploaded application files from /tmp/payload/app/ to /usr/share/nginx/html/default"
cp -R /tmp/payload/app/. /usr/share/nginx/html/default
printf "\nBuild number text file: "
cat /usr/share/nginx/html/default/buildnumber.txt
chmod 777 /usr/share/nginx/html/default/buildnumber.txt

# Set proper permissions
printf "\nSetting permissions on /usr/share/nginx/html/default/*"
chmod 0755 -R /usr/share/nginx/html/default/*
chown -R nginx:nginx /usr/share/nginx/html/default/*

# Set proper SELinux permissions
printf "\nDisable SELinux"
sed -i --follow-symlinks 's/^SELINUX=.*/SELINUX=disabled/g' /etc/sysconfig/selinux && cat /etc/sysconfig/selinux
setenforce 0

printf "\nRemove Packer files"
rm -rf /tmp/payload

printf "\nStart php-fpm"
systemctl start php-fpm

printf "\nEnable php-fpm"
systemctl enable php-fpm

printf "\nStart nginx"
systemctl start nginx

printf "\nEnable nginx"
systemctl enable nginx
