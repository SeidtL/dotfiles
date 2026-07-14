if [[ $ENABLE_CUSTOM = "1" ]]; then
  PROMPT='
%F{150}%}%n@%m%{$reset_color%} %{$fg[cyan]%}%~%{$reset_color%} $(git_prompt_info)
 %(?:%{$fg_bold[green]%}%1{➜%}%{$reset_color%} :%{$fg_bold[red]%}%1{➜%}%{$reset_color%} )'

  ZSH_THEME_GIT_PROMPT_PREFIX="%{$fg_bold[blue]%}git:(%{$fg[red]%}"
  ZSH_THEME_GIT_PROMPT_SUFFIX="%{$reset_color%} "
  ZSH_THEME_GIT_PROMPT_DIRTY="%{$fg[blue]%}) %{$fg[yellow]%}%1{✗%}"
  ZSH_THEME_GIT_PROMPT_CLEAN="%{$fg[blue]%})"
else
  source $ZSHAREDIR/zsh-powerlevel10k/powerlevel10k.zsh-theme
  [[ -r "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh" ]] && \
    source "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh"
  [[ ! -f $HOME/.p10k.zsh ]] || source $HOME/.p10k.zsh
fi
