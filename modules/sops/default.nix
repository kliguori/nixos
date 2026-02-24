{ config, lib, ... }:
let
  cfg = config.systemOptions.sops-nix;
  persist = config.systemOptions.impermanence.enable;
  baseDir = "/var/lib/sops-nix";

  keyFile = if persist then "/persist${baseDir}/key.txt" else "${baseDir}/key.txt";
in
{
  options.systemOptions.sops-nix.enable = lib.mkEnableOption "Enable SOPS-nix";
  config = lib.mkIf cfg.enable {
    sops = {
      age = {
        inherit keyFile;
        generateKey = true;
        sshKeyPaths = lib.mkForce [ ];
      };
      gnupg.sshKeyPaths = lib.mkForce [ ];
    };

    environment.persistence."/persist".directories = lib.mkIf persist [ baseDir ];
  };
}
