# README

Initialize for Darwin system:

```bash
sh <(curl --proto '=https' --tlsv1.2 -L https://nixos.org/nix/install) --no-daemon
nix profile add nixpkgs#home-manager

cd ~/.config/nix
home-manager switch --flake .#$(uname -s)
```

## gc

```bash
sudo nix-collect-garbage -d
nix-store --gc
```
