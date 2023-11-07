# asks for ssh key when shell starts
if [ ! -S ~/.ssh/ssh_auth_sock ]; then
  eval `ssh-agent`
  ln -sf "$SSH_AUTH_SOCK" ~/.ssh/ssh_auth_sock
fi
export SSH_AUTH_SOCK=~/.ssh/ssh_auth_sock
ssh-add -l > /dev/null || ssh-add

# alias' for nix shells
alias nix-dotnet="nix develop /etc/nixos#dotnet";
alias nix-node="nix develop /etc/nixos#node";
alias nix-py="NIXPKGS_ALLOW_UNFREE=1 nix-shell /etc/nixos/shells/python-shell.nix";

# convenience alias'
alias nix-sw="sudo nixos-rebuild switch"

# convenience scripts
alias scd="source /etc/nixos/configs/scripts/scd.sh"
alias ucd="source /etc/nixos/configs/scripts/ucd.sh"
alias sls="source /etc/nixos/configs/scripts/sls.sh"
alias addcdlog="source /etc/nixos/configs/scripts/addcdlog.sh"

# programs
alias vlc="flatpak run org.videolan.VLC"
alias bottles="flatpak run com.usebottles.bottles"

# ssh
alias ssh:cap="ssh -i ~/.ssh/cap_key.pem cap@20.253.238.231"
alias ssh:ubuntu="ssh -i ~/.ssh/ubuntuvps ncn@45.77.184.179"
alias ssh:hs="ssh -i ~/.ssh/ubuntuhs ncn@10.0.0.134"

# direnv
eval "$(direnv hook bash)"