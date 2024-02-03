# NixOS
My nixos configuration
# INSTALLATION

## Partition installation
```
# Follow this tutorial to install the partitions
https://www.youtube.com/watch?v=gAEvO8tnqnM
```

## Clone
```
nix-shell -p git
git clone https://github.com/NeilSauv2003/NixOS ~/.dotfiles
exit
```

## Switch to unstable
```
sudo nix-channel --add https://nixos.org/channels/nixos-unstable nixos
sudo nixos-rebuild switch --upgrade
```

## Install home-manager
```
sudo nix-channel --add https://github.com/nix-community/home-manager/archive/master.tar.gz home-manager
sudo nix-channel --update
nix-shell '<home-manager>' -A install
sudo nixos-rebuild switch
```
## Launch flake
Finally you just have to execute the following command in order to build your config
```
cd ~/.dotfiles
sudo ./apply-system.sh [User_name]
reboot
./apply-user.sh [User_name]
reboot
```
