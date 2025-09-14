#!/bin/bash

set -euo pipefail

install_packages() {
    sudo pacman -Syu
    sudo pacman -S \
	hyprpaper \
	keepassxc \
	rofi \
	waybar \
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
	pipewire-pulse \
	pipewire-alsa \
        xdg-desktop-portal-hyprland
}

create_link() {
    echo "Linking $1 -> $2"
    mkdir -p "$(basename $2)"
    ln -sf "$1" "$2"
}

setup_dotfiles() {
    echo "Removing ~/.bash_profile, ~/.zsh, and ~/.profile"
    rm -f ~/.bash_profile
    rm -f ~/.profile

    create_link ~/.dotfiles/.profile ~/.profile
    create_link ~/.dotfiles/systemd ~/.config/systemd/user
    create_link ~/.dotfiles/ssh ~/.ssh/config
    create_link ~/.dotfiles/environment.d ~/.config/environment.d
    create_link ~/.dotfiles/hypr ~/.config/hypr
    create_link ~/.dotfiles/kitty ~/.config/kitty
    create_link ~/.dotfiles/waybar ~/.config/waybar
    create_link ~/.dotfiles/rofi ~/.config/rofi
}

install_packages
setup_dotfiles
