{
  hostName,
  inputs,
  pkgs,
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

  # --- Boot ---
  boot = {
    kernelParams = [
      "zfs.zfs_arc_max=4294967296" # Limit ZFS ARC to 4GB
    ];
    kernelModules = [ "sg" ];
    supportedFilesystems = [ "zfs" ];
    initrd.supportedFilesystems = [ "zfs" ];
    zfs.devNodes = "/dev/disk/by-id";
    # zfs.extraPools = [
    #   "rpool"
    #   "dpool"
    #   "spool"
    # ];
  };

  # --- FileSystems ---
  fileSystems = {
    "/" = {
      device = "tmpfs";
      fsType = "tmpfs";
      options = [
        "mode=0755"
        "size=8G"
      ];
    };

    "/nix" = {
      device = "rpool/nix";
      fsType = "zfs";
      neededForBoot = true;
    };

    "/persist" = {
      device = "rpool/persist";
      fsType = "zfs";
      neededForBoot = true;
    };

    "/home" = {
      device = "rpool/home";
      fsType = "zfs";
    };

    "/data" = {
      device = "dpool/data";
      fsType = "zfs";
      options = [
        "nofail"
        "noauto"
        "x-systemd.automount"
        "x-systemd.idle-timeout=60"
        "x-systemd.device-timeout=15s"
        "x-systemd.mount-timeout=15s"
      ];
    };

    "/data/scratch" = {
      device = "spool/scratch";
      fsType = "zfs";
      options = [
        "nofail"
        "noauto"
        "x-systemd.automount"
        "x-systemd.idle-timeout=60"
        "x-systemd.device-timeout=15s"
        "x-systemd.mount-timeout=15s"
      ];
    };
  };

  # --- Persistence ---
  environment.persistence."/persist" = {
    hideMounts = true;
    directories = [
      # System state
      "/var/log"
      "/var/lib/nixos"
      "/var/lib/systemd/coredump"
      "/var/lib/sops-nix"

      # Network
      "/etc/NetworkManager/system-connections"

      # Common services
      "/var/lib/tailscale"
    ];

    files = [
      "/etc/machine-id"
      "/etc/ssh/ssh_host_ed25519_key"
      "/etc/ssh/ssh_host_ed25519_key.pub"
      "/etc/ssh/ssh_host_rsa_key"
      "/etc/ssh/ssh_host_rsa_key.pub"
    ];
  };

  # Required for impermanence
  programs.fuse.userAllowOther = true;

  # --- Services ---
  services = {
    blueman.enable = false; # Disable Blueman service
    pulseaudio.enable = false; # Disable pulseaudio
    zfs.autoScrub.enable = true; # Enable automatic scrubbing of ZFS pools

    # Enable pipewire
    pipewire = {
      enable = true;
      alsa.enable = true;
      alsa.support32Bit = true;
      pulse.enable = true;
      jack.enable = true;
    };
  };

  # --- System options ---
  systemOptions = {
    users = [
      "root"
      "kevin"
    ];
    impermanence.enable = false;
    nvidia = {
      enable = true;
      prime.enable = false;
    };
  };

  # --- Packages ---
  environment.systemPackages = with pkgs; [
    libvirt
    virt-manager
    virt-viewer
    qemu

    # Transcoding
    makemkv
    handbrake
  ];
}
