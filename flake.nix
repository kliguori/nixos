{
  description = "NixOS System Configurations";

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
  };

  outputs =
    inputs@{
      self,
      nixpkgs,
      unstable,
      ...
    }:
    let
      mkSystem =
        hostName: system:
        let
          unstablePkgs = import unstable {
            inherit system;
            config.allowUnfree = true;
          };

          homeManagerModule = {
            home-manager = {
              useUserPackages = true;
              useGlobalPkgs = true;
              backupFileExtension = "backup";
              extraSpecialArgs = { inherit inputs hostName; };
            };
          };

          diskoModule = {
            disko.devices = import ./systems/${hostName}/disko.nix;
          };
        in
        nixpkgs.lib.nixosSystem {
          inherit system;
          specialArgs = { inherit inputs hostName unstablePkgs; };
          modules = [
            inputs.impermanence.nixosModules.impermanence
            inputs.home-manager.nixosModules.home-manager
            inputs.disko.nixosModules.disko
            inputs.dms.nixosModules.greeter
            homeManagerModule
            diskoModule
            ./overlays
            ./systems/${hostName}
          ];
        };
    in
    {
      formatter = {
        x86_64-linux = nixpkgs.legacyPackages.x86_64-linux.nixfmt-tree;
      };

      nixosConfigurations = {
        sherlock = mkSystem "sherlock" "x86_64-linux";
        # watson = mkSystem "watson" "x86_64-linux";
        mycroft = mkSystem "mycroft" "x86_64-linux";
        # lestrade = mkSystem "lestrade" "x86_64-linux";
      };

    };
}
