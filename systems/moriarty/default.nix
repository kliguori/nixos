{ inputs, hostName, ... }:
{
  # --- Imports ---
  imports = [
    ../../modules
    ../../users
    ../../profiles
  ];

  # --- State version ---
  system.stateVersion = "25.11";

  # --- Networking ---
  networking = {
    hostName = hostName;
    hostId = "da7b70e2";
  };

  # --- System options ---
  systemOptions = {
    profiles = [ "recovery" ];
  };
}
