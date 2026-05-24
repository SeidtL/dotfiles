{
  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixpkgs-unstable";
    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = { self, nixpkgs, home-manager, ... }:
  let
    mkHome = system: home-manager.lib.homeManagerConfiguration {
      pkgs = nixpkgs.legacyPackages.${system};
      modules = [ ./home.nix ];
      extraSpecialArgs = {
        isDarwin = nixpkgs.legacyPackages.${system}.stdenv.isDarwin;
      };
    };
  in {
    homeConfigurations = {
      "Linux" = mkHome "x86_64-linux";
      "Darwin" = mkHome "aarch64-darwin";
    };
  };
}
