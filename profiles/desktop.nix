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

    virtualisation.docker = {
      enable = true;
      daemon.settings = {
        data-root = "/home/kevin/.docker-data";
      };
    };

    # --- Extra Packages ---
    environment.systemPackages = with pkgs; [
      libvirt
      virt-manager
      virt-viewer
      qemu
      makemkv
      (handbrake.overrideAttrs (old: {
        postFixup = (old.postFixup or "") + ''
          wrapProgram $out/bin/ghb \
            --prefix LD_LIBRARY_PATH : /run/opengl-driver/lib
        '';
      }))
      samba
    ];
  };
}
