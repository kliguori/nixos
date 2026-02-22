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
      "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIDbReMwC07CMv2Mv3ICEvoNrGs1sSDaNZWbGg6cBZ/dh lestrade"
      "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIEtVjlECPNj4BXiThBDx6Wx7BAmN+eR9EYacXU+4Ox9H kevin@sherlock"
      "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIOavirFl6Xk3GR2bFfGzX28RYqfwld5lnBdSjTTCAV/0 kevin@macbook"
    ];
  };
}
