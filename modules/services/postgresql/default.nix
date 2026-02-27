{
  config,
  lib,
  ...
}:
let
  cfg = config.systemOptions.services.postgresql;
  mkReqType = lib.types.submodule (
    { ... }:
    {
      options = {
        name = lib.mkOption {
          type = lib.types.str;
          description = "Database name";
        };
        user = lib.mkOption {
          type = lib.types.str;
          description = "Role/user name";
        };
      };
    }
  );
in
{
  options.systemOptions.services.postgresql = {
    enable = lib.mkEnableOption "Shared postgreSQL server.";

    requests = lib.mkOption {
      type = lib.types.listOf mkReqType;
      default = [ ];
      description = "Databases/roles requested by services.";
    };

    dataDir = lib.mkOption {
      type = lib.types.str;
      default = "/var/lib/postgresql";
      description = "PostgreSQL data directory";
    };
  };

  config = lib.mkIf cfg.enable {
    services.postgresql = {
      enable = true;
      enableTCPIP = false;
      dataDir = cfg.dataDir;
      ensureDatabases = lib.unique (map (r: r.name) cfg.requests);
      ensureUsers =
        let
          uniqueUsers = lib.unique (map (r: r.user) cfg.requests);
        in
        map (u: {
          name = u;
          ensureDBOwnership = true;
        }) uniqueUsers;

      authentication = lib.mkOverride 10 ''
        local all all peer
      '';

      settings = {
        shared_buffers = "256MB";
        work_mem = "16MB";
        maintenance_work_mem = "128MB";
        max_connections = 100;
      };
    };
  };
}
