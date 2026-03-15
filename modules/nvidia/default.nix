{ config, lib, ... }:
let
  cfg = config.systemOptions.nvidia;
in
{
  options.systemOptions.nvidia = {
    enable = lib.mkEnableOption "NVIDIA GPU support";

    prime = {
      enable = lib.mkEnableOption "NVIDIA PRIME offload support";

      intelBusId = lib.mkOption {
        type = lib.types.nullOr lib.types.str;
        default = null;
        description = "PCI bus ID of the Intel iGPU e.g. PCI:0:2:0";
      };

      nvidiaBusId = lib.mkOption {
        type = lib.types.nullOr lib.types.str;
        default = null;
        description = "PCI bus ID of the NVIDIA GPU e.g. PCI:1:0:0";
      };
    };
  };

  config = lib.mkIf cfg.enable {
    assertions = [
      {
        assertion = !cfg.prime.enable || cfg.prime.intelBusId != null;
        message = "systemOptions.nvidia.prime.intelBusId must be set when PRIME is enabled";
      }
      {
        assertion = !cfg.prime.enable || cfg.prime.nvidiaBusId != null;
        message = "systemOptions.nvidia.prime.nvidiaBusId must be set when PRIME is enabled";
      }
    ];
    
    services.xserver.videoDrivers = [ "nvidia" ];

    hardware = {
      graphics.enable = true;
      nvidia = {
        modesetting.enable = true;
        open = false;
        nvidiaSettings = true;
        package = config.boot.kernelPackages.nvidiaPackages.stable;

        prime = lib.mkIf cfg.prime.enable {
          offload = {
            enable = true;
            enableOffloadCmd = true;
          };
          intelBusId = cfg.prime.intelBusId;
          nvidiaBusId = cfg.prime.nvidiaBusId;
        };

        powerManagement = lib.mkIf cfg.prime.enable {
          enable = true;
          finegrained = true;
        };
      };
    };
  };
}
