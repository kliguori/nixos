{
  config,
  lib,
  pkgs,
  ...
}:
let
  cfg = config.systemOptions;
in
{
  config = lib.mkIf (lib.elem "desktop" cfg.profiles) {
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

    # --- Extra Packages ---
    environment.systemPackages = with pkgs; [
      libvirt
      virt-manager
      virt-viewer
      qemu

      # Transcoding
      makemkv
      handbrake
    ];
  };
}
