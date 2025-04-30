#!/bin/bash

packages=(
    7zip
    bat
    bluez
    bluez-utils
    brightnessctl
    btop
    cmake
    cliphist
    fastfetch
    fish
    fd
    flatpak
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
    hyprpaper
    hyprshade
    hyprutils
    hyprpolkitagent
    imagemagick
    kitty
    kdeconnect
    lazygit
    lua
    nautilus
    neovim
    noto-fonts-emoji
    npm
    nwg-look
    pacseek
    ripgrep
    rofi-calc
    rofi-emoji
    rofi-wayland
    ttf-firacode-nerd
    timeshift
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

#xargs flatpak install -y <flatpaks.txt
