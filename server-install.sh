#!/bin/bash

# Дефолтная Ubuntu 18.04.1 LTS

# Изначальное обновление
apt clean all
apt dist-upgrade



# PHP
add-apt-repository ppa:ondrej/php
# 5.6
apt install php5.6 php5.6-fpm php5.6-mysql php5.6-opcache php5.6-zip php5.6-sqlite3 php5.6-gd php5.6-json php5.6-mbstring php5.6-curl php5.6-cli
# 7.0
apt install php7.0 php7.0-fpm php7.0-mysql php7.0-opcache php7.0-zip php7.0-sqlite3 php7.0-gd php7.0-json php7.0-mbstring php7.0-curl php7.0-cli
# 7.2
apt install php7.2 php7.2-fpm php7.2-mysql php7.2-opcache php7.2-zip php7.2-sqlite3 php7.2-gd php7.2-json php7.2-mbstring php7.2-curl php7.2-cli



# MySQL
#
# Нормальных пакетов Oracle не собирают
# и через apt установить одноверменно, например, 5.7 и 8.0
# без танцев с бубном нельзя.
#
# Они даже пакет с одной версией нормально собрать не могут (см. ниже).
#
# Здесь действительно могут выручить контейнеры, в частности Docker.
#
# Либо сборка из исходников и упаковка в свои пакеты
# по аналогии с тем как это делают Postgres или Ondrej для PHP.
#
cd /root
mkdir programs
cd programs
wget https://dev.mysql.com/get/mysql-apt-config_0.8.11-1_all.deb
# Здесь появится диалог, нужно будет выбрать желаемую версию MySQL (к сожалению, только одну)
dpkg -i ./mysql-apt-config_0.8.11-1_all.deb
apt install mysql-server

# Если при запуске произошла ошибка
# (как, например, у меня, при установке mysql 5.7.24)
rm -rf /var/lib/mysql/*
mkdir /var/run/mysqld
chown mysql:adm /var/run/mysqld
# Здесь сохранить временный пароль root-пользователя
su -s /bin/bash -c '/usr/sbin/mysqld --initialize' mysql
# Проверить чтобы здесь не было ошибок
service mysql start

# Здесь будет нужен временный пароль, если понадобились инструкции по исправлению ошибки
mysql_secure_installation
systemctl enable mysql



# Nginx
echo 'deb http://nginx.org/packages/ubuntu/ bionic nginx' >> /etc/apt/sources.list
echo 'deb-src http://nginx.org/packages/ubuntu/ bionic nginx' >> /etc/apt/sources.list
wget https://nginx.org/keys/nginx_signing.key
apt-key add ./nginx_signing.key
apt update
apt install nginx



# SCM
apt install mercurial
apt install git



# Перезагрузка, проверить чтобы все сервисы корректно стартовали
reboot
