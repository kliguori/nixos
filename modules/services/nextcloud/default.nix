{ config, lib, ... }:
let
  cfg = config.systemOptions.services.nextcloud;
  tls = config.systemOptions.tls;
  nginx = config.systemOptions.services.nginx;
  pgsql = config.systemOptions.services.postgresql;

  host = "nextcloud.${nginx.baseDomain}";
  adminPasswordFile = "/persist/secrets/nextcloud/adminpassFile";
in
{
  options.systemOptions.services.nextcloud = {
    enable = lib.mkEnableOption "Nextcloud (files + calendar/contacts/tasks)";

    homeDir = lib.mkOption {
      type = lib.types.str;
      default = "/var/lib/nextcloud";
      description = "Persistent directory for Nextcloud config + appstore apps.";
    };

    dataDir = lib.mkOption {
      type = lib.types.str;
      default = "/var/lib/nextcloud/data";
      description = "Persistent directory for Nextcloud data.";
    };

  };

  config = lib.mkIf cfg.enable {
    assertions = [
      {
        assertion = nginx.enable;
        message = "nextcloud.enable requires nginx.enable = true.";
      }
      {
        assertion = tls.enable;
        message = "nextcloud.enable requires tls.enable = true.";
      }
      {
        assertion = pgsql.enable;
        message = "nextcloud.enable requires pgsql.enable = true.";
      }
    ];

    systemOptions.services.postgresql.requests = [
      {
        name = "nextcloud";
        user = "nextcloud";
      }
    ];

    services = {
      nextcloud = {
        enable = true;
        hostName = host;
        configureRedis = true;
        https = true;
        home = cfg.homeDir;
        datadir = cfg.dataDir;
        maxUploadSize = "16G";
        caching.apcu = true;
        config = {
          dbtype = "pgsql";
          dbname = "nextcloud";
          dbuser = "nextcloud";
          dbhost = "/run/postgresql";
          adminuser = "admin";
          adminpassFile = adminPasswordFile;
        };

        settings = {
          overwriteprotocol = "https";
          default_phone_region = "US";
          log_type = "systemd";
        };
      };

      nginx.virtualHosts."${host}" = {
        useACMEHost = nginx.baseDomain;
        forceSSL = true;
      };
    };
  };
}
