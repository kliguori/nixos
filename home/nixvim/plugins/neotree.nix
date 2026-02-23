{ ... }:
{
  programs.nixvim.plugins.neo-tree = {
    enable = true;
    settings = {
      close_if_last_window = true;
      window = {
        position = "left";
        width = 34;
      };

      filesystem = {
        filtered_items = {
          visible = true; 
          hide_dotfiles = false;
          hide_gitignored = false;
        };

        follow_current_file = {
          enabled = true;
          leave_dirs_open = true;
        };

        hijack_netrw_behavior = "open_current"; 
        use_libuv_file_watcher = true;
      };

      enable_git_status = true;
      enable_diagnostics = true;
    };
  };
}
