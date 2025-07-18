#!/bin/bash

set -euo pipefail

set_timedate() {
    echo "=== Setting Time and Date ==="
    timedatectl set-timezone America/Sao_Paulo
    timedatectl set-ntp true
    timedatectl status
    timedatectl show-timezone
}

create_disk_partitions() {
    echo "=== UEFI Disk Partitioning Setup ==="
    
    # Show available disks
    echo "Available disks:"
    lsblk -d -o NAME,SIZE,MODEL | grep -E "sd[a-z]|nvme[0-9]|vd[a-z]" || true
    
    read -p "Enter disk device (e.g., /dev/sda): " disk
    
    # Validate disk exists
    if [[ ! -b "$disk" ]]; then
        echo "Error: $disk is not a valid block device"
        exit 1
    fi
    
    echo "Creating UEFI partition layout on $disk..."
    
    # Warning
    echo "WARNING: This will erase all data on $disk"
    read -p "Continue? (y/N): " confirm
    [[ "$confirm" =~ ^[Yy]$ ]] || exit 1
    
    # Create GPT partition table
    parted "$disk" --script mklabel gpt
    
    # Create EFI boot partition (512MB)
    parted "$disk" --script mkpart ESP fat32 1MiB 513MiB
    parted "$disk" --script set 1 esp on
    
    # Create root partition (remaining space)
    parted "$disk" --script mkpart primary ext4 513MiB 100%
    
    # Wait for kernel to update partition table
    sleep 2
    partprobe "$disk"

    # Encrypting the root partition
    echo "Encrypting the root partition..."
    cryptsetup luksFormat "${disk}2"

    echo "Opening the root partition..."
    cryptsetup open "${disk}2" cryptroot
    
    # Format partitions
    echo "Formatting partitions..."
    mkfs.fat -F32 "${disk}1"
    mkfs.ext4 "${disk}2"
    
    echo "✓ UEFI partitions created and formatted"
    echo "  Boot: ${disk}1 (FAT32)"
    echo "  Root: ${disk}2 (ext4)"
}

set_timedate
create_disk_partitions