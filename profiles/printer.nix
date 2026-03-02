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
    services.printing = {
      enable = true; # CUPS
      drivers = [ pkgs.hplip ];
    };
    services.avahi.enable = true; # mDNS discovery
    services.avahi.nssmdns4 = true;

    hardware.sane = {
      enable = true; # scanner support
      extraBackends = [ pkgs.hplip ];
    };

    users.users.kevin.extraGroups = [
      "lp"
      "scanner"
    ];

    # --- Extra Packages ---
    environment.systemPackages = with pkgs; [
      samba
    ];
  };
}
