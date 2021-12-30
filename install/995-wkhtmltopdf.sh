#!/bin/bash
. "../src/01-common.sh" || exit 5
title "Installing wkhtmltopdf..."

# не тестировалось

wget "https://github.com/wkhtmltopdf/packaging/releases/download/0.12.6-1/wkhtmltox_0.12.6-1.focal_amd64.deb" -O /tmp/wkhtmltopdf.deb
sudo dpkg -i /tmp/wkhtmltopdf.deb
rm -rf /tmp/wkhtmltopdf.deb
