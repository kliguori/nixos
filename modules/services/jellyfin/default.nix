{ config, lib, ... }:
let
  cfg = config.systemOptions.services.jellyfin;
  nginx = config.systemOptions.services.nginx;
  tls = config.systemOptions.tls;
  impermanence = config.systemOptions.impermanence;
  host = "jellyfin.${nginx.baseDomain}";
in
{
  options.systemOptions.services.jellyfin.enable = lib.mkEnableOption "Jellyfin media server";

  config = lib.mkIf cfg.enable {
    assertions = [
      {
        assertion = nginx.enable;
        message = "jellyfin.enable requires nginx.enable = true.";
      }
      {
        assertion = tls.enable;
        message = "jellyfin.enable requires tls.enable = true.";
      }
    ];

    environment.persistence."/persist".directories = lib.mkIf impermanence.enable [
      "/var/lib/jellyfin"
    ];

    services = {
      jellyfin.enable = true;
      nginx.virtualHosts."${host}" = {
        useACMEHost = nginx.baseDomain;
        forceSSL = true;

        locations."/" = {
          proxyPass = "http://127.0.0.1:8096";
          proxyWebsockets = true;
        };
      };
    };
  };
}
