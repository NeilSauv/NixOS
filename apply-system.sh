#!/bin/sh

if [ -z "$NAME_USER" ]
then
    if [ $# -eq 0 ]
    then
        echo "Usage: ./apply-system.sh [USER_NAME] [-d]"
        exit 1
    fi
    export NAME_USER="$1"
fi

if [ "$2" = "-d" ]
then
    echo "Deleting old generations and garbage collecting..."
    nix-collect-garbage --delete-old
fi

pushd "/home/$NAME_USER/.dotfiles" || exit

echo "Preparing flake configuration..."
mv ".git" ".gitsave"
sed -e "s/USER_NAME/$NAME_USER/g" "builder/flake.nix" > "flake.nix"

echo "Updating flake inputs..."
nix flake update

(./builder/system/install.sh)

echo "Rebuilding and switching to the new system configuration..."
sudo nixos-rebuild switch --flake .#

mv ".gitsave" ".git"

popd || exit
