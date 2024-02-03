if [ $# -eq 0 ]
then
    echo "Usage: ./install.sh [USER_NAME]"
    exit 1
fi

export NAME_USER="$1"

files=(
    "home.nix:users/$NAME_USER/home.nix"
    "zsh.nix:programs/zsh/default.nix"
)

install=(
    "tools"
    "builder"
)

maj="$NAME_USER"
maj=$(echo "$maj" | sed 's/./\u&/')

extract_tuple() {
    local tuple="$1"
    local index="$2"
    local separator=":"
    local element=$(echo "$tuple" | cut -d"$separator" -f"$((index + 1))")
    echo "$element"
}

pushd ~/.dotfiles

mv ".git" ".gitsave"
first=true
if [ -d "users/$NAME_USER" ]
then
    first=false
else
    mkdir -p "users/$NAME_USER"
fi

for tuple in "${files[@]}"
do
    name=$(extract_tuple "$tuple" 0)
    path=$(extract_tuple "$tuple" 1)
    sed -e "s/USER_NAME/$NAME_USER/g" -e "s/USER_MAJ/$maj/g" "builder/$name" > "$path"
done

#if [ $first = true ]
#then
#    home-manager switch --flake .
#fi

for script in "${install[@]}"
do
    (~/.dotfiles/$script/install.sh)
done




if [[ $2 == "-d" ]]
then
    nix-collect-garbage -d
fi

nix build ".#homeConfigurations.$NAME_USER.activationPackage"
home-manager switch --flake .
mv ".gitsave" ".git"
popd
