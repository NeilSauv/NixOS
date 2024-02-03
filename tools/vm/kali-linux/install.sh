#!/bin/sh

cd vm/kali-linux

if [ ! -f "kali-linux.7z" ]
then
    wget -O kali-linux.7z https://cdimage.kali.org/kali-2023.3/kali-linux-2023.3-virtualbox-amd64.7z
fi

if test -d "$HOME/.vm/kali-linux/"; then
    exit 0
fi


if [ ! -d "$HOME/.vm" ]
then
    mkdir .vm
    mv .vm $HOME
    rm -rf .vm
fi

mkdir kali-linux
mv kali-linux $HOME/.vm/
rm -rf kali-linux

7z x kali-linux.7z -o"$HOME/.vm/kali-linux/"

cd ../../
