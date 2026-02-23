{ ... }:
{
  programs.nixvim.plugins = {
    lualine.enable = true;

    bufferline = {
      enable = true;
      settings = {
        options = {
          diagnostics = "nvim_lsp";
          show_buffer_close_icons = false;
          always_show_bufferline = true;
        };
      };
    };

    web-devicons.enable = true;
  };
}
