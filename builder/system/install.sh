#!/bin/sh

maj="$NAME_USER"
maj=$(echo "$maj" | sed 's/./\u&/')

cd builder/system
if [ -d "../../system" ]
then
    cd ../../
    exit 0
fi

mkdir -p ../../system/

while (true)
do
    printf "\nObtenir UUID pour partition ext4\n"
    printf "Partitions de type ext4 disponibles :\n"
    lsblk -f | grep "ext4"
    printf "Veuillez entrer l'UUID de la partition choisie pour ext4: "
    read -r uuid_ext4

    printf "\nObtenir UUID pour partition vfat\n"
    printf "Partitions de type vfat disponibles :\n"
    lsblk -f | grep "vfat"
    printf "Veuillez entrer l'UUID de la partition choisie pour vfat: "
    read -r uuid_vfat

    printf "\nObtenir UUID pour partition swap\n"
    printf "Partitions de type swap disponibles :\n"
    lsblk -f | grep "swap"
    printf "Veuillez entrer l'UUID de la partition choisie pour swap: "
    read -r uuid_swap

    printf "\nUUID sélectionné pour ext4: %s\n" "$uuid_ext4"
    printf "UUID sélectionné pour vfat: %s\n" "$uuid_vfat"
    printf "UUID sélectionné pour swap: %s\n" "$uuid_swap"
    printf "\nValidez vous ces informations (y/n) : "
    read -r res

    if [ $res = "y" ]
    then
        break
    fi
done

sed -e "s/UUID_EXT4/$uuid_ext4/g" -e "s/UUID_VFAT/$uuid_vfat/g" -e "s/UUID_SWAP/$uuid_swap/g" "hardware-configuration.nix" > "../../system/hardware-configuration.nix"

sed -e "s/USER_NAME/$NAME_USER/g" -e "s/USER_MAJ/$maj/g" "configuration.nix" > "../../system/configuration.nix"
cd ../../
