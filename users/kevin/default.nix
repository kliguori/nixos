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
      "docker"
      "lp"
      "scanner"
    ];
    hashedPasswordFile = config.sops.secrets."users/kevin/password".path;
    openssh.authorizedKeys.keys = [
      "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIKjOZvkhZPv1wkLTfC+3A1PqVcAEa6svStem0QCT7PoQ kevin@sherlock"
      "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAICWTkqAIUlV0Lap37yUCrWej+XzhzkxYNgff1bwlxszv kevin@watson"
    ];
  };

  home-manager.users.kevin.imports = [
    inputs.nixvim.homeModules.nixvim
    inputs.dms.homeModules.dank-material-shell
    ./home.nix
  ];
}
