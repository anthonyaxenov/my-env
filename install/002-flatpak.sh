#!/bin/bash
. "../src/01-common.sh" || exit 5
title "Installing flatpak and its software..."

apti flatpak \
    gnome-software-plugin-flatpak

flatpak remote-add --if-not-exists flathub https://flathub.org/repo/flathub.flatpakrepo
