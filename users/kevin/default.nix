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
  users.users.kevin = {
    isNormalUser = true;
    shell = pkgs.zsh;
    description = "Kevin Liguori";
    extraGroups = [
      "wheel"
      "networkmanager"
    ];
    hashedPassword = "$6$UZmN9CmJmm2mYMVc$Ia3O4psbyXfjM59NEbZY5PBfy.IxIA8yta9F9hYOJ4MVuuFwyrRB1E0uysmG5f8Q1mfZjzlLJ0sES1RQymCUt.";
    openssh.authorizedKeys.keys = [ ];
  };

  home-manager.users.kevin.imports = [
    inputs.nixvim.homeModules.nixvim
    inputs.dms.homeModules.dank-material-shell
    ./home.nix
  ];
}
