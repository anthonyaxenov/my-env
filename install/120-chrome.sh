#!/bin/bash
. "../src/01-common.sh" || exit 5
title "Installing google chrome (latest)..."

# https://t.me/axenov_blog/251

# snapi chromium
wget "https://dl.google.com/linux/direct/google-chrome-stable_current_amd64.deb" -O /tmp/google-chrome-stable_current_amd64.deb
sudo dpkg -i /tmp/google-chrome-stable_current_amd64.deb
rm /tmp/google-chrome-stable_current_amd64.deb