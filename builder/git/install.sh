#!/bin/sh

maj="$NAME_USER"
maj=$(echo "$maj" | sed 's/./\u&/')

cd git
existing_key=$(git config --global user.signingkey)

if [ ! -z "$existing_key" ]; 
then
    exit 0
fi

mkdir -p ../../programs/git/

read -p "Entrez votre nom complet : " full_name
read -p "Entrez votre adresse email : " email

echo "Génération d'une nouvelle clé GPG pour $full_name <$email>..."
gpg --batch --gen-key <<EOF
Key-Type: RSA
Key-Length: 4096
Subkey-Type: RSA
Subkey-Length: 4096
Name-Real: $full_name
Name-Email: $email
Expire-Date: 0
EOF

key_id=$(gpg --list-secret-keys --keyid-format LONG "$email" | grep sec | awk '{print $2}' | cut -d'/' -f2)

sed -e "s/USER_MAJ/$maj/g" -e "s/USER_EMAIL/$email/g" -e "s/USER_KEY/$key_id/g" "default.nix" > "../../programs/git/default.nix"

ssh-keygen -t ed25519 -C "$email"
str=$(cat ~/.ssh/id_ed25519.pub)
echo "Copy the folowing string into github : $str\n"
echo "Presse ENTER when done"
read -r nothing
cd ..
