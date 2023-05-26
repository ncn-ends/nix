# asks for ssh key when shell starts
if [ ! -S ~/.ssh/ssh_auth_sock ]; then
  eval `ssh-agent`
  ln -sf "$SSH_AUTH_SOCK" ~/.ssh/ssh_auth_sock
fi
export SSH_AUTH_SOCK=~/.ssh/ssh_auth_sock
ssh-add -l > /dev/null || ssh-add

# alias' for nix shells
alias nix-dotnet="NIXPKGS_ALLOW_UNFREE=1 nix-shell /etc/nixos/shells/dotnet-shell.nix";
alias nix-node="NIXPKGS_ALLOW_UNFREE=1 nix-shell /etc/nixos/shells/node-shell.nix --pure";
alias nix-android="NIXPKGS_ALLOW_UNFREE=1 nix-shell /etc/nixos/shells/android-shell.nix --pure";

# programs
alias vlc="flatpak run org.videolan.VLC"

# ssh
alias ssh:cap="ssh -i ~/.ssh/cap_key.pem cap@20.253.238.231"