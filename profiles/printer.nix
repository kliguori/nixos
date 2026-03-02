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
