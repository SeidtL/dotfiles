#!/bin/zsh

rm -rf $HOME/.zshrc $HOME/.zshenv $HOME/.zprofile $HOME/.zsh_history
echo 'source $HOME/.config/zsh/zshrc' > $HOME/.zshrc
echo 'source $HOME/.config/zsh/profile.sh'  > $HOME/.zprofile

if [[ $(uname -s) == "Darwin" ]]; then
    zsh_sys_path="/opt/homebrew/share"
else
    zsh_sys_path="/usr/share/zsh/plugins"
fi

zsh_data_path="$data_path/zsh"
mkdir -p $zsh_data_path
echo $zsh_data_pat
ensure_repo() {
    [ -d "$2/.git" ] && git -C "$2" log -1 &>/dev/null && return 0
    [ -d "$2" ] && rm -rf "$2"
    git clone --depth 1 --single-branch "$1" "$2" &>/dev/null || exit 1
}
ensure_repo "https://github.com/ohmyzsh/ohmyzsh.git" "$zsh_data_path/oh-my-zsh" &
ensure_repo "https://github.com/romkatv/powerlevel10k.git" "$zsh_data_path/zsh-powerlevel10k" &
wait

rm -rf $zsh_data_path/zsh-autosuggestions
ln -sf $zsh_sys_path/zsh-autosuggestions $zsh_data_path/zsh-autosuggestions

unset syspkg_zsh_paths zsh_sys_path zsh_data_path
