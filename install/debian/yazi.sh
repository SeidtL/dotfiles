#!/bin/bash
tmp_path=$(mktemp -d)
trap 'rm -rf "$tmp_path"' EXIT
cd "$tmp_path"

deb_url=$(curl -sL https://api.github.com/repos/sxyazi/yazi/releases/latest | \
          jq -r '.assets[] | select(.name | test("x86_64-unknown-linux-gnu\\.deb$")) | .browser_download_url' | head -1)
[ -z "$deb_url" ] && cd - >/dev/null && return 1
deb_file=$(basename "$deb_url")
curl -sLO "$deb_url"
sudo apt-get install -y "./$deb_file"
