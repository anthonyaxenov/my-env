#!/bin/bash
. "../src/01-common.sh" || exit 5
title "Installing software from apt..."

aptu
aptug
apti apt-transport-https \
    ca-certificates \
    curl \
    make \
    cmake \
    dialog \
    build-essential \
    software-properties-common \
    libaio1 \
    libssl-dev \
    libghc-zlib-dev \
    libcurl4-gnutls-dev \
    libexpat1-dev \
    gettext \
    gnupg \
    ubuntu-restricted-extras \
    gnome-software \
    unzip \
    mc \
    htop \
    nano \
    neofetch \
    default-jdk \
    terminator \
    dconf-editor \
    alien \
    meld \
    vlc \
    gparted \
    hardinfo \
    libreoffice \
    pulseeffects \
    lsp-plugins \
    lsb-release \
    net-tools \
    # minder \
    # redshift \
    # redshift-gtk \
    # nodejs \
    # compiz \
    # compizconfig-settings-manager \
    # earlyoom \
    # etckeeper \
    # deepin-screenshot \
    # geoclue-2.0 \
    at
