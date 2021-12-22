#!/bin/bash
. "../src/01-common.sh" || exit 5
title "Installing composer..."

if installed "php"; then
    if installed "composer"; then
        warning "You already have composer installed - removing to install actual version"
        sudo apt remove -y --autoremove composer
        sudo rm -f /bin/composer
        sudo rm -f /usr/bin/composer
        sudo rm -f /usr/local/bin/composer
        sudo rm -rf /usr/src/composer
    fi
    sudo mkdir -m 0777 -p /usr/src/composer
    cd /usr/src/composer
    # https://getcomposer.org/doc/faqs/how-to-install-composer-programmatically.md
    EXPECTED_CHECKSUM="$(php -r 'copy("https://composer.github.io/installer.sig", "php://stdout");')"
    sudo php -r "copy('https://getcomposer.org/installer', 'composer-setup.php');"
    ACTUAL_CHECKSUM="$(php -r "echo hash_file('sha384', 'composer-setup.php');")"
    if [ "$EXPECTED_CHECKSUM" != "$ACTUAL_CHECKSUM" ]; then
        >&2 echo 'ERROR: Invalid installer checksum'
        rm composer-setup.php
        exit 1
    fi
    php composer-setup.php --quiet
    sudo cp /usr/src/composer/composer.phar /usr/local/bin/composer
    cd - >/dev/null
    sudo rm -rf /usr/src/composer/
    installed "composer" && success "composer installed!"
else
    warning "*** You need to have php installed"
fi

# title "Installing composer.phar in home dir..."
# cd ~
# EXPECTED_SIGNATURE="$(wget -q -O - https://composer.github.io/installer.sig)"
# php -r "copy('https://getcomposer.org/installer', 'composer-setup.php');"
# ACTUAL_SIGNATURE="$(php -r "echo hash_file('sha384', 'composer-setup.php');")"
# if [ "$EXPECTED_SIGNATURE" != "$ACTUAL_SIGNATURE" ]
# then
#     >&2 echo 'ERROR: Invalid installer signature'
#     rm composer-setup.php
#     exit 1
# fi
# php composer-setup.php --quiet
# RESULT=$?
# rm composer-setup.php
