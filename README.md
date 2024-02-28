![Cool Image](https://i.imgur.com/C4dBczf.png)
## What is this

Personal repo for everything related to Nix and my dotfiles

## Stylistic preferences
- Standard config files > declaring configs within Nix when possible
- Avoid overlays
- Prefer taller code than nesting
- Modules should be nested 1 layer deep. No importing within modules  
- Minimal packages. If used infrequently, just use `nix-shell -p <package>`
- Don't care about proprietary or bloated software as long as it's good at what it's for  
- Keep `flake.nix` minimal

## Organization
- Each machine has a "foundation" file, to define  what's necessary only for that specific machine. 
    - For example, if I had 2 macbooks, they would each have their own foundation file.  
- Then I try to group things for a purpose
    - For example `modules/vm.nix` has everything needed to run VMs.   
- Any other packages will be dumped in `/modules/package-dump.nix`, grouped by how they're related using sets, which is then included in which ever flake config it relates to.

## Folder structure  

`helpers/` common helpers used across the entire project  
`dev-shells/` dev shells  
`configs/` dotfiles, personal shell scripts, etc.  
`containers/` docker  
`modules/` NixOS and Nix Darwin modules   
`modules/foundation.*.nix` foundational configs for each machine. see `machines` set in flake.nix  also  
`modules/desktop.cinnamon.nix` DE and programs specific to the DE. currently using xserver and cinnamon   
`modules/vscode.nix` vscode configs   
`modules/cli.nix` cli tools and related  
`modules/vm.nix` VMs and related  
`modules/play.nix` gaming  
`modules/secrets.nix` configs for nix-sops  
`modules/server.*.nix` server configs, where each service has its own file. see `containers/` also  