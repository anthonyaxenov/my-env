#!/bin/bash
set -oe pipefail

__root__=$( dirname $(readlink -e -- "${BASH_SOURCE}"))
source $__root__/helpers/io.sh || exit 255
source $__root__/helpers/basic.sh || exit 255
source $__root__/helpers/debug.sh || exit 255
source $__root__/helpers/packages.sh || exit 255

title() {
    [[ $__AAA_NO_TITLE = 1 ]] || {
        [ "$1" ] && title="$1" || title="$(grep -m 1 -oP "(?<=^##makedesc:\s).*$" ${BASH_SOURCE[1]})"
        info
        info "==============================================="
        info "$title"
        info "==============================================="
        info
    }
}
