#!/bin/bash
echo
echo "==============================================="
echo "Installing mariadb..."
echo "==============================================="
echo

installed() {
    command -v "$1" >/dev/null 2>&1
}

sudo apt install -y --autoremove mariadb-server mariadb-client
sudo mysql_secure_installation
installed "php" && sudo apt install -y --autoremove php-mysql phpmyadmin
