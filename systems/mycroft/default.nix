{
  hostName,
  inputs,
  pkgs,
  ...
}:
{
  # --- Imports ---
  imports = [
    inputs.nixos-hardware.nixosModules.common-cpu-intel
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
    hostId = "b709b6b5";
  };

  # --- Sudo w/o password ---
  security.sudo.wheelNeedsPassword = false;

  # --- Force Wayland to use Intel GPU ---
  environment.sessionVariables = {
    WLR_DRM_DEVICES = "/dev/dri/card1"; # card1 is intel card0 nvidia
  };

  # --- Set profile to "cool" ---
  systemd.services.set-platform-profile = {
    description = "Set Dell platform profile to cool";
    wantedBy = [ "multi-user.target" ];
    after = [ "multi-user.target" ];
    serviceConfig = {
      Type = "oneshot";
      ExecStart = ''
        ${pkgs.bash}/bin/bash -c "echo cool > /sys/firmware/acpi/platform_profile"
      '';
    };
  };

  # --- System options ---
  systemOptions = {
    impermanence.includeHomeDir = false;
    users = [
      "root"
      "admin"
      "kevin"
    ];
    profiles = [
      "laptop"
      # "server"
    ];
    nvidia = {
      enable = true;
      prime = {
        enable = true;
        intelBusId = "PCI:0:2:0";
        nvidiaBusId = "PCI:1:0:0";
      };
    };
  };

  # --- Extra zpools to import early ---
  # boot.zfs = {
  #   requestEncryptionCredentials = true;
  #   extraPools = [ "dpool" ];
  # };

  # --- Extra fileSystems ---
  fileSystems = {
    "/media/movies" = {
      device = "dpool/crypt/media/movies";
      fsType = "zfs";
    };

    "/media/tv" = {
      device = "dpool/crypt/media/tv";
      fsType = "zfs";
    };

    "/data/vaultwarden" = {
      device = "dpool/crypt/data/vaultwarden";
      fsType = "zfs";
    };

    "/data/paperless" = {
      device = "dpool/crypt/data/paperless";
      fsType = "zfs";
    };

    "/incus" = {
      device = "dpool/crypt/incus";
      fsType = "zfs";
    };
  };
}
