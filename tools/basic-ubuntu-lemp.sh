#!/bin/bash

apt update && apt upgrade -y --autoremove
apt install -y \
    apt-transport-https \
    build-essential \
    ca-certificates \
    cmake \
    curl \
    dialog \
    gettext \
    gnupg \
    htop \
    libaio1 \
    libcurl4-gnutls-dev \
    libexpat1-dev \
    libghc-zlib-dev \
    libssl-dev \
    make \
    mc \
    nano \
    net-tools \
    nmap \
    p7zip-full \
    software-properties-common \
    unzip \
    inotify-tools \
    git \
    mariadb-server \
    mariadb-client \
    nginx \
    certbot
