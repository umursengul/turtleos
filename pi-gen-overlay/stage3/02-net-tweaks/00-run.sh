#!/bin/bash -e

install -v -m 644 files/etc/wpa_supplicant/*.conf	"${ROOTFS_DIR}/etc/wpa_supplicant/"
install -v -m 644 files/etc/*.conf	"${ROOTFS_DIR}/etc/"
install -v -m 644 files/etc/hostapd/hostapd.conf	"${ROOTFS_DIR}/etc/hostapd/"

install -v -m 644 files/etc/systemd/network/*.network	"${ROOTFS_DIR}/etc/systemd/network/"
install -v -m 644 files/etc/systemd/system/*.service	"${ROOTFS_DIR}/etc/systemd/system/"

install -v -m 644 files/etc/udev/rules.d/*.rules	"${ROOTFS_DIR}/etc/udev/rules.d/"

echo "=>Performing enabling/disabling of services"
on_chroot <<-EOF
    systemctl disable dhcpcd
    systemctl enable systemd-networkd
    systemctl enable hostapd
EOF
