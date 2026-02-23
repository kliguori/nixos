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
      pyright.enable = true;
      clangd.enable = true;
      texlab.enable = true;
    };
  };
}
