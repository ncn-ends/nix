## Intro

This is my nix set up for home-manager, nix-darwin (macos), and my nixos main computer.  
The goal is to have everything configured in this repo, and be able to share my config for other people to use. 
Organization is WIP while I figure out how I want to do things and learn more about Nix.
## Darwin

### Setup steps
- update macos to the latest version
- install nix for multi-users (even if not intending to use multiple users)
   -  `sh <(curl -L https://nixos.org/nix/install) --daemon`  
- set up repo in a local directory of your choice
    - i do this in `~/nix/darwin` -- any reference to `~/nix/darwin` in these steps should point to your own desired directory.
- bootstrap nix darwin in desired directory
    - run `nix --extra-experimental-features "nix-command flakes" build .#darwinConfigurations.ncn.system`  
        - this will create a /result directory in the desired directory
    - run `./result/sw/bin/darwin-rebuild --flake .`
        - this will fail on the initial attempt after putting in your password
        - the script will output a message telling you what to do in this case, but you can just follow these steps
        - run `printf 'run\tprivate/var/run\n' | sudo tee -a /etc/synthetic.conf`
        - run `/System/Library/Filesystems/apfs.fs/Contents/Resources/apfs.util -t`
            - use `-B` flag instead of `-t` flag if using Catalina
    - rerun `./result/sw/bin/darwin-rebuild --flake .`
        - there will be a few errors, but the script should end successfully
    - run `sudo rm /etc/nix/nix.conf /etc/shells`
        - this will delete 2 files that will be managed by nix
    - rerun `./result/sw/bin/darwin-rebuild --flake .`
    - close the terminal and then re-open. the configured zsh environment should be applied, indicated a sucessful build
    - from now on you can rebuild using `nixsw`
        - if your desired directory you set was not `~/nix/darwin` then you will have to change this in the file
- set up ssh keys and attach to github account
    - use personal method or create a new one locally
        - `ssh-keygen -t ed25519 -C "youremail@tld.com"`
        - `cat ~/.ssh/id_ed25519.pub`
        - copy output
        - go to https://github.com/settings/keys
        - add a new key for authentication, name it what you want, and paste the output you previously copied
- setup homebrew
    - go to https://brew.sh/ and install via the 1 liner provided at the center of the page
        - the homebrew installation script requires ssh keys, so you can't skip previous step
- before running the rebuild, log into the app store
    - you only have to do this once, and this is required to install Xcode or any other macOS app store apps. you can skip this if you don't need any of those apps
- restart your macbook
    - some changes on nix darwin require a complete restart to take effect
- using spotlight (cmd+space) to run raycast and set it up
    - from now on, use raycast to launch apps. spotlight doesn't work great with nix because of the way apps are stored. you can make it work, but it's not worth the hassle. raycast is a nicer app anyway. 




## Missing From Here

- Jetbrains IDEs (datagrip and Rider) configs are not stored here, instead using the Jetbrains sync feature built into the IDE
    - When initially setting up, navigate to File -> Manage IDE Settings -> Settings Sync, then Enable Syncing

## Resources

[NixOS Package Search](https://search.nixos.org/packages)  
[NixOS Option Search](https://search.nixos.org/options?)  
[home-manager config options](https://rycee.gitlab.io/home-manager/options.html)  
[(Video) Set up guide from Matthis Benaets](https://www.youtube.com/watch?v=AGVXJ-TIv3Y)  
[Nix ecosystem guide on nix.dev](https://nix.dev/tutorials)  
[Nix pills](https://nixos.org/guides/nix-pills/functions-and-imports.html)  
[General Nix guide "zero to nix", beginner friendly](https://zero-to-nix.com/)