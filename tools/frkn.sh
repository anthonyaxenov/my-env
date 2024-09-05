#!/bin/bash

function disconnect() {
    echo "Connecting to $1"
    sudo wg-quick down "$1"
    echo
}

function connect() {
    echo "Disconnecting frkn-$1"
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

function update_wg() {
    sudo apt install -y wireguard jq && wg --version
}

function update_frkn() {
    local countries=(uk ru nl nl2 ch)
    for idx in ${!countries[@]}; do
        country=${countries[idx]}
        echo "Downloading config for $country ($(expr $idx + 1)/${#countries[@]})"

        json=$(curl -s "https://api.frkn.org/peer?location=$country" | jq)

        iface_address=$(echo $json | jq -r .iface.address)
        iface_privkey=$(echo $json | jq -r .iface.key)
        iface_dns=$(echo $json | jq -r .iface.dns)
        peer_pubkey=$(echo $json | jq -r .peer.pubkey)
        peer_psk=$(echo $json | jq -r .peer.psk)
        peer_allowed_ips=$(echo $json | jq -r .peer.allowed_ips)
        peer_endpoint=$(echo $json | jq -r .peer.endpoint)

        cat << EOF > "./frkn-$country.conf"
[Interface]
Address = $iface_address
DNS = $iface_dns
PrivateKey = $iface_privkey

[Peer]
PublicKey = $peer_pubkey
PresharedKey = $peer_psk
AllowedIPs = $peer_allowed_ips
Endpoint = $peer_endpoint
PersistentKeepalive = 25
EOF
    done
    sudo mv ./frkn-*.conf /etc/wireguard/
}

command="$1"
countries=()
current=$(sudo wg show | head -n 1 | awk '{print $2}')

for file in /etc/wireguard/*.conf; do
    filename=${file/\/etc\/wireguard\/frkn-}
    code=${filename/.conf/}
    countries+=($code)
done

correct=-1
if [ -z "$command" ] ; then
    while [ $correct -lt 0 ]; do
        read -rp "Entry on of country code (${countries[*]}): " command
        if in_array "$command" ${countries[@]}; then
            correct=1
        else
            echo "Неверный код страны!"
        fi
    done
fi

case "$command" in
    "update" )
        if update_wg && update_frkn; then
            echo "Wireguard and FRKN updated"
        else
            echo "Something went wrong"
            exit 1
        fi
        ;;

    "down" )
        if [ -n "$current" ]; then
            disconnect "$current"
        fi
        ;;

    "show" )
        sudo wg show
        ;;

    * )
        if [ -n "$current" ]; then
            disconnect "$current"
        fi
        connect "$command"
        ;;
esac
