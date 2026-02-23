{
  lib,
  pkgs,
  ...
}:
{
  # Import all program programs (NixOS/Linux only)
  imports = [
    ./programs/git
    ./programs/zsh
    ./programs/starship
    ./programs/kitty
    ./programs/nixvim
    ./programs/dms
    ./programs/niri
    ./programs/firefox
  ];

  # Theme options used by multiple programs
  options.theme = {
    name = lib.mkOption {
      type = lib.types.str;
      default = "dracula";
      description = "Theme name";
    };

    colors = lib.mkOption {
      type = lib.types.attrs;
      description = "Color palette";
    };

    fonts = {
      mono = lib.mkOption {
        type = lib.types.str;
        default = "JetBrainsMono Nerd Font";
        description = "Monospace font";
      };

      ui = lib.mkOption {
        type = lib.types.str;
        default = "JetBrainsMono Nerd Font";
        description = "UI font";
      };

      size = lib.mkOption {
        type = lib.types.int;
        default = 12;
        description = "Base font size in px";
      };
    };
  };

  config = {
    # Dracula theme
    theme = {
      name = "kanagawa-wave";
      colors = {
        background = "#1F1F28";
        foreground = "#DCD7BA";
        selection = "#2D4F67";
        comment = "#727169";
        cyan = "#7AA89F";
        green = "#98BB6C";
        orange = "#FFA066";
        pink = "#D27E99";
        purple = "#957FB8";
        red = "#E82424";
        yellow = "#E6C384";
        currentLine = "#2A2A37";
        blue = "#7E9CD8";

        # RGB versions (without #) for Hyprland
        bgRgb = "1F1F28";
        fgRgb = "DCD7BA";
        selectionRgb = "2D4F67";
        commentRgb = "727169";
        cyanRgb = "7AA89F";
        greenRgb = "98BB6C";
        orangeRgb = "FFA066";
        pinkRgb = "D27E99";
        purpleRgb = "957FB8";
        redRgb = "E82424";
        yellowRgb = "E6C384";
        blueRgb = "7E9CD8";
      };
    };

    programs.home-manager.enable = true;

    home = {
      homeDirectory = "/home/kevin";
      stateVersion = "25.11";

      packages = with pkgs; [
        signal-desktop
        spotify
        claude-code

        # Fonts
        nerd-fonts.jetbrains-mono

        # Language servers and formatters
        nixd
        nixfmt
        pyright
        black
        ruff
        julia-bin
        clang-tools
        texlab

        # Clipboard
        wl-clipboard
        xclip
      ];
    };
  };
}
