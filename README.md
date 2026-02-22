# NixOS
This repo contains my NixOS configurations for the below systems.

## Sherlock [x]
Sherlock is my desktop and main system.
- MSI ACE MEG x570
- Ryzen 9 3900X (12 core)
- Nvidia 2080Ti 
- 2x16 GB DDR4
- 500 GB nvme
- 500 GB nvme
- 1 TB SATA SSD 
- 1 TB HDD

## Watson [x]
Watson is my primary laptop.
- Framework 13 
- Ryzen 5 7040 (6 core)
- 2x16 GB DDR5
- 1 TB nvme SSD

## Mycroft [x]
Mycroft is my home server.
- Dell XPS15 9500 
- i7 10750H (6 core)
- GTX 1650Ti
- 2x8 GB DDR4
- 500 GB nvme
- 4 TB nvme

## Lestrade [x]
Lestrade is a (somewhat) usefull testbed for watson.
- Lenovo ThinkPad T14 Gen 1 
- Ryzen 7
- 16 GB (soldered) DDR4
- 1 open DDR4 slot

## Gregson [ ]
Gregson is a (mostly) useless old gaming laptop that I don't yet have a good use for.
- Dell Latitude 15 
- i7 6700HQ
- 2x8 GB DDR3
- 256 GB SSD

## Moriarty [ ]
Moriarty is a persistent usb that I will use for install and recovery.
- X GB persistent storage

## To do:
- [ ] Paperless
- [ ] Nextcloud
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
- [ ] Vim motions in terminal
- [ ] Re-evaluate terminal choice
- [x] Allow multiple profiles, look at redoing profiles
- [x] Make impermanence the default
- [x] Vaultwarden
- [x] Add tls to domain name
- [x] Fix postgreSQL
- [x] SOPS-Nix
- [x] Make sure disko can add BTRFS subvols without being destructive
- [x] Get dms running on login
- [x] Jellyfin
- [x] Simplify niri config/keybinds
- [x] Move off unstable, except for what requires it
- [x] Reverse proxy
