{ config, lib, ... }:
let
  cfg = config.systemOptions.impermanence;
in
{
  options.systemOptions.impermanence = {
    enable = lib.mkOption {
      type = lib.types.bool;
      default = true;
      description = "Impermanent root with persistence under /persist";
    };

    rootTmpfsSize = lib.mkOption {
      type = lib.types.str;
      default = "8G";
      description = "Optional tmpfs size";
    };

    includeHomeDir = lib.mkOption {
      type = lib.types.bool;
      default = true;
      description = "Include home directory from rpool? If home is on a different pool -> false";
    };

    rpool = lib.mkOption {
      type = lib.types.str;
      default = "rpool";
      description = "Name of the required boot pool that contains /nix and /persist.";
    };

    systemDirs = lib.mkOption {
      type = lib.types.listOf lib.types.str;
      default = [
        "/etc/NetworkManager/system-connections"
        "/etc/nixos"
        "/var/log"
        "/var/lib/nixos"
        "/var/lib/systemd"
      ];
      description = "System directories to persist";
    };

    systemFiles = lib.mkOption {
      type = lib.types.listOf lib.types.str;
      default = [
        "/etc/machine-id"
      ];
      description = "System files to persist";
    };
  };

  config = lib.mkIf cfg.enable {
    fileSystems."/" = {
      device = "tmpfs";
      fsType = "tmpfs";
      options = [
        "mode=0755"
        "size=${cfg.rootTmpfsSize}"
      ];
    };

    fileSystems."/nix" = {
      device = "${cfg.rpool}/nix";
      fsType = "zfs";
      neededForBoot = true;
    };

    fileSystems."/persist" = {
      device = "${cfg.rpool}/persist";
      fsType = "zfs";
      neededForBoot = true;
    };

    fileSystems."/home" = lib.mkIf cfg.includeHomeDir {
      device = "${cfg.rpool}/home";
      fsType = "zfs";
    };

    environment.persistence."/persist" = {
      hideMounts = true;
      directories = cfg.systemDirs;
      files = cfg.systemFiles;
    };
  };
}
