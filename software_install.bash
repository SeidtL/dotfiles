#!/usr/bin/bash
set -ex

WORKSPACE=$(mktemp -d)
trap "rm -rf ${WORKSPACE}" EXIT

echo "working in ${WORKSPACE}"

NODE_VERSION="v24.11.1"
GOLANG_VERSION="1.25.4"

function download() {
    local URL="$1"
    local OUTPATH="$2"

    echo "Download from: $URL"
    echo "Downloading..."

    curl -L -o "${OUTPATH}" "${URL}"

    echo "Done: ${OUTPATH}"
}

function install_yazi() {
    local REPO="sxyazi/yazi"
    local ASSET_NAME="yazi-x86_64-unknown-linux-gnu.zip"

    local DOWNLOAD_URL=$(curl -s "https://api.github.com/repos/${REPO}/releases/latest" \
        | jq -r ".assets[] | select(.name == \"${ASSET_NAME}\") | .browser_download_url")

    if [[ -z "$DOWNLOAD_URL" || "$DOWNLOAD_URL" == "null" ]]; then
        exit 1
    fi

    download "$DOWNLOAD_URL" "${WORKSPACE}/${ASSET_NAME}"

    unzip -o "${WORKSPACE}/${ASSET_NAME}" -d "${WORKSPACE}"
    rm "${WORKSPACE}/${ASSET_NAME}"

    [ -d "/opt/yazi" ] && sudo rm -rf /opt/yazi
    sudo mv "${WORKSPACE}/${ASSET_NAME%%.*}" "/opt/yazi"
}

function install_nvim() {
    local REPO="neovim/neovim"
    local ASSET_NAME="nvim-linux-x86_64.tar.gz"

    local DOWNLOAD_URL=$(curl -s "https://api.github.com/repos/${REPO}/releases/latest" \
        | jq -r ".assets[] | select(.name == \"${ASSET_NAME}\") | .browser_download_url")

    if [[ -z "$DOWNLOAD_URL" || "$DOWNLOAD_URL" == "null" ]]; then
        exit 1
    fi

    download "$DOWNLOAD_URL" "${WORKSPACE}/${ASSET_NAME}"


    tar -xvf "${WORKSPACE}/${ASSET_NAME}" -C "${WORKSPACE}"
    rm "${WORKSPACE}/${ASSET_NAME}"

    [ -d "/opt/nvim" ] && sudo rm -rf /opt/nvim
    sudo mv "${WORKSPACE}/${ASSET_NAME%%.*}" "/opt/nvim"
}

function install_node() {
    local ASSET="node-${NODE_VERSION}-linux-x64"
    local URL="https://mirrors.ustc.edu.cn/node/${NODE_VERSION}/${ASSET}.tar.xz"
    download "$URL" "${WORKSPACE}/${ASSET}.tar.xz"
    
    tar -xvf "${WORKSPACE}/${ASSET}.tar.xz" -C "${WORKSPACE}"
    rm "${WORKSPACE}/${ASSET}.tar.xz"

    [ -d "/opt/node" ] && sudo rm -rf /opt/node
    sudo mv "${WORKSPACE}/${ASSET}" "/opt/node"
}

function install_golang() {
    local ASSET="go${GOLANG_VERSION}.linux-amd64"
    local URL="https://mirrors.ustc.edu.cn/golang/${ASSET}.tar.gz"
    download "$URL" "${WORKSPACE}/${ASSET}.tar.gz"
    
    tar -xvf "${WORKSPACE}/${ASSET}.tar.gz" -C "${WORKSPACE}"
    rm "${WORKSPACE}/${ASSET}.tar.gz"

    [ -d "/opt/go" ] && sudo rm -rf /opt/go
    sudo mv "${WORKSPACE}/go" "/opt/go"
}

install_node
install_golang

install_yazi
sudo ln -sf /opt/yazi/yazi /usr/local/bin/yazi

install_nvim
