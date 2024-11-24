#!/bin/bash

print() {
    echo -e "$*"
}

state() {
    sudo ethtool "$iface" | grep -E '^\s+Wake-on:\s\w+' | awk '{print $2}'
}

[ "$1" ] && iface="$1" || iface=enp3s0

[ -f "/sys/class/net/$iface/address" ] && mac=$(cat "/sys/class/net/$iface/address") || mac=''
[ -z "$mac" ] && {
    print "Wrong interface! $iface" >&2
    exit 1
}

state=$(state)

print "Interface\t: $iface"
print "MAC-address\t: $mac"
print "WoL state\t: $state"

if [ $state == 'd' ]; then
    sudo ethtool -s "$iface" wol gu || true
    sudo mkdir -p /etc/networkd-dispatcher/configuring.d
    sudo tee /etc/networkd-dispatcher/configuring.d/wol <<EOF >/dev/null
#!/usr/bin/env bash

ethtool -s $iface wol gu || true
EOF
    sudo chmod 755 /etc/networkd-dispatcher/configuring.d/wol
    print "* New WOL state\t: $(state)"
fi

print "\nTo wake up this device run this command from another one:\n"
print "\twakeonlan -p 8 $mac\n"
print "\twol $mac\n"

