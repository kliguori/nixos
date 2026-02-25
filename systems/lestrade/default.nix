{ inputs, hostName, ... }:
{
  # --- Imports ---
  imports = [
    inputs.nixos-hardware.nixosModules.common-cpu-amd
    inputs.nixos-hardware.nixosModules.common-pc-laptop
    ../../modules
    ../../users
    ../../profiles
  ];

  # --- State version ---
  system.stateVersion = "25.11";

  # --- Networking ---
  networking = {
    hostName = hostName;
    hostId = "5dcafb0a";
  };

  # --- System options ---
  systemOptions = {
    users = [
      "root"
      "kevin"
    ];
    impermanence.rpool = "rpool/crypt";
    profiles = [ "laptop" ];
    hibernate = {
      enable = true;
      resumeDevice = "/dev/mapper/cryptswap";
    };
  };
}
