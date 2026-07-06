{
  description = "Default flake template";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs?ref=25.05";
    utils = {
      url = "github:NewDawn0/nixUtils";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };
  outputs =
    {
      utils,
      ...
    }:
    {
      checks = utils.lib.eachSystem { } (
        p: with p; {
          deadnix = pkgs.runCommand "deadnix" {
            nativeBuildInputs = [ pkgs.deadnix ];
          } "deadnix --fail ${./.} && touch $out";
          typos = pkgs.runCommand "typos" {
            nativeBuildInputs = [ pkgs.typos ];
          } "typos --format brief && touch $out";
        }
      );
      formatter = utils.lib.eachSystem { } (p: p.pkgs.alejandra);
      overlays.default = _: prev: {
        sddm-themes = (prev.sddm-themes or { }) // (import ./build.nix { inherit (prev) pkgs; });
      };
      packages = utils.lib.eachSystem { } (p: (import ./build.nix { inherit (p) pkgs; }));
    };
}
