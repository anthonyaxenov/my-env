#!/bin/bash
. "../src/01-common.sh" || exit 5
title "Installing Window AppMenu Applet..."

# https://github.com/psifidotos/applet-window-appmenu/blob/master/INSTALLATION.md

apti make \
    cmake \
    extra-cmake-modules \
    qtdeclarative5-dev \
    libkf5plasma-dev \
    libqt5x11extras5-dev \
    g++ \
    libsm-dev \
    libkf5configwidgets-dev \
    libkdecorations2-dev \
    libxcb-randr0-dev \
    libkf5wayland-dev \
    plasma-workspace-dev

if installed 'git'; then
    sudo rm -rf /usr/src/appmenu-applet
    sudo git clone https://github.com/psifidotos/applet-window-appmenu.git --depth=1 /usr/src/appmenu-applet
else
    sudo wget https://github.com/psifidotos/applet-window-appmenu/archive/master.zip -O /tmp/appmenu-applet.zip
    sudo unzip /tmp/appmenu-applet.zip -d /usr/src/appmenu-applet
    sudo mv /usr/src/appmenu-applet/applet-window-appmenu-master/* /usr/src/appmenu-applet/
    sudo mv /usr/src/appmenu-applet/applet-window-appmenu-master/.* /usr/src/appmenu-applet/
    sudo rm -rf /usr/src/appmenu-applet/applet-window-appmenu-master
    sudo rm -f /usr/src/appmenu-applet.zip
fi
sudo chown -R anthony: /usr/src/appmenu-applet
cd /usr/src/appmenu-applet/
sh ./install.sh
success 'Successful! Now you can add "Window AppMenu Applet" on desktop or panel'
