#!/bin/bash 
cfg_home=$(pwd)
[[ -z "$(grep ". $cfg_home/zshrc" $HOME/.zshrc)" ]] || echo ". $cfg_home/zshrc" >> $HOME/.zshrc

[[ -e "$HOME/.tmux.conf" ]] || ln -s $cfg_home/tmux.conf $HOME/.tmux.conf 
[[ -e "$HOME/.config/nvim" ]] || mkdir $HOME/.config/nvim
[[ -e "$HOME/.config/nvim/init.lua" ]] || ln -s $cfg_home/nvim.lua $HOME/.config/nvim/init.lua
