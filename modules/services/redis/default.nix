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

      socketPerm = lib.mkOption {
        type = lib.types.str;
        default = "0770";
        description = "Permissions for the unix socket (octal string).";
      };

      user = lib.mkOption {
        type = lib.types.str;
        default = "redis";
        description = "Unix user to run Redis as.";
      };

      group = lib.mkOption {
        type = lib.types.str;
        default = "redis-${name}";
        description = "Unix group owning the socket; grant clients access by joining this group.";
      };

      # Default: socket-only, no TCP.
      port = lib.mkOption {
        type = lib.types.ints.between 0 65535;
        default = 0;
        description = "TCP port. 0 disables TCP and uses unix socket only.";
      };

      bind = lib.mkOption {
        type = lib.types.listOf lib.types.str;
        default = [ "127.0.0.1" "::1" ];
        description = "Bind addresses (only relevant if port != 0).";
      };

      requirePassFile = lib.mkOption {
        type = lib.types.nullOr lib.types.path;
        default = null;
        description = "Optional password file (recommended if TCP is enabled).";
      };

      # Extra redis.conf settings (key/value), e.g. maxmemory-policy, etc.
      settings = lib.mkOption {
        type = lib.types.attrsOf lib.types.str;
        default = { };
        description = "Extra Redis settings (redis.conf entries).";
      };

      harden = lib.mkOption {
        type = lib.types.bool;
        default = true;
        description = "Apply systemd hardening to the redis service unit.";
      };

      allowTCP = lib.mkOption {
        type = lib.types.bool;
        default = false;
        description = "Allow listening on TCP (you must explicitly opt in).";
      };
    };
  });

  instances = cfg.instances;

  mkRedisServer = name: inst: {
    enable = true;
    user = inst.user;
    group = inst.group;

    # Socket-only by default
    port = inst.port;
    bind = inst.bind;

    unixSocket = toString inst.socketPath;
    unixSocketPerm = inst.socketPerm;

    # Keep the safer default on; Redis “protected mode” is a key safety net
    # if someone ever accidentally enables TCP without auth.
    settings =
      {
        "protected-mode" = "yes";
        # Good hygiene; your apps can still set their own policies.
        "timeout" = "0";
        "tcp-keepalive" = "300";
      }
      // inst.settings;

    # Optional auth (mainly useful if TCP is on)
    requirePassFile = inst.requirePassFile;
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
