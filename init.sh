#!/bin/bash 
cfg_home=$(pwd)
[[ -z "$(grep ". $cfg_home/zshrc" $HOME/.zshrc)" ]] || echo ". $cfg_home/zshrc" >> $HOME/.zshrc
[[ -f "$HOME/.tmux.conf" ]] || ln -s $cfg_home/tmux.conf $HOME/.tmux.conf 
[[ -d "$HOME/.config/nvim" ]] || mkdir $HOME/.config/nvim
[[ -f "$HOME/.config/nvim/init.lua" ]] || ln -s $cfg_home/nvim.lua $HOME/.config/nvim/init.lua
[[ -d "$HOME/.config/fish/conf.d" ]] || mkdir -p $HOME/.config/fish/conf.d
[[ -f "$HOME/.config/fish/conf.d/config.fish" ]] || ln -s $cfg_home/config.fish $HOME/.config/fish/conf.d/default.fish
