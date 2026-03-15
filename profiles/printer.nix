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
  config = lib.mkIf (lib.elem "printer" cfg.profiles) {
    # --- Services ---
    services = {
      printing = {
        enable = true; # CUPS
        drivers = [ pkgs.hplip ];
      };

      ipp-usb.enable = true;

      avahi = {
        enable = true;
        nssmdns4 = false;
        openFirewall = false;
        # publish = {
        #   enable = false;
        #   userServices = false;
        # };
      };
    };

    hardware.sane = {
      enable = true; # scanner support
      extraBackends = [ pkgs.hplip ];
    };

    # --- Extra Packages ---
    environment.systemPackages = with pkgs; [
      hplip
      sane-frontends
      samba
    ];
  };
}
