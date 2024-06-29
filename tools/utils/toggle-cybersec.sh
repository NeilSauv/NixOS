#!/usr/bin/env bash

PROFILE_PATH="/nix/var/nix/profiles/per-user/$(whoami)/cybersec-profile"
PROFILE_NIX="/home/neil/.dotfiles/builder/cybersec-profile.nix"
EXPORT_FILE=$(mktemp)

function switch_profile {
    nix-env --switch-profile $1
    if [ $? -ne 0 ]; then
        exit 1
    fi
}

function handle_exit {
    if [ $? -ne 0 ]; then
        exit 1
    fi
}

function enable_profile {
    export NIXPKGS_ALLOW_UNFREE=1
    # Exporter les paquets du profil actuel
    nix-env --export > $EXPORT_FILE
    handle_exit
    # Importer les paquets dans le nouveau profil
    nix-env -p $PROFILE_PATH --import < $EXPORT_FILE
    handle_exit
    # Installer les paquets de cybersécurité dans le nouveau profil
    nix-env -p $PROFILE_PATH -f $PROFILE_NIX -i
    handle_exit
    nix-env --set-flag priority 50 -p $PROFILE_PATH
    handle_exit
    switch_profile $PROFILE_PATH
    echo "Cybersecurity tools enabled."
}

function reload_profile {
    enable_profile
    echo "Cybersecurity tools reloaded."
}

if [ "$1" == "enable" ]; then
    enable_profile
elif [ "$1" == "reload" ]; then
    reload_profile
else
    echo "Usage: $0 {enable|reload}"
    exit 1
fi

# Nettoyer le fichier temporaire
rm -f $EXPORT_FILE
