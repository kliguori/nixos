# NixOS
This repo contains my NixOS configurations for the below systems.

## Sherlock
Sherlock is my desktop and main system.
- MSI ACE MEG x570
- Ryzen 9 3900X (12 core)
- Nvidia 2080Ti 
- 2x16 GB DDR4
- 500 GB nvme
- 500 GB nvme
- 1 TB SATA SSD 
- 1 TB HDD

## Watson
Watson is my primary laptop.
- Framework 13 
- Ryzen 5 7040 (6 core)
- 2x16 GB DDR5
- 1 TB nvme SSD

## Mycroft
Mycroft is my home server.
- Dell XPS15 9500 
- i7 10750H (6 core)
- GTX 1650Ti
- 2x8 GB DDR4
- 500 GB nvme
- 4 TB nvme

## Lestrade
Lestrade is a (somewhat) usefull testbed for watson.
- Lenovo ThinkPad T14 Gen 1 
- Ryzen 7
- 16 GB (soldered) DDR4
- 1 open DDR4 slot

## Gregson
Gregson is a (mostly) useless old gaming laptop that I don't yet have a good use for.
- Dell Latitude 15 
- i7 6700HQ
- 2x8 GB DDR3
- 256 GB SSD

## Moriarty
Moriarty is a persistent usb that I will use for install and recovery.
- X GB persistent storage

## To do:
- [ ] Paperless
- [ ] Scanner/samba
- [ ] Nextcloud
- [ ] Monitoring
- [ ] Remote access to network tailscale (headscale), netbird, wireguard, cloudflare tunnels, Unifi vpn?
- [ ] Set up outgoing vpn.
- [ ] Miniflux
- [ ] Uptime Kuma
- [ ] Prometheus
- [ ] Graphana
- [ ] Refactor mkSystem to a lib folder
- [ ] Audiobookshelf
- [ ] Immich
- [ ] ACME resolver still pointing to cloudflare... maybe change.
- [ ] Pi hole/DNS situation. Unbound?
- [ ] Simplify install with nix functions?
- [ ] Finish making sherlock config dendritic, re-evaluate disk configs and impermanence model
- [ ] Remove all traces of darwin from home manager configs
- [ ] Make home manager dendritic
- [ ] Firefox config including ad blocking
- [ ] DMS config 
- [ ] Lanzaboote
- [ ] Expose some services?
- [ ] fzf or ways to find zsh history
- [ ] Re-evaluate terminal choice
- [ ] Automate install proceedure
- [x] Vim motions in terminal
- [x] Allow multiple profiles, look at redoing profiles
- [x] Make impermanence the default
- [x] Vaultwarden
- [x] Add tls to domain name
- [x] Make sure disko can add BTRFS subvols without being destructive
- [x] Get dms running on login
- [x] Jellyfin
- [x] Simplify niri config/keybinds
- [x] Move off unstable, except for what requires it
- [x] Reverse proxy

## About installing
After booting into the installer and connecting to the internet
1. run "echo -n \<hostId\> >> /etc/hostId" -- this prevents any non-root zpools from not importing due to different hostIds in installer and on the new system. If you don't do this, some pools might not import, and this could block the boot. If boot is blocked, drop into recovery and force import the pools. After rebooting, zpools should import fine as they are now set to the hostId.
2. run "sudo nix --experimental-features "nix-command flakes" run github:nix-community/disko -- --mode disko --flake github:kliguori#\<hostName\>" -- this formates the disks and mounts them under /mnt ready to be installed. THIS IS DESTRUCTIVE.
3. At this point, you can generate password files in the /persist folder with 
"mkpasswd -m yescrypt > /persist/secrets/\<userName\>/password.txt".
4. run "sudo nixos-install --flake github:kliguori#\<hostName\> --root /mnt --no-write-lock-file --no-root-password". This installs the system.

If you find you need to run disko or nixos-install again with a fresh tarball, use the option "--option tarball-ttl 0".
