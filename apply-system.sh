#!/bin/sh

if [ -z "$NAME_USER" ]
then
    if [ $# -eq 0 ]
    then
        echo "Usage: ./apply-system.sh [USER_NAME]"
        exit 1
    fi
    export NAME_USER="$1"
fi

if [ "$2" = "-d" ]
then
    nix-collect-garbage --delete-old
fi
pushd "/home/$NAME_USER/.dotfiles"
mv ".git" ".gitsave"
sed -e "s/USER_NAME/$NAME_USER/g" "builder/flake.nix" > "flake.nix"
(./builder/system/install.sh)
sudo nixos-rebuild switch --flake .#
mv ".gitsave" ".git"
popd
