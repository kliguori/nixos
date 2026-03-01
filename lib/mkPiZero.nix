inputs@{ nixpkgs, ... }:
hostName: system:
let
  crossPkgs = import nixpkgs {
    localSystem = system;
    crossSystem = "aarch64-linux";
    config.allowUnfree = true;
  };
in
nixpkgs.lib.nixosSystem {
  specialArgs = { inherit inputs hostName; };
  modules = [
    inputs.sops-nix.nixosModules.sops
    "${nixpkgs}/nixos/modules/installer/sd-card/sd-image-aarch64.nix"
    { nixpkgs.pkgs = crossPkgs; }
    ../systems/${hostName}
  ];
}
