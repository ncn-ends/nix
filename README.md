# Stylistic preferences
- Config files over declaring settings within Nix
- Master is named stable, and stable and unstable are both accessible interchangably
- Avoid overlays
- Avoid channels
- Prefer taller code than nesting

### Folder structure  
`dep/` files no longer used, but don't feel like deleting them yet  
`modules/` NixOS modules  
`helpers/` helpers used across nixos modules, dev shells, etc.   
`dev-shells.nix` may separate into files in the future