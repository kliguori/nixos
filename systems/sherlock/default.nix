{
  pkgs,
  modulesPath,
  inputs,
  ...
}:

{
  # --- Imports ---
  imports = [
    (modulesPath + "/installer/scan/not-detected.nix")
    inputs.nixos-hardware.nixosModules.common-cpu-amd
    inputs.nixos-hardware.nixosModules.common-pc
    ./boot.nix
    ./filesystems.nix
    ./networking.nix
    ./common.nix
    ./nvidia.nix
    ./persistence.nix
    ../../users
    ../../modules
  ];

  # --- State version ---
  system.stateVersion = "25.11";

  # --- Services ---
  services = {
    blueman.enable = false; # Disable Blueman service
    pulseaudio.enable = false; # Disable pulseaudio
    zfs.autoScrub.enable = true; # Enable automatic scrubbing of ZFS pools
    tailscale.enable = true; # Enable  tailscale

    # Enable pipewire
    pipewire = {
      enable = true;
      alsa.enable = true;
      alsa.support32Bit = true;
      pulse.enable = true;
      jack.enable = true;
    };

    # Enable SSH
    openssh = {
      enable = true;
      settings = {
        PermitRootLogin = "no";
        PasswordAuthentication = false;
      };
    };
  };

  # --- System options ---
  systemOptions = {
    users = [
      "root"
      "kevin"
    ];
    impermanence.enable = false;
    desktop.enable = true;    
    # services = {
    #   ssh.enable = true;
    #   fstrim.enable = true;
    #   tailscale.enable = true;
    # };
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
