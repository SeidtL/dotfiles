#!/bin/zsh

pkgs=(
  qbittorrent
  kitty
  scroll-reverser
  visual-studio-code
  iina
  zotero
)

brew install --cask -y "${pkgs[@]}"
