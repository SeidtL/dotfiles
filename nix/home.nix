{ config, pkgs, isDarwin, ... }:

let
  username = "seidtl";
  homeDirectory = if isDarwin
    then "/Users/${username}"
    else "/home/${username}";
  sysPkgs = if isDarwin
    then [ ./darwin.nix ]
    else [ ./linux.nix ];
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
    dust

    zsh-autosuggestions
    zsh-powerlevel10k

    gdb
    cmake
    clang
    clang-tools
    lldb

    nodejs
    go
    python313

    nix-your-shell
  ];

  imports = [
    ./git.nix
    ./tmux.nix
    ./zsh.nix
  ] ++ sysPkgs;

  home.file.".vimrc".source = config.lib.file.mkOutOfStoreSymlink
    "${config.home.homeDirectory}/.config/nvim/.vimrc";
  home.stateVersion = "26.05";
}
