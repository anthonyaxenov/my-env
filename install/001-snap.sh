#!/bin/bash
. "../src/01-common.sh" || exit 5
title "Installing snap and its software..."

if !installed snapd; then
    aptu
    apti snapd
    apti gnome-software-plugin-snap
    # snapi core
    # snapi snapd
else
    snap refresh core
fi

snapi snap-store
snapi telegram-desktop
snapi code
snapi phpstorm
snapi skype
snapi audacity
snapi flameshot
snapi gtk-common-themes
snapi gtk2-common-themes
snapi kde-frameworks-5-core18
snapi zoom-client
snapi peek

# https://certbot.eff.org/
snapi certbot
sudo ln -s /snap/bin/certbot /usr/bin/certbot

# snapi mysql-workbench-community
# snapi dbeaver-ce
# snapi discord
# snapi liquibase
# snapi postman
# snapi obs-studio
