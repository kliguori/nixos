{ config, lib, ... }:
let
  cfg = config.systemOptions.services.paperless;
  nginx = config.systemOptions.services.nginx;
  pg = config.systemOptions.services.postgresql;
  tls = config.systemOptions.tls;
  host = "paperless.${nginx.baseDomain}";
  sopsFile = ../../../secrets/secrets.yaml;
in
{
  options.systemOptions.services.paperless = {
    enable = lib.mkEnableOption "Paperless-ngx document manager";
    
    dataDir = lib.mkOption {
      type = lib.types.path;
      default = "/var/lib/paperless";
      description = "Persistent directory for Paperless (dataDir, mediaDir, consumeDir).";
    };
  };

  config = lib.mkIf cfg.enable {
    assertions = [
      {
        assertion = nginx.enable;
        message = "paperless.enable requires nginx.enable = true.";
      }
      {
        assertion = tls.enable;
        message = "paperless.enable requires tls.enable = true.";
      }
      {
        assertion = pg.enable;
        message = "paperless.enable requires postgresql.enable = true.";
      }
    ];

    sops = {
      secrets = {
        paperlessSecretKey = {
          inherit sopsFile;
          key = "apps/paperless/secretKey";
          owner = "paperless";
          group = "paperless";
          mode = "0400";
        };

        paperlessAdminPassword = {
          inherit sopsFile;
          key = "apps/paperless/adminPassword";
          owner = "root";
          group = "root";
          mode = "0400";
        };
      };

      templates.paperless-env = {
        owner = "paperless";
        group = "paperless";
        mode = "0400";
        content = ''
          PAPERLESS_SECRET_KEY=${config.sops.placeholder."paperlessSecretKey"}
        '';
      };
    };

    systemd = {
      tmpfiles.rules = [
        "d ${toString cfg.dataDir} 0750 paperless paperless - -"
        "d ${toString cfg.dataDir}/media 0750 paperless paperless - -"
        "d ${toString cfg.dataDir}/consume 0770 paperless paperless - -"
      ];

      # services.paperless-scheduler.preStart = lib.mkBefore ''
      #   ${config.services.paperless.package}/bin/paperless-ngx migrate
      # '';
    };

    services = {
      postgresql = {
        ensureDatabases = [ "paperless" ];
        ensureUsers = [
          {
            name = "paperless";
            ensureDBOwnership = true;
          }
        ];
      };

      paperless = {
        enable = true;
        address = "127.0.0.1";
        port = 28981;
        dataDir = toString cfg.dataDir;
        mediaDir = "${toString cfg.dataDir}/media";
        consumptionDir = "${toString cfg.dataDir}/consume";
        consumptionDirIsPublic = true;
        database.createLocally = false;
        passwordFile = config.sops.secrets.paperlessAdminPassword.path;
        settings = {
          PAPERLESS_URL = "https://${host}";
          PAPERLESS_CONSUMER_RECURSIVE = true;
          PAPERLESS_CONSUMER_SUBDIRS_AS_TAGS = true;
          PAPERLESS_DBENGINE = "postgresql";
          PAPERLESS_DBHOST = "/run/postgresql";
          PAPERLESS_DBNAME = "paperless";
          PAPERLESS_DBUSER = "paperless";
        };
      };

      nginx.virtualHosts."${host}" = {
        useACMEHost = nginx.baseDomain;
        forceSSL = true;
        locations."/" = {
          proxyPass = "http://127.0.0.1:28981";
          proxyWebsockets = true;
        };
      };
    };
  };
}
