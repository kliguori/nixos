{
  description = "One flake to rule them all, one flake to define them, one flake to build them all, and in the darkness apply them";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-25.11";
    unstable.url = "github:nixos/nixpkgs/nixos-unstable";
    nixos-hardware.url = "github:nixos/nixos-hardware/master";
    impermanence.url = "github:nix-community/impermanence";
    nixvim = {
      url = "github:nix-community/nixvim/nixos-25.11";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    home-manager = {
      url = "github:nix-community/home-manager/release-25.11";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    disko = {
      url = "github:nix-community/disko";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    dms = {
      url = "github:AvengeMedia/DankMaterialShell/stable";
      inputs.nixpkgs.follows = "unstable";
    };
    sops-nix = {
      url = "github:Mic92/sops-nix";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs =
    inputs@{ nixpkgs, ... }:
    let
      mkSystem = import ./lib/mkSystem.nix inputs;
      mkPiZero = import ./lib/mkPiZero.nix inputs;
    in
    {
      formatter = {
        x86_64-linux = nixpkgs.legacyPackages.x86_64-linux.nixfmt-tree;
      };

      nixosConfigurations = {
        sherlock = mkSystem "sherlock" "x86_64-linux";
        lestrade = mkSystem "lestrade" "x86_64-linux";
        mycroft = mkSystem "mycroft" "x86_64-linux";
        # watson = mkSystem "watson" "x86_64-linux";
        # Adler = mkPiZero "adler" "x86_64-linux"; # the x86 is the build machine system
      };
    };
}
