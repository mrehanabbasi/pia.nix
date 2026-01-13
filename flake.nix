{
  description = "Private Internet Access VPN CLI for NixOS using manual-connections";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    flake-utils.url = "github:numtide/flake-utils";
  };

  outputs = { self, nixpkgs, flake-utils }:
    flake-utils.lib.eachDefaultSystem (system:
      let
        pkgs = import nixpkgs { inherit system; };
        lib = pkgs.lib;
      in
      {
        packages = {
          pia = import ./cli.nix { inherit lib pkgs; };
          default = self.packages.${system}.pia;
        };

        apps = {
          default = self.apps.${system}.pia;
          pia = {
            type = "app";
            program = "${self.packages.${system}.pia}/bin/pia";
          };
        };

        devShells.default = pkgs.mkShell {
          buildInputs = with pkgs; [
            curl
            jq
            wireguard-tools
            openvpn
            fzf
          ];
        };
      }
    ) // {
      nixosModules.default = import ./module.nix { inherit self; };
      nixosModules.pia = self.nixosModules.default;
    };
}
