#!/bin/bash
. "../src/01-common.sh" || exit 5
title "Installing postman (latest)..."

wget "https://dl.pstmn.io/download/latest/linux64" -O /tmp/postman.tar.gz
# sudo tar -xvzf /tmp/postman.tar.gz -C /usr/local/bin
sudo tar -xzf /tmp/postman.tar.gz -C /usr/local/bin
rm /tmp/postman.tar.gz
sudo ln -s /usr/local/bin/Postman/Postman /usr/local/bin/postman

echo "#!/usr/bin/env xdg-open

[Desktop Entry]
Name=Postman
Exec=/usr/local/bin/postman
Icon=/usr/local/bin/Postman/app/icons/icon_128x128.png
Categories=Utility,Network
Terminal=false
Type=Application
Encoding=UTF-8
" > /home/anthony/.local/share/applications/Postman.desktop
sudo update-desktop-database

installed "postman" && success "Postman installed!" || warning "Something wrong, Postman was not installed"
