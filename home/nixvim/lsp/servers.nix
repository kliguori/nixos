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
      rust-analyzer = {
        enable = true;
        installCargo = false;
        installRustc = false;
      };
      hls = {
        enable = true;
        installGhc = false;
      };
      pyright.enable = true;
      clangd.enable = true;
      texlab.enable = true;
    };
  };
}
