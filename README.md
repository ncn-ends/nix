## Intro

This is my nix set up for home-manager, nix-darwin (macos), and my nixos main computer.  
The goal is to have everything configured in this repo, and be able to share my config for other people to use. 
Organization is WIP while I figure out how I want to do things and learn more about Nix.

### Darwin
- initial bootstrap  
    - `nix --extra-experimental-features "nix-command flakes" build .#darwinConfigurations.ncn.system`
- when setting up xcode
    - run `sudo xcode-select -s /Applications/Xcode.app` -or- go to preferences/settings -> locations -> select xcode version (warning: if you do it through the GUI, it will show a default value in the dropdown even if it's not set yet. need to actually select it initially. )

## Missing From Here

- Jetbrains IDEs (datagrip and Rider) configs are not stored here, and instead use the Jetbrains sync feature built into the IDE
    - When initially setting up a new installation, navigate to File -> Manage IDE Settings -> Settings Sync, then Enable Syncing

## Resources

[NixOS Package Search](https://search.nixos.org/packages)  
[NixOS Option Search](https://search.nixos.org/options?)  
[home-manager config options](https://rycee.gitlab.io/home-manager/options.html)  
[(Video) Set up guide from Matthis Benaets](https://www.youtube.com/watch?v=AGVXJ-TIv3Y)  
[Nix ecosystem guide on nix.dev](https://nix.dev/tutorials)
[Nix Shell tutorial from Mattia Gheda](https://ghedam.at/15978/an-introduction-to-nix-shell)