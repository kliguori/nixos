{
  hostName,
  inputs,
  lib,
  ...
}:
let
  mkNoMountOptions =
    {
      automount, # ture -> automounts dataset when accessed. false -> must mount manually
      idleTimeout ? 60,
      deviceTimeout ? "15s",
      mountTimeout ? "15s",
    }:
    [
      "nofail"
      "noauto"
      "x-systemd.device-timeout=${deviceTimeout}"
      "x-systemd.mount-timeout=${mountTimeout}"
    ]
    ++ lib.optionals automount [
      "x-systemd.automount"
      "x-systemd.idle-timeout=${toString idleTimeout}"
    ];
in
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
    kernelParams = [
      "zfs.zfs_arc_max=4294967296" # Limit ZFS ARC to 4GB
    ];
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
  fileSystems."/home" = {
    device = "rpool/home";
    fsType = "zfs";
  };

  fileSystems."/data" = {
    device = "dpool/data";
    fsType = "zfs";
    options = mkNoMountOptions { automount = true; };
  };

  filesystems."/data/scratch" = {
    device = "spool/scratch";
    fsType = "zfs";
    options = mkNoMountOptions { automount = true; };
  };
}
