#!/bin/bash
echo
echo "==============================================="
echo "Installing snap and its software..."
echo "==============================================="
echo

installed() {
    command -v "$1" >/dev/null 2>&1
}

snapi() {
    snap install $1 2>/dev/null
    [[ $? -ne 0 ]] && snap install $1 --classic
}

if ! installed snapd; then
    sudo apt update
    sudo apt install -y --autoremove snapd gnome-software-plugin-snap
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
# snapi obs-studio
