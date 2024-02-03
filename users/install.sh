res=$(ls -d */ 2> /dev/null 1> /dev/null; echo $?)

if [ $res != "0" ]
then
    mkdir "$NAME_USER"
fi

sed 's/NAME_USER/$NAME_USER/g' .home.nix > "$NAME_USER/home.nix"
