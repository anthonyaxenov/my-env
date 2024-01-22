#!/bin/bash
# https://forums.opensuse.org/t/networkmanager-shows-connection-to-lo/164441/13
# https://man.archlinux.org/man/NetworkManager.conf.5.en#Device_List_Format
# https://access.redhat.com/documentation/ru-ru/red_hat_enterprise_linux/8/html/configuring_and_managing_networking/configuring-networkmanager-to-ignore-certain-devices_configuring-and-managing-networking

sudo touch /etc/NetworkManager/conf.d/10-ignore-veth.conf
sudo tee <<EOF /etc/NetworkManager/conf.d/10-ignore-veth.conf > /dev/null
# Disable virtual interfaces to be managed via NetworkManager
[keyfile]
unmanaged-devices=interface-name:veth*

EOF
sudo systemctl reload NetworkManager
