#!/bin/bash

pkgs=(
  qbittorrent
  font-fira-code-nerd-font
  kitty
  scroll-reverser
  font-noto-sans-cjk-sc
  font-symbols-only-nerd-font
  visual-studio-code
  iina
  zotero
)

brew install --cask -y "${pkgs[@]}"
