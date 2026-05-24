{ config, pkgs, ... }:

let
  isDarwin = pkgs.stdenv.isDarwin;
  username = "seidtl";
  homeDirectory = if pkgs.stdenv.isDarwin
    then "/Users/${username}"
    else "/home/${username}";
in {
  home.username = username;
  home.homeDirectory = homeDirectory;

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
    ./linux.nix
  ];

  home.file.".vimrc".source = config.lib.file.mkOutOfStoreSymlink
    "${config.home.homeDirectory}/.config/nvim/.vimrc";
  home.stateVersion = "26.05";
}
