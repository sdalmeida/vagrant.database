#!/bin/bash

export DEBIAN_FRONTEND=noninteractive

sudo add-apt-repository -y ppa:ondrej/mysql-5.6
sudo apt-get update

sudo debconf-set-selections <<< 'mysql-server-5.6 mysql-server/root_password password secret'
sudo debconf-set-selections <<< 'mysql-server-5.6 mysql-server/root_password_again password secret'

sudo apt-get -y install mysql-server-5.6

sudo systemctl start mysql
sudo systemctl enable mysql

sudo rm /etc/mysql/mysql.conf.d/mysqld.cnf
sudo cp database/mysqld.cnf /etc/mysql/mysql.conf.d/
sudo chmod 644 /etc/mysql/mysql.conf.d/mysqld.cnf

sudo systemctl restart mysql

mysql -u root -psecret -e "GRANT ALL PRIVILEGES ON *.* TO 'root'@'%';"
mysql -u root -psecret -e "UPDATE mysql.user SET Password = PASSWORD('secret') WHERE User = 'root';"
mysql -u root -psecret -e "CREATE DATABASE IF NOT EXISTS homestead;"
mysql -u root -psecret -e "FLUSH PRIVILEGES;"