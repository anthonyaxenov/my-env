#!/bin/bash
. "../src/01-common.sh" || exit 5
title "Installing telebit..."

# export NODEJS_VER=v10.2                   # v10.2 is tested working, but we can test other versions
# export TELEBIT_VERSION=master             # git tag or branch to install from
# export TELEBIT_USERSPACE=no               # install as a system service (launchd, systemd only)
# export TELEBIT_PATH=/opt/telebit
# export TELEBIT_USER=telebit
# export TELEBIT_GROUP=telebit
curl https://get.telebit.io/ | bash
