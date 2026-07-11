#!/bin/bash
if command -v yazi >/dev/null 2>&1; then
  return 0
fi

tmp_path=$(mktemp -d)
trap 'rm -rf "$tmp_path"' EXIT
cd "$tmp_path"

zip_url=$(curl -sL https://api.github.com/repos/sxyazi/yazi/releases/latest | \
          jq -r '.assets[] | select(.name | test("x86_64-unknown-linux-gnu\\.zip$")) | .browser_download_url' | head -1)
[ -z "$zip_url" ] && cd - >/dev/null && exit 1
zip_file=$(basename "$zip_url")
curl -sLO "$zip_url"
unzip -q -o "$zip_file"
[ -d "yazi-x86_64-unknown-linux-gnu" ] && cd yazi-x86_64-unknown-linux-gnu
sudo mkdir -p /opt/yazi
sudo cp -r . /opt/yazi/
sudo ln -sf /opt/yazi/yazi /usr/local/bin/yazi
sudo ln -sf /opt/yazi/ya /usr/local/bin/ya
