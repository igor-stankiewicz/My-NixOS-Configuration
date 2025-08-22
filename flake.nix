{
  description = "Igor Stankiewicz portable NixOS + Home Manager configuration";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-25.05";
    flake-utils.url = "github:numtide/flake-utils";
    home-manager.url = "github:nix-community/home-manager";
  };

  outputs = { self, nixpkgs, flake-utils, home-manager }:
    flake-utils.lib.eachDefaultSystem (system:
      let
        pkgs = import nixpkgs { inherit system; };
        host = builtins.getEnv "HOSTNAME";
        hostConfig = ./system/configuration.nix;
        hostHM = ./home-manager/home.nix;
      in {
        nixosConfigurations = {
          nixos = pkgs.lib.nixosSystem {
            inherit system;
            modules = [
              hostConfig
              # Home Manager integration
              (import home-manager.nixos {
                inherit pkgs;
                modules = [ hostHM ];
              })
            ];
          };
        };
      }
    );
}