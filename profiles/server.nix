{
  config,
  lib,
  pkgs,
  ...
}:
let
  cfg = config.systemOptions;
in
{
  config = lib.mkIf (lib.elem "server" cfg.profiles) {
    systemOptions = {
      desktop.enable = lib.mkForce false;
      impermanence.includeHomeDir = false;
      tls.enable = true;
      services = {
        samba.enable = true;
        nginx.enable = true;
        jellyfin.enable = true;
        postgresql = {
          enable = true;
          dataDir = "/data/postgresql";
        };
        nextcloud = {
          enable = true;
          homeDir = "/data/nextcloud";
          dataDir = "/data/nextcloud/data";
        };
        vaultwarden = {
          enable = true;
          signupsAllowed = true;
          dataDir = "/data/vaultwarden";
        };
        paperless = {
          enable = true;
          dataDir = "/data/paperless";
        };
      };
    };

    environment.systemPackages = with pkgs; [
      ncurses
      kitty.terminfo
    ];
  };
}
