#!/bin/bash
. "../src/01-common.sh" || exit 5
title "Installing mariadb..."

apti mariadb-server mariadb-client
sudo mysql_secure_installation
installed "php" && apti php-mysql phpmyadmin
installed "mysql" && success "mariadb installed!"
