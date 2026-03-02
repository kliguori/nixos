{
  config,
  inputs,
  lib,
  pkgs,
  ...
}:
let
  enabled = lib.elem "kevin" config.systemOptions.users;
in
lib.mkIf enabled {
  sops.secrets."users/kevin/password".neededForUsers = true;

  users.users.kevin = {
    isNormalUser = true;
    shell = pkgs.zsh;
    description = "Kevin Liguori";
    extraGroups = [
      "wheel"
      "networkmanager"
      "lp"
      "scanner"
    ];
    hashedPasswordFile = config.sops.secrets."users/kevin/password".path;
    openssh.authorizedKeys.keys = [ ];
  };

  home-manager.users.kevin.imports = [
    inputs.nixvim.homeModules.nixvim
    inputs.dms.homeModules.dank-material-shell
    ./home.nix
  ];
}
