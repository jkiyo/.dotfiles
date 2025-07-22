#!/bin/bash

set -euo pipefail

install_packages() {
    sudo pacman -Syu
    sudo pacman -S \
        git \
        hyprland \
        hyprpolkitagent \
        jq \
        kitty \
        libnewt \
        nerd-fonts \
        noto-fonts \
        pipewire \
        qt5-wayland \
        qt6-wayland  \
        uwsm \
        wireplumber \
        xdg-desktop-portal-hyprland
}

setup_shell_profile() {
    echo "Removing ~/.bash_profile, ~/.zsh, and ~/.profile"
    rm -f ~/.bash_profile
    rm -f ~/.profile
    echo "Linking ~/.profile from ~/.dotfiles/.profile"
    ln -s ~/.dotfiles/.profile ~/.profile
}

install_packages
setup_shell_profile