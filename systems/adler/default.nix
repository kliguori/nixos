{ lib, pkgs, ... }:
{
  imports = [
    ../../users
  ];

  systemOptions.users = [ "admin" ];

  image.fileName = "PiZero2W.img";
  sdImage = {
    compressImage = false;
    extraFirmwareConfig = {
      start_x = 0;
      gpu_mem = 16;
      hdmi_group = 2;
      hdmi_mode = 8;
    };
  };

  system.stateVersion = "25.11";

  zramSwap = {
    enable = true;
    algorithm = "zstd";
  };

  hardware = {
    enableRedistributableFirmware = lib.mkForce false;
    firmware = [ pkgs.raspberrypiWirelessFirmware ]; # Keep this to make sure wifi works
    i2c.enable = true;
    deviceTree = {
      enable = true;
      kernelPackage = pkgs.linuxKernel.packages.linux_rpi3.kernel;
      filter = "*2837*";
      overlays = [
        {
          name = "enable-i2c";
          dtsFile = ./dts/i2c.dts;
        }
        {
          name = "pwm-2chan";
          dtsFile = ./dts/pwm.dts;
        }
        {
          name = "spi1-2cs";
          dtsFile = ./dts/spi.dts;
        }
      ];
    };
  };

  boot = {
    kernelPackages = pkgs.linuxPackages_rpi02w;
    initrd.availableKernelModules = lib.mkForce [
      "xhci_pci"
      "usbhid"
      "usb_storage"
    ];
    loader = {
      grub.enable = false;
      generic-extlinux-compatible.enable = true;
    };
    swraid.enable = lib.mkForce false;
  };

  networking = {
    hostName = "adler";
    interfaces."wlan0".useDHCP = true;
    wireless = {
      enable = true;
      interfaces = [ "wlan0" ];
      networks."${builtins.getEnv "WIFI_SSID"}".psk = builtins.getEnv "WIFI_PSK"; # pass ssid and psk as env vars
    };
  };

  security.sudo = {
    enable = true;
    wheelNeedsPassword = false;
  };

  services.sshd.enable = true;
  services.timesyncd.enable = true;
  services.avahi = {
    enable = true;
    nssmdns4 = true;
    openFirewall = true;
    publish = {
      enable = true;
      addresses = true;
      domain = true;
      workstation = true;
    };
  };
}
