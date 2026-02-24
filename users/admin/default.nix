{
  config,
  lib,
  pkgs,
  ...
}:
let
  enabled = lib.elem "admin" config.systemOptions.users;
in
lib.mkIf enabled {
  users.users.admin = {
    isNormalUser = true;
    description = "Server Admin";
    shell = pkgs.zsh;
    extraGroups = [
      "wheel"
      "networkmanager"
    ];
    openssh.authorizedKeys.keys = [
      "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIKjOZvkhZPv1wkLTfC+3A1PqVcAEa6svStem0QCT7PoQ kevin@sherlock"
      "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIDbReMwC07CMv2Mv3ICEvoNrGs1sSDaNZWbGg6cBZ/dh lestrade"
    ];
  };
}
