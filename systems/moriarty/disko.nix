{
  disk = {
    usb = {
      type = "disk";
      device = "/dev/disk/by-id/usb-USB_SanDisk_3.2Gen1_03003013050625184421-0:0";
      content = {
        type = "gpt";
        partitions = {
          ESP = {
            name = "ESP";
            size = "1G";
            type = "EF00";
            content = {
              type = "filesystem";
              format = "vfat";
              mountpoint = "/boot";
              mountOptions = [ "umask=0077" ];
              extraArgs = [
                "-n"
                "USBBOOT"
              ];
            };
          };
          recovery-pool = {
            name = "recovery-pool";
            size = "100%";
            content = {
              type = "zfs";
              pool = "recovery-pool";
            };
          };
        };
      };
    };
  };
  zpool = {
    "recovery-pool" = {
      type = "zpool";
      options = {
        ashift = "12";
        autotrim = "on";
      };
      rootFsOptions = {
        mountpoint = "none";
        compression = "zstd";
        atime = "off";
        xattr = "sa";
        acltype = "posixacl";
      };
      datasets = {
        nix = {
          type = "zfs_fs";
          options = {
            mountpoint = "legacy";
            canmount = "noauto";
          };
        };
        persist = {
          type = "zfs_fs";
          options = {
            mountpoint = "legacy";
            canmount = "noauto";
          };
        };
      };
    };
  };
}
