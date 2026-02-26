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

## To do:
- [ ] PostgreSQL
- [ ] Redis
- [ ] Nextcloud
- [ ] Sort out a scanner for paperless
- [ ] HAOS VM
- [ ] Jet KVM
- [ ] DMS config 
- [ ] Refactor mkSystem to a lib folder
- [ ] Lanzaboote
- [ ] Miniflux
- [ ] Monitoring
- [ ] Uptime Kuma
- [ ] Prometheus
- [ ] Graphana
- [ ] Set up outgoing vpn
- [ ] Audiobookshelf
- [ ] Immich
- [ ] ACME resolver still pointing to cloudflare... maybe change
- [ ] Get off tailscale, maybe headscale?
- [ ] Pi hole/DNS situation. Unbound?
- [ ] Simplify install with nix functions?
- [ ] Make home manager dendritic
- [ ] Expose some services?
- [ ] fzf or ways to find zsh history
- [ ] Automate install proceedure
- [ ] Re-evaluate terminal choice
- [x] Get lestrade back on zfs
- [x] Remove all traces of darwin from home manager configs
- [x] Finish making sherlock config dendritic, re-evaluate disk configs and impermanence model
- [x] Firefox config including ad blocking
- [x] Remote access to network tailscale
- [x] samba
- [x] Paperless
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
1. echo 0x\<hostId\> | sudo tee /sys/module/spl/parameters/spl_hostid
    - This sets the hostid for the install media to the hostid for the system you're building, at least according to zfs. Doing this prevents any non-root zpools from not importing due to different hostIds in installer and on the new system. If you don't do this, some pools might not import, and this could block the boot. If boot is blocked, drop into recovery and force import the pools. After rebooting, zpools should import fine as they are now set to the hostId.
2. sudo nix --experimental-features "nix-command flakes" run github:nix-community/disko -- --mode disko --flake github:kliguori#\<hostName\>
    - THIS IS DESTRUCTIVE. This formats the disks and mounts them under /mnt ready to be installed.
3. sudo mkdir -p /mnt/persist/secrets/users/\<userName\> 
    - This point creates the directory to store \<userName\>'s password. 
4. mkpasswd -m yescrypt | sudo tee /mnt/persist/secrets/users/\<userName\>/password.txt > /dev/null 
    - Generates password file containing the hashed password. 
5. sudo chmod 0600 /mnt/persist/secrets/users/\<userName\>/password.txt
    - Make the password and writeable by root only.
6. sudo nixos-install --flake github:kliguori#\<hostName\> --root /mnt --no-write-lock-file --no-root-password --option tarball-ttl 0
    - This downloads fresh tarball of the config and installs the system.
