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

# go
export GO111MODULE=on
export GOPROXY=https://goproxy.cn
export GOPATH=$HOME/.local/gohome

