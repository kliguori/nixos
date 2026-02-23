{ pkgs, ... }:
{
  programs.nixvim.plugins.treesitter = {
    enable = true;
    settings = {
      highlight.enable = true;
      indent.enable = true;
    };
    grammarPackages = with pkgs.vimPlugins.nvim-treesitter.builtGrammars; [
      nix
      python
      rust
      julia
      c
      lua
      bash
      json
      yaml
      markdown
      markdown_inline
      toml
      kdl
    ];
  };
}
