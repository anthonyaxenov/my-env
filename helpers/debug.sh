#!/bin/bash
source $( dirname $(readlink -e -- "${BASH_SOURCE}"))/io.sh || exit 255

########################################################
# Functions to debug scripts
########################################################

var_dump() {
    debug "$1 = ${!1}"
}

print_stacktrace() {
    STACK=""
    local i
    local stack_size=${#FUNCNAME[@]}
    debug "Callstack:"
    # for (( i=$stack_size-1; i>=1; i-- )); do
    for (( i=1; i<$stack_size; i++ )); do
        local func="${FUNCNAME[$i]}"
        [ x$func = x ] && func=MAIN
        local linen="${BASH_LINENO[$(( i - 1 ))]}"
        local src="${BASH_SOURCE[$i]}"
        [ x"$src" = x ] && src=non_file_source
        debug "   at $func $src:$linen"
    done
}
