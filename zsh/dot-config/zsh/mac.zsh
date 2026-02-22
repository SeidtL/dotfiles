VOLUMES_PATH="/Volumes/Data"

SHARE_PATH="/opt/homebrew/share"
CONDA_FORGE_ROOT="$VOLUMES_PATH/env/miniforge"

export HOMEBREW_BREW_GIT_REMOTE="https://mirrors.tuna.tsinghua.edu.cn/git/homebrew/brew.git"
export HOMEBREW_CORE_GIT_REMOTE="https://mirrors.tuna.tsinghua.edu.cn/git/homebrew/homebrew-core.git"
eval "$(/opt/homebrew/bin/brew shellenv)"

if ! command -v eza > /dev/null; then 
    alias ls="ls -Gp"
    alias ll="ls -lhG"
    alias la="ls -alGh"
fi 
