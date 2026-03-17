{ inputs, hostName, lib, ... }:
{
  imports = [
    inputs.nixos-hardware.nixosModules.framework-13-7040-amd
    ../core 
    ../../modules 
    ../../users
  ];

  # --- State version ---
  system.stateVersion = "25.11";

  # --- Networking ---
  networking = {
    hostName = hostName;
    hostId = "90867c7d";
    useDHCP = lib.mkDefault true;
    networkmanager.enable = true;
  };

  # --- Boot settings ---
  boot = {
    kernelParams = [ ];
    loader = {
      systemd-boot.enable = true;
      efi.canTouchEfiVariables = true;
    };
    supportedFilesystems = [ "btrfs" ];
  };

  # --- Hardware ---
  hardware.enableAllFirmware = true;

  # --- System options ---
  systemOptions = {
    impermanence.enable = true;
    desktop.enable = true;    
    services = {
      ssh.enable = true;
      fstrim.enable = true;
      tailscale.enable = true;
    };
  };
}
