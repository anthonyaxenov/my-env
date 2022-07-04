#!/bin/bash
##makedesc: Install postgresql (latest) and php-pgsql (if php is installed)

echo
echo "==============================================="
echo "Installing postgresql (latest)..."
echo "==============================================="
echo

installed() {
    command -v "$1" >/dev/null 2>&1
}

sudo apt install -y --autoremove postgresql postgresql-contrib
sudo service postgresql restart
installed 'php' && sudo apt install -y --autoremove php-pgsql
