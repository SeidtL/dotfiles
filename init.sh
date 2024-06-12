CFG_ROOT="$HOME/.config"
mkdir -p $CFG_ROOT/nvim 

ln -s $CFG_ROOT/nvim.lua $CFG_ROOT/nvim/init.lua
ln -s $CFG_ROOT/zshrc $HOME/.zshrc 
ln -s $CFG_ROOT/tmux.conf $HOME/.tmux.conf
