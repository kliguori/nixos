{ config, lib, ... }:
let
  cfg = config.systemOptions.services.samba;
  paperless = config.systemOptions.services.paperless;
in
{
  options.systemOptions.services.samba.enable = lib.mkEnableOption "Turn on samba shares";
  config = lib.mkIf cfg.enable {
    services.samba = {
      enable = true;
      openFirewall = false;
      winbindd.enable = false;
      settings = lib.mkMerge [
        {
          global = {
            "security" = "user";
            "min protocol" = "SMB2";
            "hosts allow" = "10.54.1. 10.54.2. 127.0.0.1 localhost";
            "hosts deny" = "0.0.0.0/0";
            "guest account" = "nobody";
            "map to guest" = "bad user";
          };
        }

        (lib.mkIf paperless.enable {
          "consume" = {
            "path" = "${paperless.dataDir}/consume";
            "browsable" = "no";
            "read only" = "no";
            "guest ok" = "no";
            "create mask" = "0660";
            "directory mask" = "0770";
            "valid users" = "@printer";
          };
        })
      ];
    };
  };
}
