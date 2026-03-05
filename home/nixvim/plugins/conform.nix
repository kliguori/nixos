{ ... }:
{
  programs.nixvim.plugins.conform-nvim = {
    enable = true;
    settings = {
      format_on_save = {
        timeout_ms = 500;
        lsp_fallback = true;
      };
      formatters_by_ft = {
        python = [ "ruff_format" ];
        nix = [ "nixfmt" ];
      };
    };
  };
}
