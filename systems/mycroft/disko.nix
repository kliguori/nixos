{
  disk = {
    system = {
      type = "disk";
      device = "/dev/disk/by-id/nvme-Samsung_SSD_970_EVO_500GB_S5H7NG0N214175Z";
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
              extraArgs = [ "-n" "NIXBOOT" ];
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
      device = "/dev/disk/by-id/nvme-Samsung_SSD_990_EVO_Plus_4TB_S7U8NJ0Y622750V";
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
          mountpoint = "/nix";
          options = {
            canmount = "noauto";
            mountpoint = "legacy";
          };
        };

        persist = {
          type = "zfs_fs";
          mountpoint = "/persist";
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
        crypt = {
          type = "zfs_fs";
          options = {
            mountpoint = "none";
            canmount = "off";
            encryption = "aes-256-gcm";
            keyformat = "passphrase";
            keylocation = "prompt";
          };
        };

        "crypt/media/movies" = {
          type = "zfs_fs";
          mountpoint = "/media/movies";
          options = {
            canmount = "noauto";
            mountpoint = "legacy";
          };
        };

        "crypt/media/tv" = {
          type = "zfs_fs";
          mountpoint = "/media/tv";
          options = {
            canmount = "noauto";
            mountpoint = "legacy";
          };
        };

        "crypt/data/vaultwarden" = {
          type = "zfs_fs";
          mountpoint = "/data/vaultwarden";
          options = {
            canmount = "noauto";
            mountpoint = "legacy";
          };
        };

        "crypt/data/paperless" = {
          type = "zfs_fs";
          mountpoint = "/data/paperless";
          options = {
            canmount = "noauto";
            mountpoint = "legacy";
          };
        };

        "crypt/incus" = {
          type = "zfs_fs";
          mountpoint = "/incus";
          options = {
            canmount = "noauto";
            mountpoint = "legacy";
          };
        };
      };
    };
  };
}
