#!/bin/zsh

mkdir -p $cfg_path/tmux
rm -rf $cfg_path/tmux/.tmux.conf
cat > "$cfg_path/tmux/.tmux.conf" <<'EOF'
set -g prefix C-k
unbind C-b
set -g mouse on
set -g default-terminal "screen-256color"
EOF
