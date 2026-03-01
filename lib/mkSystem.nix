inputs@{ nixpkgs, unstable, ... }:
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
    disko.devices = import ../systems/${hostName}/disko.nix;
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
    ../overlays
    ../systems/${hostName}
  ];
}
