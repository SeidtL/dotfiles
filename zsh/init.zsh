#!/usr/bin/env zsh 
set -e

function download() {
    curl -f -o $2 $1
}
function download_omz() {
    local url="https://gitee.com/mirrors/oh-my-zsh/raw/master/$1"
    download $url $1
}

rm -rf $HOME/.config/zsh/completion/
rm -rf $HOME/.config/zsh/lib/
rm -rf $HOME/.config/zsh/theme/

mkdir -p lib 
mkdir -p completion 
mkdir -p theme 

download_omz lib/clipboard.zsh
download_omz lib/history.zsh 
download_omz lib/key-bindings.zsh 
download_omz lib/theme-and-appearance.zsh 
download_omz lib/git.zsh
download https://raw.gitcode.com/gh_mirrors/co/conda-zsh-completion/raw/main/_conda completion/_conda

git clone --depth=1 https://gitee.com/romkatv/powerlevel10k.git $HOME/.config/zsh/theme/p10k

ln -sf $HOME/.config/zsh/zshrc $HOME/.zshrc 
ln -sf $HOME/.config/zsh/zshenv $HOME/.zshenv
