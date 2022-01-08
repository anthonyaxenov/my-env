#!/bin/bash
echo
echo "==============================================="
echo "Installing grub-customizer..."
echo "==============================================="
echo

sudo add-apt-repository ppa:danielrichter2007/grub-customizer
sudo apt install -y --autoremove grub-customizer
