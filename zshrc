_FZF_FIND_CMD=fd
HISTSIZE=1000
SAVEHIST=1000
HISTFILE=~/.zsh_history

alias vi="nvim"
alias ssh="TERM=xterm-256color ssh"

setopt histignorealldups sharehistory
bindkey -e

export PATH="$PATH:/usr/bin"
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
CUDA_INSTALL_PATH=/usr/local/cuda-12.4
if [[ -e $CUDA_INSTALL_PATH ]]; then 
    export PATH=$PATH:$CUDA_INSTALL_PATH/bin
    export LD_LIBRARY_PATH=$LD_LIBRARY_PATH:$CUDA_INSTALL_PATH/lib64
fi
unset CUDA_INSTALL_PATH

###################### FZF ##############################
export FZF_DEFAULT_OPTS='--height 40% --layout=reverse --border'
export FZF_DEFAULT_COMMAND="${_FZF_FIND_CMD} --type f --strip-cwd-prefix --follow --exclude venv"
_FZF_DOC_ROOT_DIR="/usr/share/fzf"
source $_FZF_DOC_ROOT_DIR/completion.zsh
source $_FZF_DOC_ROOT_DIR/key-bindings.zsh
unset _FZF_DOC_ROOT_DIR


############################# PYENV #########################
python_venv() {
    MYVENV=./venv/
    [[ -d $MYVENV ]] && source $MYVENV/bin/activate > /dev/null 2>&1
    [[ ! -d $MYVENV ]] && deactivate > /dev/null 2>&1
}
autoload -U add-zsh-hook
add-zsh-hook chpwd python_venv
python_venv


########################### ZINIT ###################################
### Added by Zinit's installer
if [[ ! -f $HOME/.local/share/zinit/zinit.git/zinit.zsh ]]; then
    print -P "%F{33} %F{220}Installing %F{33}ZDHARMA-CONTINUUM%F{220} Initiative Plugin Manager (%F{33}zdharma-continuum/zinit%F{220})…%f"
    command mkdir -p "$HOME/.local/share/zinit" && command chmod g-rwX "$HOME/.local/share/zinit"
    command git clone https://github.com/zdharma-continuum/zinit "$HOME/.local/share/zinit/zinit.git" && \
        print -P "%F{33} %F{34}Installation successful.%f%b" || \
        print -P "%F{160} The clone has failed.%f%b"
fi

source "$HOME/.local/share/zinit/zinit.git/zinit.zsh"
autoload -Uz _zinit
(( ${+_comps} )) && _comps[zinit]=_zinit

# Load a few important annexes, without Turbo
# (this is currently required for annexes)
zinit light-mode for \
    zdharma-continuum/zinit-annex-as-monitor \
    zdharma-continuum/zinit-annex-bin-gem-node \
    zdharma-continuum/zinit-annex-patch-dl \
    zdharma-continuum/zinit-annex-rust

zinit snippet OMZ::lib/clipboard.zsh
zinit snippet OMZ::lib/history.zsh
zinit snippet OMZ::lib/key-bindings.zsh
zinit snippet OMZ::lib/theme-and-appearance.zsh
zinit snippet OMZ::plugins/sudo/sudo.plugin.zsh
zinit snippet OMZP::gitignore
zinit snippet OMZ::lib/git.zsh
zinit snippet OMZ::plugins/git/git.plugin.zsh

zinit ice depth"1" # git clone depth
zinit light romkatv/powerlevel10k
# zi cdclear -q # <- forget completions provided up to this moment
# setopt promptsubst
# zi snippet OMZT::robbyrussell
### End of Zinit's installer chunk

############################# P10K #############################
if [[ -r "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh" ]]; then
  source "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh"
fi
# To customize prompt, run `p10k configure` or edit ~/.p10k.zsh.
[[ ! -f ~/.p10k.zsh ]] || source ~/.p10k.zsh



# >>> conda initialize >>>
# !! Contents within this block are managed by 'conda init' !!
__conda_setup="$('/opt/miniconda3/bin/conda' 'shell.zsh' 'hook' 2> /dev/null)"
if [ $? -eq 0 ]; then
    eval "$__conda_setup"
else
    if [ -f "/opt/miniconda3/etc/profile.d/conda.sh" ]; then
        . "/opt/miniconda3/etc/profile.d/conda.sh"
    else
        export PATH="/opt/miniconda3/bin:$PATH"
    fi
fi
unset __conda_setup
# <<< conda initialize <<<
export CRYPTOGRAPHY_OPENSSL_NO_LEGACY=1

