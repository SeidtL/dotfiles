#!/usr/bin/bash
set -e

ZSH_PREFIX=$HOME/.local/share/zsh
function download() {
    curl -sf -o $ZSH_PREFIX/$2 $1
    echo "download $2"
}
function download_omz() {
    local url="https://gitee.com/mirrors/oh-my-zsh/raw/master/$1"
    download $url $1
}

# lib 
mkdir -p $ZSH_PREFIX/lib/
download_omz lib/clipboard.zsh
download_omz lib/history.zsh 
download_omz lib/key-bindings.zsh 
download_omz lib/theme-and-appearance.zsh 
download_omz lib/git.zsh

# theme 
mkdir -p $ZSH_PREFIX/theme/
rm -rf $ZSH_PREFIX/theme/p10k
git clone --quiet --depth=1 --branch master --single-branch \
    https://gitee.com/romkatv/powerlevel10k.git $ZSH_PREFIX/theme/p10k
echo "download p10k"

# site-functions
mkdir -p $ZSH_PREFIX/site-functions/
if command -v rustc &>/dev/null; then 
    rust_toolchain=$(rustup default | awk '{print $1}')
    rust_sysroot=$(rustc +"$rust_toolchain" --print sysroot)
    cp $rust_sysroot/share/zsh/site-functions/_cargo $ZSH_PREFIX/site-functions/_cargo
    rustup completions zsh > $ZSH_PREFIX/site-functions/_rustup
fi
download https://raw.gitcode.com/gh_mirrors/co/conda-zsh-completion/raw/main/_conda site-functions/_conda

if ! grep 'source $HOME/.config/zsh/zshrc' ~/.zshrc &> /dev/null; then 
    echo 'source $HOME/.config/zsh/zshrc' >> "$HOME/.zshrc";
fi

