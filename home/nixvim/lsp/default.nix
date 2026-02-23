{ ... }:
{
  imports = [
    ./servers.nix
  ];

  programs.nixvim.plugins.lsp = {
    enable = true;
    keymaps = {
      lspBuf = {
        "K" = "hover";
        "gd" = "definition";
        "gr" = "references";
        "<leader>rn" = "rename";
        "<leader>ca" = "code_action";
        "<leader>f" = "format";
      };
    };
  };
}
