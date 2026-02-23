{ pkgs, ... }:
{
  programs.git = {
    enable = true;
    settings = {
      user.name = "kevin";
      user.email = "liguori.km@gmail.com";
      init.defaultBranch = "main";
      color.ui = true;
      pull.rebase = "true";
    };
  };
}
