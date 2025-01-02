alias vi=nvim
alias ssh="TERM=xterm-256color /bin/ssh"

fish_add_path -U $HOME/.cargo/bin $HOME/.local/miniforge/bin

# fish
set __fish_git_prompt_showuntrackedfiles 'yes'
set __fish_git_prompt_showdirtystate 'yes'
set __fish_git_prompt_showstashstate ''
set __fish_git_prompt_showupstream 'none'
set -g fish_prompt_pwd_dir_length 3
set fish_greeting

# env 
setenv GO11MODULE on 
setenv GOPROXY https://goproxy.cn 
setenv GOPATH $HOME/.local/gohome

# prompt
# fish_config prompt choose arrow
fish_config theme choose Lava
if command -v conda > /dev/null
    status is-interactive && eval conda "shell.fish" "hook" $argv | source
end 

# fzf
if command -v fzf > /dev/null 
    setenv FZF_DEFAULT_COMMAND 'fdfind --type f --strip-cwd-prefix --exclude=venv,.config,.git,.local --follow'
    setenv FZF_CTRL_T_COMMAND 'fdfind --type f --strip-cwd-prefix --exclude=venv,.config,.git,.local --follow'
    setenv FZF_DEFAULT_OPTS '--height=10 --layout=reverse'
    fzf --fish | source
end
