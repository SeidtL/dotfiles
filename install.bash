#!/usr/bin/bash
CURRENT_DIR="$(dirname $(readlink -f $0))"
echo "current dirtory $CURRENT_DIR"

bash $CURRENT_DIR/zsh/install.bash

ln -sf $CURRENT_DIR/tmux.conf $HOME/.tmux.conf
ln -sf $CURRENT_DIR/nvim/vimrc $HOME/.vimrc
ln -sf $CURRENT_DIR/profile.sh $HOME/.zshenv
