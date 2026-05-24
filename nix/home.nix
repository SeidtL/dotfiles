{ config, pkgs, isDarwin, ... }:

{
  home.username = "seidtl";
  home.homeDirectory = if pkgs.stdenv.isDarwin
    then "/Users/${config.home.username}"
    else "/home/${config.home.username}";

  home.packages = with pkgs; [
    git
    yazi
    ffmpeg
    jq
    poppler
    fd
    ripgrep
    fzf
    xclip
    _7zz
    htop
    neovim
    tmux

    zsh-autosuggestions
    zsh-powerlevel10k

    gdb
    cmake
    clang
    clang-tools
    lldb

    nodejs
    go

    nix-your-shell
  ];

  imports = [
    ./git.nix
    ./tmux.nix
    ./zsh.nix
  ];

  home.file.".vimrc".source = config.lib.file.mkOutOfStoreSymlink
    "${config.home.homeDirectory}/.config/nvim/.vimrc";
  home.stateVersion = "26.05";
}
