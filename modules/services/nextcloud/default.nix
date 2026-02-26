{ config, lib, ... }:
let
  cfg = config.systemOptions.services.nextcloud;
  nginx = config.systemOptions.services.nginx;
  tls = config.systemOptions.tls;
  pgsql = config.systemOptions.postgresql;
  
  host = "nextcloud.${nginx.baseDomain}";
  homeDir = cfg.nextcloudDir; 
  dataDir = "${cfg.homeDir}/data";
  secretsDir = "/persist/secrets/apps/nextcloud";
in
{
  options.systemOptions.services.nextcloud = {
    enable = lib.mkEnableOption "Nextcloud (files + calendar/contacts/tasks)";

    nextcloudDir = lib.mkOption {
      type = lib.types.str;
      default = "/var/lib/nextcloud";
      description = "Persistent directory for Nextcloud (config + data + appstore apps).";
    };
  };

  config = lib.mkIf cfg.enable {
    assertions = [
      { assertion = nginx.enable; message = "nextcloud.enable requires nginx.enable = true."; }
      { assertion = tls.enable; message = "nextcloud.enable requires tls.enable = true."; }
      { assertion = pgsql.enable; message = "nextcloud.enable requires pgsql.enable = true."; }
    ];

    systemd.tmpfiles.rules = [
      "d ${homeDir} 0750 nextcloud nextcloud - -"
    ];

    services.redis.servers.nextcloud = {
      enable = true;
      unixSocket = "/run/redis-nextcloud/redis.sock";
      unixSocketPerm = 770;
    };
    users.users.nextcloud.extraGroups = [ "redis-nextcloud" ];

    services.nextcloud = {
      enable = true;
      hostName = host;
      https = true;
      home = homeDir;
      datadir = dataDir;
      maxUploadSize = "16G";
      caching = {
        apcu = true;
        redis = true;
      };

      database.createLocally = true;
      config = {
        dbtype = "pgsql";
        dbname = "nextcloud";
        dbuser = "nextcloud";
        dbhost = "/run/postgresql";
        dbpassFile = "${secretsDir}/dbpassFile";

        adminuser = "admin";
        adminpassFile = "${secretsDir}/adminpassFile";
      };

      settings = {
        overwriteprotocol = "https";
        default_phone_region = "US";
        
        # Redis: distributed cache + file locking
        "memcache.local" = "\\OC\\Memcache\\APCu";
        "memcache.distributed" = "\\OC\\Memcache\\Redis";
        "memcache.locking" = "\\OC\\Memcache\\Redis";
        "filelocking.enabled" = true;
        redis = {
          host = "/run/redis-nextcloud/redis.sock";
          port = 0;
        };

        trusted_domains = [ host ];
        log_type = "systemd";
      };
    };

    services.nginx.virtualHosts."${host}" = {
      useACMEHost = nginx.baseDomain;
      forceSSL = true;
    };

    systemd.services.nextcloud-setup = {
      requires = [ "postgresql.service" ];
      after = [ "postgresql.service" ];
    };
  };
}
