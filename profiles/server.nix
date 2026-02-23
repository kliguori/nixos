{ config, lib, ... }:
let
  cfg = config.systemOptions;
in
{
  config = lib.mkIf (lib.elem "server" cfg.profiles) {
    systemOptions = {
      desktop.enable = lib.mkDefault false;
      tls.enable = lib.mkDefault true;
      services = {
        nginx.enable = lib.mkDefault true;
        jellyfin.enable = lib.mkDefault true;
        vaultwarden = {
          enable = lib.mkDefault true;
          dataDir = "/data/vaultwarden";
        };
        paperless = {
          enable = lib.mkDefault true;
          dataDir = "/data/paperless";
        };
      };
    };
  };
}
