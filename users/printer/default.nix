{
  config,
  pkgs,
  lib,
  ...
}:
let
  paperless = config.systemOptions.services.paperless;
in
{
  # Note the samba password has to be created manually...
  # sudo smbpasswd -a printer
  users.users.printer = {
    isSystemUser = true;
    extraGroups = lib.optional paperless.enable "paperless";
    description = "SMB user for printer";
    group = "printer";
    createHome = false;
    shell = "${pkgs.coreutils}/bin/false";
    hashedPassword = "!";
  };

  users.groups.printer = { };
}
