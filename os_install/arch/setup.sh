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
    sed -i 's/^#pt_BR.UTF-8 UTF-8/pt_BR.UTF-8 UTF-8/' /etc/locale.gen
    locale-gen
    echo "LANG=pt_BR.UTF-8" > /etc/locale.conf
}

setup_hostname() {
    echo "=== Setting Hostname ==="
    echo "fortissax" > /etc/hostname
    echo "✓ Hostname set: $(cat /etc/hostname)"
}

setup_network() {
    echo "=== Setting Network ==="
    systemctl enable NetworkManager
    echo "✓ Network set"
}

setup_root_password() {
    echo "=== Setting Root Password ==="
    passwd
    echo "✓ Root Password set"
}

setup_sudo() {
    echo "=== Setting Sudo ==="
    echo "%wheel ALL=(ALL:ALL) ALL" >> /etc/sudoers
    echo "✓ Sudo set"
}

setup_user() {
    echo "=== Setting User ==="
    read -p "Enter username: " username
    useradd -m -G wheel -s /bin/bash "$username"
    passwd "$username"
    echo "✓ User $username set"
}

setup_mkinitcpio() {
    echo "=== Setting mkinitcpio ==="
    cat <<EOF > /etc/mkinitcpio.conf
# vim:set ft=sh
MODULES=()
BINARIES=()
FILES=()
HOOKS=(base udev autodetect microcode modconf kms keyboard keymap consolefont block encrypt lvm2 filesystems fsck)
EOF
    cat /etc/mkinitcpio.conf
    mkinitcpio -P
    echo "✓ mkinitcpio set"
}

setup_grub() {
    echo "=== Setting Grub ==="

    echo "Available disks:"
    lsblk -d -o NAME,SIZE,MODEL | grep -E "sd[a-z]|nvme[0-9]|vd[a-z]" || true
    read -p "Enter disk device (e.g., /dev/sda): " disk
    read -p "Enter encrypted root partition device (e.g., /dev/sda2): " root_partition
    read -p "Enter unencrypted /dev/mapper partition name (e.g., cryptroot): " unencrypted_root_partition_name

    local root_partition_uuid=$(blkid -o value -s UUID "$root_partition")
    local unencrypted_root_partition_uuid=$(blkid -o value -s UUID "/dev/mapper/$unencrypted_root_partition_name")

    grub-install --efi-directory=/boot --bootloader-id=Fortissax "$disk"
    cat <<EOF > /etc/default/grub
GRUB_DEFAULT=0 
GRUB_TIMEOUT=5
GRUB_DISTRIBUTOR="Arch"
GRUB_CMDLINE_LINUX_DEFAULT="loglevel=3 quiet cryptdevice=UUID=$root_partition_uuid:$unencrypted_root_partition_name root=UUID=$unencrypted_root_partition_uuid"
GRUB_CMDLINE_LINUX=""
GRUB_PRELOAD_MODULES="part_gpt part_msdos"
GRUB_TIMEOUT_STYLE=menu
GRUB_TERMINAL_INPUT=console
GRUB_GFXMODE=auto
GRUB_GFXPAYLOAD_LINUX=keep
GRUB_DISABLE_RECOVERY=true
EOF
    cat /etc/default/grub
    grub-mkconfig -o /boot/grub/grub.cfg
    echo "✓ Grub set"
}

setup_timezone
setup_locale
setup_hostname
setup_root_password
setup_sudo
setup_user
setup_mkinitcpio
setup_grub
setup_network

echo "================================================"
echo "The setup is complete, you can now exit the chroot and reboot the system."
echo "================================================"