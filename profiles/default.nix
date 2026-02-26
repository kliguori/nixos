{
  inputs,
  lib,
  pkgs,
  ...
}:
{
  imports = [
    ./laptop.nix
    ./desktop.nix
    ./server.nix
  ];

  options.systemOptions.profiles = lib.mkOption {
    type = lib.types.listOf (
      lib.types.enum [
        "laptop"
        "desktop"
        "server"
      ]
    );
    default = [ ];
    description = "Profiles applied to the system.";
  };

  config = {
    # --- System options
    systemOptions = {
      desktop.enable = lib.mkDefault true;
      services = {
        ssh.enable = lib.mkDefault true;
        fstrim.enable = lib.mkDefault true;
        tailscale.enable = lib.mkDefault true;
        powerManagement.enable = lib.mkDefault true;
      };
    };

    # --- Nixpkgs settings ---
    nixpkgs.config.allowUnfree = true;

    # --- Nix settings ---
    nix = {
      settings = {
        experimental-features = [
          "nix-command"
          "flakes"
        ];
        auto-optimise-store = true;
        trusted-users = [ "@wheel" ];
      };
      gc = {
        automatic = true;
        dates = "weekly";
        options = "--delete-older-than 7d";
      };
    };

    # --- Immuatable users ---
    users.mutableUsers = lib.mkForce false;

    # --- Networking ---
    networking = {
      useDHCP = lib.mkDefault true;
      networkmanager.enable = true;
    };

    # --- Boot settings ---
    boot = {
      kernelParams = [
        "zfs.zfs_arc_max=4294967296" # Limit ZFS ARC to 4GB
      ];
      loader = {
        systemd-boot.enable = true;
        efi.canTouchEfiVariables = true;
      };
      supportedFilesystems = [ "zfs" ];
      initrd.supportedFilesystems = [ "zfs" ];
      zfs.devNodes = "/dev/disk/by-id";
    };

    # --- Hardware ---
    hardware.enableAllFirmware = true;

    # --- Disable X ---
    services.xserver.enable = false;

    # --- Localization ---
    time.timeZone = lib.mkDefault "America/New_York";
    i18n.defaultLocale = lib.mkDefault "en_US.UTF-8";

    # --- Packages ---
    environment.systemPackages =
      with pkgs;
      [
        tree
        pciutils
        unzip
        neovim
        curl
        wget
        eza
        jq
        dnsutils
        iproute2
        iputils
        nmap
        traceroute
        htop
        strace
        lsof
        ripgrep
        fd
        bat
        duf
        ncdu
        rsync
        parted
        git
        usbutils
        lm_sensors
        fwupd
        age
      ]
      ++ [
        inputs.disko.packages.${pkgs.system}.disko
      ];
  };
}
