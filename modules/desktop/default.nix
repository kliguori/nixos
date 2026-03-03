{
  config,
  lib,
  pkgs,
  ...
}:
let
  cfg = config.systemOptions.desktop;
in
{
  options.systemOptions.desktop.enable = lib.mkEnableOption "Graphical desktop environment";
  config = lib.mkIf cfg.enable {
    systemOptions.programs.firefox.enable = true;
    programs = {
      chromium.enable = true;
      niri.enable = true;
      thunar.enable = true;
      dank-material-shell.greeter = {
        enable = true;
        compositor.name = "niri";
      };
    };

    environment = {
      systemPackages = with pkgs; [
        chromium
        android-tools
        bitwarden-desktop
        kitty
        alacritty
      ];
      sessionVariables.NIXOS_OZONE_WL = "1";
    };
  };
}
