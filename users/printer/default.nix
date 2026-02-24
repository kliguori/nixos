{ pkgs, ... }:
{
  # Note the samba password has to be created manually... 
  # sudo smbpasswd -a printer
  users.users.printer = {
    isSystemUser = true;
    description = "SMB user for printer";
    group = "printer";
    createHome = false;
    shell = "${pkgs.coreutils}/bin/false";
    hashedPassword = "!";
  };

  users.groups.printer = { };
}
