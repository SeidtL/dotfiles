#!/bin/bash

pkgs=(
  linuxqq-nt-bwrap
  visual-studio-code-bin
  wechat-universal-bwrap
)

paru -S --noconfirm --needed "${pkgs[@]}"
