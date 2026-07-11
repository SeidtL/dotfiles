#!/bin/zsh
if [[ $(uname -s) == "Darwin" ]]; then
  return 0
fi

mkdir -p "$data_path/fcitx5/rime"
rm -rf "$data_path/fcitx5/rime/default.custom.yaml"
ln -sf "$cfg_path/gui/fcitx5/rime/default.custom.yaml" "$data_path/fcitx5/rime/default.custom.yaml"
