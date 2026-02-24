{
  disk = {
    system = {
      type = "disk";
      device = "/dev/disk/by-id/nvme-SAMSUNG_MZVLB512HBJQ-000L7_S4ENNX1R291121";
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
                "NIXBOOT"
              ];
            };
          };

          rpool = {
            name = "rpool";
            size = "100%";
            content = {
              type = "zfs";
              pool = "rpool";
            };
          };
        };
      };
    };

    data = {
      type = "disk";
      device = "/dev/disk/by-id/nvme-Micron_2300_NVMe_512GB__202829753D71";
      content = {
        type = "gpt";
        partitions = {
          dpool = {
            name = "dpool";
            size = "100%";
            content = {
              type = "zfs";
              pool = "dpool";
            };
          };
        };
      };
    };

    scratch = {
      type = "disk";
      device = "/dev/disk/by-id/ata-WDC_WD10EZEX-22MFCA0_WD-WCC6Y2YL5RAD";
      content = {
        type = "gpt";
        partitions = {
          spool = {
            name = "spool";
            size = "100%";
            content = {
              type = "zfs";
              pool = "spool";
            };
          };
        };
      };
    };
  };

  zpool = {
    rpool = {
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
            canmount = "noauto";
            mountpoint = "legacy";
          };
        };

        persist = {
          type = "zfs_fs";
          options = {
            canmount = "noauto";
            mountpoint = "legacy";
          };
        };

        home = {
          type = "zfs_fs";
          options = {
            canmount = "noauto";
            mountpoint = "legacy";
          };
        };
      };
    };

    dpool = {
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
        data = {
          type = "zfs_fs";
          options = {
            canmount = "noauto";
            mountpoint = "legacy";
          };
        };
      };
    };

    spool = {
      type = "zpool";
      options = {
        ashift = "12";
        autotrim = "off";
      };
      
      rootFsOptions = {
        mountpoint = "none";
        compression = "zstd";
        atime = "off";
        xattr = "sa";
        acltype = "posixacl";
      };

      datasets = {
        scratch = {
          type = "zfs_fs";
          options = {
            canmount = "noauto";
            mountpoint = "legacy";
          };
        };
      };
    };
  };
}
