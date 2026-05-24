{ config, pkgs, lib, ... }:

{
  home.file.".zshrc".text = ''
    source $HOME/.config/zsh/zshrc
  '';

  home.file.".zprofile".text = ''
    source $HOME/.config/zsh/profile.sh
  '';
}
