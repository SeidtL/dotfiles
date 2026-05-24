{ config, pkgs, ... }:

{
  xdg.dataFile = with pkgs; {
    "fcitx5/rime/default.custom.yaml".source = config.lib.file.mkOutOfStoreSymlink
      "${config.home.homeDirectory}/.config/gui/fcitx5.custom.yaml";
  };
}
