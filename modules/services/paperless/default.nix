{ config, lib, ... }:
let
  cfg = config.systemOptions.services.paperless;
  nginx = config.systemOptions.services.nginx;
  pg = config.systemOptions.services.postgresql;
  tls = config.systemOptions.tls;

  host = "paperless.${nginx.baseDomain}";

  dbName = "paperless";
  dbUser = "paperless";

  sopsFile = ../../../secrets/secrets.yaml;
in
{
  options.systemOptions.services.paperless = {
    enable = lib.mkEnableOption "Paperless-ngx document manager";

    dataDir = lib.mkOption {
      type = lib.types.path;
      default = "/var/lib/paperless";
      description = "Directory to store Paperless data (must be persistent).";
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

    sops.secrets.paperlessSecretKey = {
      inherit sopsFile;
      key = "apps/paperless/secretKey";
      owner = "paperless";
      group = "paperless";
      mode = "0400";
    };

    sops.secrets.paperlessAdminPassword = {
      inherit sopsFile;
      key = "apps/paperless/adminPassword";
      owner = "paperless";
      group = "paperless";
      mode = "0400";
    };

    sops.templates.paperless-env = {
      owner = "paperless";
      group = "paperless";
      mode = "0400";
      content = ''
        PAPERLESS_SECRET_KEY=${config.sops.placeholder."paperlessSecretKey"}
      '';
    };

    services = {
      paperless = {
        enable = true;
        address = "127.0.0.1";
        port = 28981;

        dataDir = toString cfg.dataDir;
        mediaDir = "${toString cfg.dataDir}/media";
        consumptionDir = "${toString cfg.dataDir}/consume";

        database.createLocally = true;

        environmentFile = config.sops.templates.paperless-env.path;
        passwordFile = config.sops.secrets.paperlessAdminPassword.path;

        settings = {
          PAPERLESS_URL = "https://${host}"; 
          PAPERLESS_CONSUMER_RECURSIVE = true; 
          PAPERLESS_CONSUMER_SUBDIRS_AS_TAGS = true; 
        };
      };

      postgresql = {
        ensureDatabases = [ dbName ];
        ensureUsers = [
          {
            name = dbUser;
            ensureDBOwnership = true;
          }
        ];
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
