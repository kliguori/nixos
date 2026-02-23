{
  config,
  lib,
  pkgs,
  ...
}:
let
  c = config.theme.colors;
  f = config.theme.fonts;
in
{
  programs.kitty = {
    enable = true;

    font = {
      name = f.mono;
      size = f.size;
    };

    settings = {
      # Opacity
      background_opacity = "0.95";
      dynamic_background_opacity = "yes";

      # Dracula theme colors
      foreground = c.foreground;
      background = c.background;
      selection_foreground = c.foreground;
      selection_background = c.selection;

      # Cursor
      cursor = c.foreground;
      cursor_text_color = c.background;

      # URL
      url_color = c.cyan;

      # Black
      color0 = "#21222c";
      color8 = c.selection;

      # Red
      color1 = c.red;
      color9 = c.red;

      # Green
      color2 = c.green;
      color10 = c.green;

      # Yellow
      color3 = c.yellow;
      color11 = c.yellow;

      # Blue
      color4 = c.purple;
      color12 = c.purple;

      # Magenta
      color5 = c.pink;
      color13 = c.pink;

      # Cyan
      color6 = c.cyan;
      color14 = c.cyan;

      # White
      color7 = "#f8f8f2";
      color15 = "#ffffff";

      # Tab bar colors
      active_tab_foreground = c.background;
      active_tab_background = c.purple;
      inactive_tab_foreground = c.foreground;
      inactive_tab_background = c.selection;
    };
  };
}
