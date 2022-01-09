#!/bin/bash
echo
echo "==============================================="
echo "Installing wkhtmltopdf..."
echo "==============================================="
echo

# не тестировалось

wget "https://github.com/wkhtmltopdf/packaging/releases/download/0.12.6-1/wkhtmltox_0.12.6-1.focal_amd64.deb" -O /tmp/wkhtmltopdf.deb
sudo dpkg -i /tmp/wkhtmltopdf.deb
rm /tmp/wkhtmltopdf.deb
