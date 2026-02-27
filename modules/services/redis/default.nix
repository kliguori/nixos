{ config, lib, pkgs, ... }:
let
  cfg = config.systemOptions.services.redis;

  instanceType = lib.types.submodule ({ name, ... }: {
    options = {
      enable = lib.mkEnableOption "Redis instance";

      socketPath = lib.mkOption {
        type = lib.types.path;
        default = "/run/redis-${name}/redis.sock";
        description = "Unix socket path for this Redis instance.";
      };

      settings = lib.mkOption {
        type = lib.types.attrsOf lib.types.str;
        default = { };
        description = "Extra Redis settings (redis.conf entries).";
      };
    };
  });

  instances = cfg.instances;

  mkRedisServer = name: inst: {
    enable = true;
    port = 0;
    unixSocket = inst.socketPath;
    unixSocketPerm = 0755;

    settings =
      {
        "protected-mode" = "yes";
        "timeout" = "0";
        "tcp-keepalive" = "300";
      }
      // inst.settings;
  };

  unitName = name: if name == "" then "redis" else "redis-${name}";

  mkHardening = name: inst:
    lib.mkIf inst.harden {
      systemd.services.${unitName name}.serviceConfig = {
        NoNewPrivileges = true;
        PrivateTmp = true;
        PrivateDevices = true;

        ProtectSystem = "strict";
        ProtectHome = true;

        ProtectKernelTunables = true;
        ProtectKernelModules = true;
        ProtectControlGroups = true;

        LockPersonality = true;
        MemoryDenyWriteExecute = true;
        RestrictSUIDSGID = true;
        RestrictRealtime = true;

        # Socket-only instances can be AF_UNIX only.
        # If you enable TCP, we widen this below.
        RestrictAddressFamilies =
          if inst.port == 0 then [ "AF_UNIX" ] else [ "AF_UNIX" "AF_INET" "AF_INET6" ];
      };
    };

  mkGroups = name: inst: {
    users.groups.${inst.group} = { };
  };

  mkTmpfiles = name: inst: {
    systemd.tmpfiles.rules = [
      "d ${toString (builtins.dirOf inst.socketPath)} 0750 ${inst.user} ${inst.group} - -"
    ];
  };

  # “No accidental exposure” checks
  mkAssertions =
    lib.flatten (lib.mapAttrsToList (name: inst: [
      {
        assertion = (inst.port == 0) || inst.allowTCP;
        message = "Redis instance '${name}': port != 0 but allowTCP = false. Refusing to expose Redis over TCP by accident.";
      }
      {
        assertion = (inst.port == 0) || (inst.requirePassFile != null);
        message = "Redis instance '${name}': TCP enabled (port != 0) but requirePassFile is null. Add a password file.";
      }
    ]) instances);
in
{
  options.systemOptions.services.redis = {
    enable = lib.mkEnableOption "Shared Redis service manager";

    instances = lib.mkOption {
      type = lib.types.attrsOf instanceType;
      default = { };
      description = "Named Redis instances.";
    };
  };

  config = lib.mkIf cfg.enable (
    {
      assertions = mkAssertions;

      # Create per-instance groups + runtime dirs, and then define services.redis.servers.*
      # as the underlying implementation.
      users = lib.mkMerge (lib.mapAttrsToList mkGroups instances);
      systemd = lib.mkMerge (lib.mapAttrsToList mkTmpfiles instances);

      services.redis.servers =
        lib.mkMerge (lib.mapAttrsToList mkRedisServer instances);
    }
    // (lib.mkMerge (lib.mapAttrsToList mkHardening instances))
  );
}
