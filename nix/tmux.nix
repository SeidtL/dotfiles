{ config, pkgs, ... }:

{
  programs.tmux = {
    enable = true;
    shortcut = "C-k";
    mouse = true;
    terminal = "screen-256color";
  };
}
