#!/bin/bash

set -euo pipefail

setup_timezone() {
    echo "=== Setting Timezone ==="
    ln -sf /usr/share/zoneinfo/America/Sao_Paulo /etc/localtime
    hwclock --systohc
    date
    echo "✓ Timezone set"
}

setup_locale() {
    echo "=== Setting Locale ==="
    sed -i 's/^#en_US.UTF-8 UTF-8/en_US.UTF-8 UTF-8/' /etc/locale.gen
    locale-gen
    echo "LANG=en_US.UTF-8" > /etc/locale.conf
}

setup_hostname() {
    echo "=== Setting Hostname ==="
    echo "fortissax" > /etc/hostname
    echo "✓ Hostname set"
}

setup_network() {
    echo "=== Setting Network ==="
    systemctl enable NetworkManager
    echo "✓ Network set"
}

setup_timezone
setup_locale
setup_hostname
setup_network