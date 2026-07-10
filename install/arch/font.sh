#!/bin/bash

pkgs=(
  ttf-firacode-nerd
  ttf-nerd-fonts-symbols
  noto-fonts-cjk
)
sudo pacman -S --noconfirm --needed "${pkgs[@]}"
