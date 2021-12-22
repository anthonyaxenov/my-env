#!/bin/bash
. "../src/01-common.sh" || exit 5
title "Installing apache2..."

apti apache2
sudo service apache2 restart
success "$(apache2 -v)"
