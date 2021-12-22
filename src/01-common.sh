#!/bin/bash
set -e
source "./../src/00-io.sh"

title() {
    info ""
    info "==============================================="
    info "  $1"
    info "==============================================="
    info ""
}

apti() {
    sudo apt install -y --autoremove $@
}

aptu() {
    sudo apt update
}

aptug() {
    sudo apt upgrade -y --autoremove
}

snapi() {
    snap install $1 2>/dev/null
    [[ $? -ne 0 ]] && snap install $1 --classic
}

installed() {
    command -v "$1" >/dev/null 2>&1
}

die() {
    error "$1"
    exit $2 || 1
}

require_root() {
    [ $(id -u) > "0" ] && die "You must run this script with sudo!" 1
}

require_user() {
    [ $(id -u) == "0" ] && die "You must run this script WITHOUT sudo!" 2
}

require_start() {
    [ -z "$ENVDIR" ] && die "You must run start.sh to execute this script!" 3
}
