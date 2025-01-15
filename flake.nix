{
  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
  };
  outputs = {
    self,
    nixpkgs,
  }: let
    system = "x86_64-linux";
    pkgs = import nixpkgs {inherit system;};
  in
    with nixpkgs.lib; {
      packages.${system} = rec {
        sddm-astronaut-theme = pkgs.callPackage ./nix {};
        default = sddm-astronaut-theme;
      };
    };
}
