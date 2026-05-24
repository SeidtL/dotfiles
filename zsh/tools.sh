if command -v fzf >/dev/null 2>&1; then
  FIND_CMD=$(command -v fd || command -v fdfind || echo find)
  export FZF_DEFAULT_OPTS="--height=10 --layout=reverse"
  export FZF_DEFAULT_COMMAND="${FIND_CMD} --type f --strip-cwd-prefix --follow --exclude=.venv,.config,.git,.local"
  unset FIND_CMD
  eval "$(fzf --zsh)"
fi
source $HOME/.config/zsh/fzf-git.sh

command -v zoxide >/dev/null 2>&1 && eval "$(zoxide init zsh)"

CONDA_FORGE_DEFAULT_DIR="$HOME/.local/miniforge"
CONDA_FORGE_DIR="${CONDA_FORGE_DIR:-$CONDA_FORGE_DEFAULT_DIR}"
if [ -d "$CONDA_FORGE_DIR" ]; then
  eval "$($CONDA_FORGE_DIR/bin/conda shell.zsh hook)"
fi
unset CONDA_FORGE_DEFAULT_DIR CONDA_FORGE_DIR

if command -v nix-your-shell >/dev/null 2>&1; then
  nix-your-shell zsh | source /dev/stdin
fi
