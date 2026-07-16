#!/bin/zsh

pkgs=(
  font-noto-sans-cjk-sc
  font-symbols-only-nerd-font
  font-fira-code-nerd-font
)
brew install --cask -y "${pkgs[@]}"
