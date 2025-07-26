function add_global_path() {
    case ":$PATH:" in
    *:"$1":*)
        ;;
    *)
        export PATH="$1:$PATH"
    esac
}
add_global_path /usr/bin
add_global_path $HOME/.local/bin
add_global_path $HOME/.cargo/bin
add_global_path /opt/zig
add_global_path /opt/go/bin
add_global_path /opt/node/bin
unset add_global_path

export EDITOR="nvim"

export GO111MODULE=on
export GOPROXY=https://goproxy.cn
export GOPATH=$HOME/.local/gohome

FIND_CMD=find
if command -v fd &>/dev/null; then
    FIND_CMD=fd
elif command -v fdfind &>/dev/null; then
    FIND_CMD=fdfind
fi
export FZF_DEFAULT_OPTS="--height=10 --layout=reverse"
export FZF_DEFAULT_COMMAND="${FIND_CMD} --type f --strip-cwd-prefix --follow --exclude=.venv,.config,.git,.local"
unset FIND_CMD
