{ ... }:
{
  programs.nixvim = {
    globals.mapleader = " ";

    opts = {
      number = true;
      relativenumber = true;
      expandtab = true;
      shiftwidth = 2;
      tabstop = 2;
      updatetime = 200;
      signcolumn = "yes";
      completeopt = "menuone,noselect";
      termguicolors = true;
      clipboard = "unnamedplus";
    };
  };
}
