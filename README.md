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

## Folder structure  
`dep/` files no longer used, but don't feel like deleting them yet  
`helpers/` common helpers used across the entire project  
`dev-shells/` dev shells  
`configs/` config files and personal shell scripts  
`modules/` NixOS/Nix Darwin modules   
`modules/foundation.main.nix` foundational OS settings for main computer  
`modules/system.nix` base programs and related. applicable to both desktop and server NixOS  
`modules/desktop.nix` specific to the desktop environment. currently using xserver and cinnamon  
`modules/gui.common.nix` DE and OS agnostic gui programs and related for all desktop computers  
`modules/gui.home.nix` DE and OS agnostic gui programs and related for non-work computers  
`modules/vm.nix` VMs and related  
`modules/play.nix` gaming  

## Programs to try
### File Managers
- Nemo
- nnn
- yazi
- thunar