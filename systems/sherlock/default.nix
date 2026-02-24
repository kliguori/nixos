{
  hostName,
  inputs,
  ...
}:
{
  # --- Imports ---
  imports = [
    inputs.nixos-hardware.nixosModules.common-cpu-amd
    inputs.nixos-hardware.nixosModules.common-pc
    ../../users
    ../../profiles
    ../../modules
  ];

  # --- State version ---
  system.stateVersion = "25.11";

  # --- Networking ---
  networking = {
    hostName = hostName;
    hostId = "d302d58e";
  };

  # --- Extra boot settings ---
  boot = {
    kernelModules = [ "sg" ];
  };

  # --- System options ---
  systemOptions = {
    profiles = [ "desktop" ];
    users = [
      "root"
      "kevin"
    ];
    nvidia = {
      enable = true;
      prime.enable = false;
    };
  };

  # --- Extra fileSystems ---
  fileSystems = {
    "/data" = {
      device = "dpool/data";
      fsType = "zfs";
    };

    "/data/scratch" = {
      device = "spool/scratch";
      fsType = "zfs";
    };
  };
}
