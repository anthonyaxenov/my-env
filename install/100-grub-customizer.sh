#!/bin/bash
. "../src/01-common.sh" || exit 5
title "Installing grub-customizer..."

sudo add-apt-repository ppa:danielrichter2007/grub-customizer
apti grub-customizer
