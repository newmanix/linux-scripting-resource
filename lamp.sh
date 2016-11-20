#!/bin/bash

#Instructions to use this script 
#
#chmod +x lamp.sh
#
#sudo ./lamp.sh

echo "###################################################################################"
echo "Installation will now begin"
echo "###################################################################################"

#Update the repositories

sudo apt-get update

#Apache installation

sudo apt-get -y install apache2 

#The following commands install and set the MySQL root password to MYPASSWORD123 when you install the mysql-server package.

sudo debconf-set-selections <<< 'mysql-server mysql-server/root_password password MYPASSWORD123'
sudo debconf-set-selections <<< 'mysql-server mysql-server/root_password_again password MYPASSWORD123'

sudo apt-get -y install mysql-server mysql-client

#Php installation

sudo apt-get -y install php7.0-mysql php7.0-curl php7.0-json php7.0-cgi php7.0 libapache2-mod-php7 

#Reset Apache and verify everything works

sudo systemctl restart apache2

