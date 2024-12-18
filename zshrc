declare -p AUX_FZF_FIND_CMD &>/dev/null || AUX_FZF_FIND_CMD=fd
declare -p AUX_FZF_DOC_ROOT_DIR &>/dev/null || AUX_FZF_DOC_ROOT_DIR="/usr/share/doc/fzf/examples"
declare -p AUX_FZF_EXCLUDE_FOLDER &>/dev/null || AUX_FZF_EXCLUDE_FOLDER="venv,.config,.git,.local"
declare -p CUDA_INSTALL_PATH &>/dev/null || CUDA_INSTALL_PATH=/opt/cuda

alias wopen="/mnt/c/Windows/explorer.exe"
alias code="$WINHOME/opt/Microsoft\ VS\ Code/bin/code"
alias vi="nvim"
alias ssh="TERM=xterm-256color ssh"
alias ll="ls -la"

HISTSIZE=1000
SAVEHIST=1000

# rust 
[[ ! -f $HOME/.cargo/env ]] || . "$HOME/.cargo/env"

# go 
export GO111MODULE=on
export GOPROXY=https://goproxy.cn
export GOPATH=$HOME/.local/gohome

_zsh_add_global_path() {
    local global_path="$PATH"
    for arg in "$@"; do
        case ":${global_path}:" in
        *:"$arg":*)
            ;;
        *)
            global_path="$arg:$global_path"
            ;;
        esac
    done
    export PATH="$global_path"
}

setopt histignorealldups sharehistory
bindkey -e
######################## COMPLETION #####################
# Use modern completion system
autoload -Uz compinit
compinit
zstyle ':completion:*' group-name ''
zstyle ':completion:*' menu select=2
eval "$(dircolors -b)"
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

####################### CUDA #########################
if [[ -e $CUDA_INSTALL_PATH ]]; then 
    export PATH=$PATH:$CUDA_INSTALL_PATH/bin
    export LD_LIBRARY_PATH=$LD_LIBRARY_PATH:$CUDA_INSTALL_PATH/lib64
fi
unset CUDA_INSTALL_PATH

########################### ZINIT ###################################
### Added by Zinit's installer
ZINIT_HOME="${XDG_DATA_HOME:-${HOME}/.local/share}/zinit/zinit.git"
[ ! -d $ZINIT_HOME ] && mkdir -p "$(dirname $ZINIT_HOME)"
[ ! -d $ZINIT_HOME/.git ] && git clone https://github.com/zdharma-continuum/zinit.git "$ZINIT_HOME"
source "${ZINIT_HOME}/zinit.zsh"

autoload -Uz _zinit
(( ${+_comps} )) && _comps[zinit]=_zinit

# Load a few important annexes, without Turbo
# (this is currently required for annexes)
zinit light-mode for \
    zdharma-continuum/zinit-annex-as-monitor \
    zdharma-continuum/zinit-annex-bin-gem-node \
    zdharma-continuum/zinit-annex-patch-dl \
    zdharma-continuum/zinit-annex-rust

zinit ice depth"1" # git clone depth
zinit light romkatv/powerlevel10k

zinit snippet OMZL::clipboard.zsh
zinit snippet OMZL::history.zsh
zinit snippet OMZL::key-bindings.zsh
zinit snippet OMZL::theme-and-appearance.zsh
zinit snippet OMZP::sudo

zinit snippet OMZL::git.zsh
zinit snippet OMZP::gitignore
zinit ice atload"unalias grv"
zinit snippet OMZP::git 

zinit light conda-incubator/conda-zsh-completion
autoload -U compinit && compinit
### End of Zinit's installer chunk

############################# P10K #############################
if [[ -r "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh" ]]; then
  source "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh"
fi
# To customize prompt, run `p10k configure` or edit ~/.p10k.zsh.
[[ ! -f ~/.p10k.zsh ]] || source ~/.p10k.zsh

############################# PYENV #########################
# _zsh_python_venv() {
#     for pyvenv in ./.venv/ ./venv/; do 
#         [[ -d $pyvenv ]] && source $pyvenv/bin/activate > /dev/null 2>&1
#         [[ ! -d $pyvenv ]] && deactivate > /dev/null 2>&1
#     done
# }
# autoload -U add-zsh-hook
# add-zsh-hook chpwd _zsh_python_venv
# _zsh_python_venv

###################### FZF ##############################
AUX_FZF_PREFIX_DEFAULT_OPT='--height 40% --layout=reverse --border'
export FZF_DEFAULT_OPTS="$AUX_FZF_PREFIX_DEFAULT_OPT"
export FZF_DEFAULT_COMMAND="${AUX_FZF_FIND_CMD} --type f --strip-cwd-prefix --follow --exclude=$AUX_FZF_EXCLUDE_FOLDER"
if [[ -e $AUX_FZF_DOC_ROOT_DIR ]]; then 
    source $AUX_FZF_DOC_ROOT_DIR/completion.zsh
    source $AUX_FZF_DOC_ROOT_DIR/key-bindings.zsh
fi 
unset AUX_FZF_DOC_ROOT_DIR AUX_FZF_EXCLUDE_FOLDER AUX_FZF_DOC_ROOT_DIR AUX_FZF_PREFIX_DEFAULT_OPT

