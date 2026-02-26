{ config, lib, pkgs, ... }:
let
  cfg = config.systemOptions.services.postgresql;
  mkReqType = lib.types.submodule ({ ... }: {
    options = {
      name = lib.mkOption { type = lib.types.str; description = "Database name"; };
      user = lib.mkOption { type = lib.types.str; description = "Role/user name"; };
      passFile = lib.mkOption { type = lib.types.path; description = "Password file for the role"; };
    };
  });
in
{
  options.systemOptions.services.postgresql = {
    enable = lib.mkEnableOption "Shared postgreSQL server.";

    requests = lib.mkOption {
      type = lib.types.listOf mkReqType;
      default = [];
      description = "Databases/roles requested by services.";
    };
  };

  config = lib.mkIf cfg.enable {
    services.postgresql = {
      enable = true;
      package = cfg.package;
      enableTCPIP = false;
      ensureDatabases = lib.unique (map (r: r.name) cfg.requests);
      ensureUsers =
        let
          mkUser = r: {
            name = r.user;
            ensureDBOwnership = true;
          };
        in
        lib.unique (map mkUser cfg.requests);

      settings = {
        shared_buffers = "256MB";
        work_mem = "16MB";
        maintenance_work_mem = "128MB";
        max_connections = 100;
      };
    };

    # Set passwords from passFile for each requested role.
    # This avoids manual psql steps.
    systemd.services.postgresql-postStart = {
      after = [ "postgresql.service" ];
      requires = [ "postgresql.service" ];
      serviceConfig.Type = "oneshot";
      script =
        let
          mkCmd = r: ''
            pw="$(cat ${toString r.passFile})"
            ${pkgs.sudo}/bin/sudo -u postgres ${config.services.postgresql.package}/bin/psql \
              -tAc "ALTER ROLE \"${r.user}\" WITH PASSWORD '$pw';"
          '';
        in
        lib.concatStringsSep "\n" (map mkCmd cfg.requests);
      wantedBy = [ "multi-user.target" ];
    };
  };
}
