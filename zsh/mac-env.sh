if [ -e '/nix/var/nix/profiles/default/etc/profile.d/nix-daemon.sh' ]; then
  . '/nix/var/nix/profiles/default/etc/profile.d/nix-daemon.sh'
fi

fpath=($fpath $SHARE_DIR/zsh/site-functions)

eval "$(/opt/homebrew/bin/brew shellenv)"

VOLUMES_DIR="/Volumes/Data"
SHARE_DIR="/opt/homebrew/share"
