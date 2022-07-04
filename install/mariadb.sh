#!/bin/bash
##makedesc: Install mariadb (latest) and php-mysql + phpMyAdmin (if php is installed)

echo
echo "==============================================="
echo "Installing mariadb (latest)..."
echo "==============================================="
echo

installed() {
    command -v "$1" >/dev/null 2>&1
}

sudo apt install -y --autoremove mariadb-server mariadb-client
sudo mysql_secure_installation
installed "php" && sudo apt install -y --autoremove php-mysql phpmyadmin
