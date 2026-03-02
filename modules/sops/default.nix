{
  config,
  lib,
  pkgs,
  ...
}:
let
  cfg = config.systemOptions.sops;
in
{
  options.systemOptions.sops = {
    enable = lib.mkEnableOption "sops-nix secrets management";
    ageKeyFile = lib.mkOption {
      type = lib.types.nullOr lib.types.path;
      default = null;
      description = ''
        Path to the age private key file on the deployed system.
        Set this only for hosts that cannot derive an age key from an SSH host key
        For x86 hosts with impermanence, leave null — the SSH host key is used.
      '';
    };

    secretsFile = lib.mkOption {
      type = lib.types.path;
      description = "Path to the encrypted secrets.yaml for this host.";
    };
  };

  config = lib.mkIf cfg.enable {
    sops = {
      defaultSopsFile = cfg.secretsFile;
      age = {
        sshKeyPaths = lib.mkIf (cfg.ageKeyFile == null) [ "/etc/ssh/ssh_host_ed25519_key" ];
        keyFile = lib.mkIf (cfg.ageKeyFile != null) cfg.ageKeyFile;
      };
    };

    environment.systemPackages = with pkgs; [
      age
      ssh-to-age
      sops
    ];
  };
}
