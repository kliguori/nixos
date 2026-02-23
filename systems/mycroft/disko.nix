{
  disk = {
    system = {
      type = "disk";
      device = "/dev/disk/by-id/nvme-Samsung_SSD_970_EVO_500GB_S5H7NG0N214175Z";
      content = {
        type = "gpt";
        partitions = {
          ESP = {
            size = "1G";
            type = "EF00";
            content = {
              type = "filesystem";
              format = "vfat";
              mountpoint = "/boot";
              mountOptions = [ "umask=0077" ];
            };
          };
          crypt = {
            size = "100%";
            content = {
              type = "luks";
              name = "cryptroot";
              content = {
                type = "btrfs";
                extraArgs = [ "-f" ];
                subvolumes = {
                  "@nix" = {
                    mountpoint = "/nix";
                    mountOptions = [
                      "compress=zstd"
                      "noatime"
                    ];
                  };
                  "@persist" = {
                    mountpoint = "/persist";
                    mountOptions = [
                      "compress=zstd"
                      "noatime"
                    ];
                  };
                };
              };
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
          crypt = {
            size = "100%";
            content = {
              type = "luks";
              name = "cryptdata";
              content = {
                type = "btrfs";
                extraArgs = [ "-f" ];
                subvolumes = {
                  # --- Media ---
                  "@movies" = {
                    mountpoint = "/media/movies";
                    mountOptions = [
                      "compress=zstd"
                      "noatime"
                    ];
                  };
                  "@tv" = {
                    mountpoint = "/media/tv";
                    mountOptions = [
                      "compress=zstd"
                      "noatime"
                    ];
                  };

                  # --- Service data ---
                  "@vaultwarden" = {
                    mountpoint = "/data/vaultwarden";
                    mountOptions = [
                      "compress=zstd"
                      "noatime"
                    ];
                  };
                  "@paperless" = {
                    mountpoint = "/data/paperless";
                    mountOptions = [
                      "compress=zstd"
                      "noatime"
                    ];
                  };
                };
              };
            };
          };
        };
      };
    };
  };
}
