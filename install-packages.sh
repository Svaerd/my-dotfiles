#!/bin/bash

packages=(
    bat
    cmake
    fastfetch
    fish
    gtrash-bin
    git
    ghostscript
    grub-customizer
    gthumb
    hyprcursor
    hyprgraphics
    hypridle
    hyprland
    hyprland
    hyprlock
    hyprpaper
    hyprshade
    hyprutils
    imagemagick
    kitty
    kdeconnect
    lazygit
    lua
    neovim
    npm
    nwg-look
    pacseek
    rofi-calc
    rofi-emoji
    rofi-wayland
    vivaldi
    waypaper
    wl-clipboard
    xdg-desktop-portal-hyprland
    zellij
    zoxide
)

for package in "${packages[@]}"; do
    yay -S --noconfirm "${package}"
done

xargs flatpak install -y <flatpaks.txt
