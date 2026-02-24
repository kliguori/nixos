{ config, lib, pkgs, ... }:
let
  cfg = config.systemOptions;
in
{
  config = lib.mkIf (lib.elem "recovery" cfg.profiles) {
    environment.systemPackages = with pkgs; [
      # Disk & Filesystem
      disko
      gptfdisk
      e2fsprogs
      dosfstools
      btrfs-progs
      xfsprogs
      ntfs3g
      cryptsetup
      smartmontools
      testdisk
      ddrescue
      gparted

      # Secrets & Keys
      ssh-to-age
      gnupg

      # Networking
      wireguard-tools
      netcat
      socat
      tcpdump
      wireshark
      iperf3
      whois

      # System Info
      lshw
      dmidecode
      nvme-cli

      # Boot & Recovery
      efibootmgr
      chntpw

      # Files
      binutils
      p7zip

      # NixOS Specific
      nixos-install-tools
    ];
  };
}
