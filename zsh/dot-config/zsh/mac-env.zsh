fpath=($fpath $SHARE_DIR/zsh/site-functions)

export HOMEBREW_BREW_GIT_REMOTE="https://mirrors.tuna.tsinghua.edu.cn/git/homebrew/brew.git"
export HOMEBREW_CORE_GIT_REMOTE="https://mirrors.tuna.tsinghua.edu.cn/git/homebrew/homebrew-core.git"
eval "$(/opt/homebrew/bin/brew shellenv)"

add_global_path /opt/homebrew/opt/openjdk/bin
add_global_path "$(go env GOPATH)/bin"


VOLUMES_DIR="/Volumes/Data"
SHARE_DIR="/opt/homebrew/share"
CONDA_FORGE_DIR="$VOLUMES_DIR/env/miniforge"
