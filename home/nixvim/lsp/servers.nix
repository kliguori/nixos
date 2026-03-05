{ ... }:
{
  programs.nixvim = {
    plugins.lsp.servers = {
      nixd = {
        enable = true;
        settings = {
          nixd = {
            formatting = {
              command = [ "nixfmt" ];
            };
          };
        };
      };
      rust_analyzer = {
        enable = true;
        installCargo = false;
        installRustc = false;
        settings = {
          rust-analyzer = {
            checkOnSave = true;
            check.command = "clippy";
            inlayHints = {
              bindingModeHints.enable = true;
              closureReturnTypeHints.enable = "always";
              lifetimeElisionHints.enable = "always";
            };
          };
        };
      };
      ruff-lsp.enable = true;
      pyright.enable = true;
      clangd.enable = true;
      texlab.enable = true;
    };
  };
}
