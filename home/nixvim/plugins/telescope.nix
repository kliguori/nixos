{ ... }:
{
  programs.nixvim = {
    plugins.telescope = {
      enable = true;
      extensions = {
        fzf-native.enable = true;
        file-browser = {
          enable = true;
          settings = {
            grouped = true;
            hijack_netrw = true;
            hidden = {
              file_browser = true;
              folder_browser = true;
            };
            respect_gitignore = false;
          };
        };
      };
      keymaps = {
        "<leader>ff" = {
          action = "find_files";
          options.desc = "Telescope: Find files";
        };
        "<leader>fg" = {
          action = "live_grep";
          options.desc = "Telescope: Live grep";
        };
        "<leader>fb" = {
          action = "buffers";
          options.desc = "Telescope: Buffers";
        };
        "<leader>fh" = {
          action = "help_tags";
          options.desc = "Telescope: Help tags";
        };
        "<leader>fo" = {
          action = "oldfiles";
          options.desc = "Telescope: Recent files";
        };
        "<leader>fr" = {
          action = "resume";
          options.desc = "Telescope: Resume last picker";
        };
        "<leader>gc" = {
          action = "git_commits";
          options.desc = "Telescope: Git commits";
        };
        "<leader>gs" = {
          action = "git_status";
          options.desc = "Telescope: Git status";
        };
        "<leader>fd" = {
          action = "diagnostics";
          options.desc = "Telescope: Diagnostics";
        };
      };
    };
  };
}
