set -gx HOMEBREW_BREW_GIT_REMOTE "https://mirrors.tuna.tsinghua.edu.cn/git/homebrew/brew.git"
set -gx HOMEBREW_CORE_GIT_REMOTE "https://mirrors.tuna.tsinghua.edu.cn/git/homebrew/homebrew-core.git"

eval (/opt/homebrew/bin/brew shellenv)

fish_add_path -U PATH="/opt/homebrew/opt/openjdk/bin:$PATH"
eval (zoxide init zsh)

if test -f ~/.orbstack/shell/init2.fish
    source ~/.orbstack/shell/init2.fish
end
