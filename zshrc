alias wopen="/mnt/c/Windows/explorer.exe"
alias vi="nvim"
alias ssh="TERM=xterm-256color /bin/ssh"
alias ll="ls -la"


_zsh_add_global_path() {
    case ":$PATH:" in
    *:"$1":*)
        ;;
    *)
        export PATH="$1:$PATH"
    esac
}
_zsh_add_global_path /usr/bin

setopt histignorealldups sharehistory
bindkey -e

# completion 
autoload -Uz compinit && compinit 
zstyle ':completion:*' group-name ''
zstyle ':completion:*' menu select=2
zstyle ':completion:*:default' list-colors ${(s.:.)LS_COLORS}
zstyle ':completion:*' list-colors ''
zstyle ':completion:*' list-prompt %SAt %p: Hit TAB for more, or the character to insert%s
zstyle ':completion:*' matcher-list '' 'm:{a-z}={A-Z}' 'm:{a-zA-Z}={A-Za-z}' 'r:|[._-]=* r:|=* l:|=*'
zstyle ':completion:*' menu select=long
zstyle ':completion:*' select-prompt %SScrolling active: current selection at %p%s
zstyle ':completion:*' use-compctl false
zstyle ':completion:*' verbose true
zstyle ':completion:*:*:kill:*:processes' list-colors '=(#b) #([0-9]#)*=0=01;31'
zstyle ':completion:*:kill:*' command 'ps -u $USER -o pid,%cpu,tty,cputime,cmd'

### Added by Zinit's installer
ZINIT_HOME="${XDG_DATA_HOME:-${HOME}/.local/share}/zinit/zinit.git"
[ ! -d $ZINIT_HOME ] && mkdir -p "$(dirname $ZINIT_HOME)"
[ ! -d $ZINIT_HOME/.git ] && git clone https://github.com/zdharma-continuum/zinit.git "$ZINIT_HOME"
source "${ZINIT_HOME}/zinit.zsh"
autoload -Uz _zinit
(( ${+_comps} )) && _comps[zinit]=_zinit

zinit ice depth"1" # git clone depth
zinit light romkatv/powerlevel10k
zinit light conda-incubator/conda-zsh-completion

zinit snippet OMZL::clipboard.zsh
zinit snippet OMZL::history.zsh
zinit snippet OMZL::key-bindings.zsh
zinit snippet OMZL::theme-and-appearance.zsh
zinit snippet OMZL::git.zsh
zinit snippet OMZP::gitignore

autoload -U compinit && compinit
### End of Zinit's installer chunk

# p10k
if [[ -r "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh" ]]; then
    source "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh"
fi
[[ ! -f ~/.p10k.zsh ]] || source ~/.p10k.zsh

# conda
eval "$($HOME/.local/miniforge/bin/conda shell.zsh hook)"

# go 
export GO111MODULE=on
export GOPROXY=https://goproxy.cn
export GOPATH=$HOME/.local/gohome

# fd 
FIND_CMD=find 
if command -v fd &>/dev/null; then
    FIND_CMD=fd
elif command -v fdfind &>/dev/null; then
    FIND_CMD=fdfind
fi

# fzf 
if command -v fzf &>/dev/null; then 
    export FZF_DEFAULT_OPTS="--height 40% --layout=reverse --border"
    export FZF_DEFAULT_COMMAND="${FIND_CMD} --type f --strip-cwd-prefix --follow --exclude=.venv,.config,.git,.local"
    eval "$(fzf --zsh)"
fi

HISTSIZE=2000
SAVEHIST=2000

unset _zsh_add_global_path FIND_CMD
