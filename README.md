![Cool Image](https://i.imgur.com/C4dBczf.png)
## Stylistic preferences
- Config files over declaring settings within Nix
- Master is named stable, and stable and unstable are both accessible interchangably
- Avoid overlays
- Avoid channels
- Prefer taller code than nesting
- Modules should be nested 1 layer deep. No importing within modules (unless it's in an import)
- Minimal packages. If used infrequently, just use `nix-shell -p <package>`
- Don't care about proprietary or bloated software as long as it's good at what it's for  
- Keep `flake.nix` minimal

## Folder structure  
`helpers/` common helpers used across the entire project  
`dev-shells/` dev shells  
`configs/` config files and personal shell scripts  
`modules/` NixOS/Nix Darwin modules   
`modules/foundation.main.nix` foundational OS settings for main systems  
`modules/foundation.mac.nix` foundational OS settings for mac systems  
`modules/system.nix` base programs and related. applicable to both desktop and server NixOS. e.g. vim  
`modules/desktop.nix` DE and programs specific to the DE. currently using xserver and cinnamon   
`modules/gui.common.nix` DE/OS agnostic gui programs and related for all desktop computers  
`modules/gui.home.nix` DE/OS agnostic gui programs and related for non-work computers  
`modules/vscode.nix` vscode configs (should be in `gui.common.nix` but takes up enough space for its own file)  
`modules/vm.nix` VMs and related  
`modules/play.nix` gaming  
`modules/secrets.nix` configs for nix-sops  
`modules/sever.nix` server configs and related e.g. plex, firewall  
`modules/minecraft.server.nix` minecraft server configs  


## Programs to try
### File Managers
- Nemo
- nnn
- yazi
- thunar