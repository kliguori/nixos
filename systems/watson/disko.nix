{
  disk.main = {
    type = "disk";
    device = "/dev/disk/by-id/nvme-Samsung_SSD_970_EVO_Plus_1TB_S4P4NF0M605101P";
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

        swap = {
          name = "swap";
          size = "40G";
          type = "8200";
          content = {
            type = "luks";
            name = "cryptswap";
            content = {
              type = "swap";
              resumeDevice = true;
            };
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

  zpool.rpool = {
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

      "crypt/nix" = {
        type = "zfs_fs";
        mountpoint = "/nix";
        options = {
          canmount = "noauto";
          mountpoint = "legacy";
        };
      };

      "crypt/persist" = {
        type = "zfs_fs";
        mountpoint = "/persist";
        options = {
          canmount = "noauto";
          mountpoint = "legacy";
        };
      };

      "crypt/home" = {
        type = "zfs_fs";
        mountpoint = "/home";
        options = {
          canmount = "noauto";
          mountpoint = "legacy";
        };
      };
    };
  };
}
