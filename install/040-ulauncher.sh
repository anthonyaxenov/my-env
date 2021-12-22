#!/bin/bash
. "../src/01-common.sh" || exit 5
title "Installing ulauncher from apt..."

sudo add-apt-repository ppa:agornostal/ulauncher
apti ulauncher
