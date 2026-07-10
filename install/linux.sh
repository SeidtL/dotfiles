#!/bin/bash

rm -rf "$data_path/fcitx5/rime/default.custom.yaml"
ln -sf "$cfg_path/gui/fcitx5/rime/default.custom.yaml" "$data_path/fcitx5/rime/default.custom.yaml"
