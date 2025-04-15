#!/bin/bash

packages=(
  ranger
  bat
  nvim
  fish
  git
  lazygit
  7zip
  emojirunner
  zoxide
  fzf
  fastfetch
  gthumb
  gimp
  kitty
  zellij
  lua
  gtrash
  npm
)

for package in "${packages[@]}"; do
  yay -S --noconfirm "${package}"
done
