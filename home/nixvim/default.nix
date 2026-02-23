{ ... }:
{
  imports = [
    ./options.nix
    ./keymaps.nix
    ./plugins
    ./lsp
  ];

  programs.nixvim = {
    enable = true;
    viAlias = true;
    vimAlias = true;
    defaultEditor = true;

    colorschemes.kanagawa = {
      enable = true;
      settings = {
        transparent = false;
        commentStyle = {
          italic = true;
        };
        keywordStyle = {
          italic = true;
        };
        theme = "wave";
      };
    };

    extraConfigLua = ''
    '';
  };
}
