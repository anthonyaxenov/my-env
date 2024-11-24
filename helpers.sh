#!/bin/bash
source $(dirname $0)/helpers/io.sh || exit 255
source $(dirname $0)/helpers/basic.sh || exit 255

title() {
    [ "$1" ] && title="$1" || title="$(grep -m 1 -oP "(?<=^##makedesc:\s).*$" ${BASH_SOURCE[1]})"
    info
    info "==============================================="
    info "$title"
    info "==============================================="
    info
}
