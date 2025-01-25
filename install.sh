#!/bin/bash 
$HOME/.config/zsh/install.zsh 

[[ -f "$HOME/.tmux.conf" ]] || ln -s $HOME/.config/tmux.conf $HOME/.tmux.conf
[[ -f "$HOME/.vimrc" ]] || ln -s $HOME/.config/nvim/vimrc $HOME/.vimrc
