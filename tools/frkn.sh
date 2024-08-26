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

country="$1"
countries=(uk ru nl nl2 ch)
current=$(sudo wg show | head -n 1 | awk '{print $2}')

if [ -z "$country" ]; then
    IFS= read -rp "Выбери страну (${countries[*]}): " country
fi

case $country in
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
