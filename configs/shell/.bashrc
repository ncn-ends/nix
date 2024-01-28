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

# convenience alias'
alias nix-sw="sudo nixos-rebuild switch"
alias nix-up="cd /etc/nix; nix flake update; nix-sw"
alias nix-clean="sudo nix-collect-garbage --delete-older-than 60d"

# convenience scripts
alias scd="source /etc/nixos/configs/scripts/scd.sh"
alias ucd="source /etc/nixos/configs/scripts/ucd.sh"
alias sls="source /etc/nixos/configs/scripts/sls.sh"
alias addcdlog="source /etc/nixos/configs/scripts/addcdlog.sh"

# programs
alias bottles="flatpak run com.usebottles.bottles"

# ssh
alias ssh:cap="ssh -i ~/.ssh/cap_key.pem cap@20.253.238.231"
alias ssh:ubuntu="ssh -i ~/.ssh/ubuntuvps ncn@45.77.184.179"
alias ssh:hs="ssh -i ~/.ssh/ubuntuhs ncn@10.0.0.134"

# required for direnv
eval "$(direnv hook bash)"

# set default editor to vim
export SUDO_EDITOR="vim"
export EDITOR="vim"
export GIT_EDITOR="vim";
export GIT_SEQUENCE_EDITOR="vim";
export TERMINAL=$TERM