{ config, lib, ... }:
let
  cfg = config.systemOptions.services.samba;
  impermanence = config.systemOptions.impermanence;
  paperless = config.systemOptions.services.paperless;

  allowedNets = [
    "10.54.1.0/24"
    "10.54.2.0/24"
    "127.0.0.1"
  ];
in
{
  options.systemOptions.services.samba.enable = lib.mkEnableOption "Turn on samba shares";
  config = lib.mkIf cfg.enable {
    networking.firewall.allowedTCPPorts = [ 445 ];
    
    services.samba = {
      enable = true;
      openFirewall = false;
      winbindd.enable = false;
      settings = lib.mkMerge [
        {
          global = {
            "security" = "user";
            "map to guest" = "never";
            
            # Protocols
            "server min protocol" = "SMB2";
            "server max protocol" = "SMB3";

            # Access controls
            "hosts allow" = lib.concatStringsSep " " allowedNets;
            "hosts deny" = "0.0.0.0/0";

            # Logging
            "log level" = "1 auth:3";
            "logging" = "file";
            "log file" = "/var/log/samba/log.%m";
            "max log size" = "5000";
            
            # Some defaults for zfs
            "ea support" = "yes";
            "vfs objects" = "acl_xattr";
            "map acl inherit" = "yes";
            "store dos attributes" = "yes";
          };
        }

        (lib.mkIf paperless.enable {
          "consume" = {
            "path" = "${paperless.dataDir}/consume";
            "browseable" = "yes";
            "read only" = "no";
            "guest ok" = "no";
            "valid users" = "printer";
            "create mask" = "0660";
            "directory mask" = "0770";
          };
        })
      ];
    };

    environment.persistence."/persist".directories = lib.mkIf impermanence.enable [
      "/var/lib/samba"
    ];
  };
}
