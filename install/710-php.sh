#!/bin/bash
PHPVER="8.1"
echo
echo "==============================================="
echo "Installing php${PHPVER}..."
echo "==============================================="
echo

sudo LC_ALL=C.UTF-8 add-apt-repository -y ppa:ondrej/php
sudo apt install -y --autoremove \
    php${PHPVER} \
    php${PHPVER}-cli \
    php${PHPVER}-common \
    php${PHPVER}-xdebug \
    # php${PHPVER}-bcmath \
    # php${PHPVER}-bz2 \
    # php${PHPVER}-curl \
    # php${PHPVER}-gd \
    # php${PHPVER}-json \
    # php${PHPVER}-mbstring \
    # php${PHPVER}-mysql \
    # php${PHPVER}-opcache \
    # php${PHPVER}-pgsql \
    # php${PHPVER}-soap \
    # php${PHPVER}-xml \
    # php${PHPVER}-xmlrpc \
    # php${PHPVER}-xsl \
    # php${PHPVER}-sqlite3 \
    # php${PHPVER}-zip
    # php${PHPVER}-dba
    # php${PHPVER}-ldap
php -v
