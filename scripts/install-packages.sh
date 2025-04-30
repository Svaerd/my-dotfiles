#!/bin/bash

packages=(
    ags-hyprpanel-git
    bat
    bluez
    bluez-utils
    brightnessctl
    btop
    cliphist
    cmake
    fastfetch
    fd
    fish
    fzf
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
    hyprpolkitagent
    hyprpaper
    hyprshade
    hyprutils
    imagemagick
    kitty
    keyd
    kdeconnect
    lazygit
    lua
    neovim
    npm
    nwg-look
    pacseek
    ripgrep
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
