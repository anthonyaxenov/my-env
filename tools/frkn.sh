#!/bin/bash

function disconnect() {
    echo "Отключаю $1"
    sudo wg-quick down "$1"
    echo
}

function connect() {
    echo "Подключаю frkn-$1"
    sudo wg-quick up "frkn-$1"
    echo
}

function in_array() {
    local find=$1
    shift
    for e in "$@"; do
        [[ "$e" == "$find" ]] && return 0
    done
    return 1
}

country="$1"
countries=()
current=$(sudo wg show | head -n 1 | awk '{print $2}')

for file in /etc/wireguard/*.conf; do
    filename=${file/\/etc\/wireguard\/frkn-}
    code=${filename/.conf/}
    countries+=($code)
done

correct=-1
if [ -z "$country" ] ; then
    while [ $correct -lt 0 ]; do
        read -rp "Выбери страну (${countries[*]}): " country
        if in_array "$country" ${countries[@]}; then
            correct=1
        else
            echo "Неверный код страны!"
        fi
    done
fi

case "$country" in
    "down" )
        if [ -n "$current" ]; then
            disconnect "$current"
        fi
        ;;

    "status"|"show" )
        sudo wg show
        ;;

    * )
        if [ -n "$current" ]; then
            disconnect "$current"
        fi
        connect "$country"
        ;;
esac
