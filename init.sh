CFG_ROOT="$HOME/.config"

mkdir -p $CFG_ROOT/nvim 
mkdir -p $CFG_ROOT/alacritty/themes

git clone https://github.com/alacritty/alacritty-theme ~/.config/alacritty/themes 

ln -s $CFG_ROOT/nvim.lua $CFG_ROOT/nvim/init.lua
ln -s $CFG_ROOT/zshrc $HOME/.zshrc 
ln -s $CFG_ROOT/tmux.conf $HOME/.tmux.conf
ln -s $CFG_ROOT/alacritty.toml $CFG_ROOT/alacritty/alacritty.toml


