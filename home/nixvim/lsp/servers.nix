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
