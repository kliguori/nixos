{ config, pkgs, ... }:

let
  c = config.theme.colors;
in
{
  programs.starship = {
    enable = true;
    settings = {
      add_newline = true;
      right_format = "$time";
      format = "$nix_shell$directory$git_branch$git_status$cmd_duration$character";

      time = {
        disabled = false;
        format = "[$time]($style)";
        style = "bold ${c.yellow}";
      };

      nix_shell = {
        format = "[($name)]($style) ";
        style = "bold ${c.green}";
        heuristic = true;
      };

      directory = {
        truncation_length = 3;
        truncation_symbol = "…/";
        style = "bold ${c.cyan}";
      };

      git_branch = {
        symbol = " ";
        style = "bold ${c.purple}";
      };

      git_status = {
        style = "bold ${c.red}";
        conflicted = "⚠ ";
        ahead = "⇡";
        behind = "⇣";
        untracked = "? ";
        stashed = " ";
        modified = "✎ ";
        staged = "+ ";
      };

      cmd_duration = {
        min_time = 500;
        format = "[$duration]($style) ";
        style = "bold ${c.yellow}";
      };

      # Prompt character
      character = {
        success_symbol = "[❯](bold ${c.green})";
        error_symbol = "[❯](bold ${c.red})";
      };
    };
  };
}
