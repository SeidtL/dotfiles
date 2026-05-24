{ config, pkgs, lib, ... }:

{
  home.file.".zshrc".text = ''
    source $HOME/.config/zsh/zshrc
  '';

  home.file.".zprofile".text = ''
    source $HOME/.config/zsh/profile.sh
  '';

  xdg.dataFile = with pkgs; {
    "zsh/zsh-autosuggestions".source = "${zsh-autosuggestions}/share/zsh-autosuggestions";
    "zsh/zsh-powerlevel10k".source = "${zsh-powerlevel10k}/share/zsh-powerlevel10k";
  };
}
