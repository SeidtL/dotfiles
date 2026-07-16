#!/bin/zsh
if command -v code >/dev/null 2>&1; then
  return 0
fi

tmp_path=$(mktemp -d)
trap 'rm -rf "$tmp_path"' EXIT
cd "$tmp_path"

deb_url=https://vscode.download.prss.microsoft.com/dbazure/download/stable/61b3d0ab13be7dda2389f1d3e60a119c7f660cc3/code_1.110.1-1772839366_amd64.deb
deb_file=$(basename "$deb_url")
curl -sLO "$deb_url"
sudo dpkg -i "$deb_file"
sudo apt install -f -y
