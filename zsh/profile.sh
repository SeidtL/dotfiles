function add_global_path() {
  case ":$PATH:" in
  *:"$1":*)
    ;;
  *)
    export PATH="$1:$PATH"
  esac
}
add_global_path /usr/bin
add_global_path $HOME/.local/bin
add_global_path $HOME/.cargo/bin

export EDITOR="nvim"

export GO111MODULE=on
export GOPROXY=https://goproxy.cn
export GOPATH=$HOME/.local/gohome

if [ -e /home/seidtl/.nix-profile/etc/profile.d/nix.sh ]; then
  source /home/seidtl/.nix-profile/etc/profile.d/nix.sh;
fi # added by Nix installer

[[ $OSTYPE == "darwin"* ]] && source "$HOME/.config/zsh/mac-env.zsh"
