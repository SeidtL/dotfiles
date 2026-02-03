case $- in
    *i*) ;;
      *) return;;
esac

alias ls="ls -F --color=auto --group-directories-first"
alias ll="ls -lh --time-style=long-iso"
alias la="ls -A"

alias gs="git status -s 2>/dev/null"
alias gck="git checkout"
alias gcp="git cherry-pick"
alias ga="git add"
alias gd="git diff"
alias gc="git commit"
alias gb="git branch"
alias gds="git diff --staged"
alias gdw="git diff --word-diff"
alias gdws="git diff --word-diff --staged"
alias gl="git log --graph --pretty=format:'%Cred%h%Creset%C(yellow)%d%Creset %s%Cgreen(%cr)' --abbrev-commit"
alias gcl="git clone"

alias ipython="python3 -m IPython"

alias wopen="/mnt/c/Windows/explorer.exe"
alias vi="nvim"
alias ssh="TERM=xterm-256color /usr/bin/ssh"

alias ipython="python3 -m IPython"

[ -f "/usr/share/bash-completion/bash_completion" ] && . /usr/share/bash-completion/bash_completion

HISTSIZE=2000
HISTFILESIZE=40000
HISTCONTROL=ignoreboth
HISTFILE=$HOME/.local/bash_history

shopt -s histappend
shopt -s globstar
shopt -s checkwinsize
shopt -s autocd

GIT_PROMPT_SH='/usr/lib/git-core/git-sh-prompt'
[ -f "$GIT_PROMPT_SH" ] && . "$GIT_PROMPT_SH"
GIT_PS1_SHOWDIRTYSTATE=1
GIT_PS1_SHOWSTASHSTATE=1
GIT_PS1_SHOWUNTRACKEDFILES=1
GIT_PS1_STATESEPARATOR=" "
GIT_PS1_DESCRIBE_STYLE=1
GIT_PS1_SHOWCOLORHINTS=1
GIT_PS1_SHOWUPSTREAM=1 

prompt() {
    if [ ! $UID -eq 0 ]; then
        if [ -n "$SSH_CONNECTION" ]; then
            PS1='\[\033[37;105m\]\u@\h\[\033[00;00m\] \[\033[01;40m\]\w$(__git_ps1 " %s")\[\033[00;00m\] \n\$ '
        else
            [ -n "$HISTFILE" ] && PS1='\[\033[00;106m\]\u@\h\[\033[00;00m\] \[\033[01;40m\]\w$(__git_ps1 " %s")\[\033[00;00m\] \n\$ '
            [ -z "$HISTFILE" ] && PS1='\[\033[30;106m\]\u@\h\[\033[00;00m\] \[\033[01;40m\]\w$(__git_ps1 " %s")\[\033[00;00m\] \n\$ '
        fi
    else
        PS1='\[\033[30;107m\]\u@\h\[\033[00;00m\] \[\033[01;40m\]\w$(__git_ps1 " %s")\[\033[00;00m\] \n\$ '
    fi
}
prompt

[ -x "$(command -v fzf)" ] && eval "$(fzf --bash)"
FIND_CMD=$(command -v fd || command -v fdfind || echo find)
export FZF_DEFAULT_OPTS="--height=10 --layout=reverse"
export FZF_DEFAULT_COMMAND="${FIND_CMD} --type f --strip-cwd-prefix --follow --exclude=.venv,.config,.git,.local"
unset FIND_CMD

