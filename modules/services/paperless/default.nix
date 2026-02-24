{ config, lib, ... }:
let
  cfg = config.systemOptions.services.paperless;
  nginx = config.systemOptions.services.nginx;
  tls = config.systemOptions.tls;
  host = "paperless.${nginx.baseDomain}";
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
    ];

    services = {
      paperless = {
        enable = true;
        address = "127.0.0.1";
        port = 28981;
        dataDir = toString cfg.dataDir;
        mediaDir = "${toString cfg.dataDir}/media";
        consumptionDir = "${toString cfg.dataDir}/consume";
        consumptionDirIsPublic = true;
        passwordFile = "/persist/secrets/paperless/password.txt";
        settings = {
          PAPERLESS_URL = "https://${host}";
          PAPERLESS_CONSUMER_RECURSIVE = true;
          PAPERLESS_CONSUMER_SUBDIRS_AS_TAGS = true;
          PAPERLESS_CONSUMER_IGNORE_PATTERN = [
            ".DS_STORE/*"
            "desktop.ini"
          ];
          PAPERLESS_OCR_LANGUAGE = "eng";
          PAPERLESS_OCR_USER_ARGS = {
            optimize = 1;
            pdfa_image_compression = "lossless";
          };
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
