#!/bin/bash
source $( dirname $(readlink -e -- "${BASH_SOURCE}"))/packages.sh || exit 255

########################################################
# Desktop notifications
########################################################

notify () {
    require "notify-send"
    [ -n "$1" ] && local title="$1" || local title="My notification"
    local text="$2"
    local level="$3"
    local icon="$4"
    case $level in
        "critical") local timeout=0 ;;
        "low") local timeout=5000 ;;
        *) local timeout=10000 ;;
    esac
    notify-send "$title" "$text" -a "MyScript" -u "$level" -i "$icon" -t $timeout
}

notify_error() {
    notify "Error" "$1" "critical" "dialog-error"
}

notify_warning() {
    notify "Warning" "$1" "normal" "dialog-warning"
}

notify_info() {
    notify "" "$1" "low" "dialog-information"
}
