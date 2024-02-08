
#!/bin/bash

help()
{
    echo "Help"
    echo "(y) : Select this template"
    echo "(f) : Add to favory"
    echo "(u) : Remove from favory"
    echo "(n) : Next template"
    echo "(r) : Launch the template again"
    echo "(q) : Quit"
    echo "(h) : Help"
}

arg1=1
arg2=1
mkdir -p "/home/$NAME_USER/.nixsave"
favory_path="/home/$NAME_USER/.nixsave/rofi-launcher-favory"
currend_fold="/home/$NAME_USER/.config/rofi/launchers"
touch $favory_path

use_fav=false
res="n"

read -p "Do you want to load favory file (y/n): " res
if [ "$res" = "y" ]
then
    if [ ! -f "$favory_path" ];then
            echo "No favory"
            exit 1
    fi

    echo "Favory selected"
    use_fav=true
else
    echo "All template selected"
fi

echo "Template selection use : (y/f/u/n/r/q/h)"
help

while true; do
    if [ ! -d "$currend_fold/type-$arg1" ];then
        break
    fi
    if [ ! -f "$currend_fold/type-$arg1/style-$arg2.rasi" ];then
        ((arg1++))
        arg2=1
        continue
    fi
    line="$arg1:$arg2"
    if [ "$use_fav" = true ];then
        if ! grep -qF "$line" "$favory_path";then
            ((arg2++))
            continue
        fi
    fi
    (rofi -show drun -theme "$currend_fold/type-$arg1/style-$arg2.rasi")

    # Demander à l'utilisateur la prochaine action
    read -p "Choisir option (y/f/u/n/r/q/h): " choice

    case $choice in
        y)
            break
            ;;
        f)
            if ! grep -qF $line "$favory_path"; then
                echo "$arg1:$arg2" >> "$favory_path"
            fi
            ;;
        u)
            sed -i "/^$line$/d" "$favory_path"
            ;;
        n)
            ;;
        r)
            continue
            ;;
        h)
            help
            continue
            ;;
        q)
            exit 0
            ;;
        *)
            echo "Wrong selection !"
            help
            continue
            ;;
    esac
        ((arg2++))
done

echo "rofi -show drun -theme \"$currend_fold/type-$arg1/style-$arg2.rasi\"" > "/home/$NAME_USER/.nixsave/launcherPath.sh"
chmod +x "/home/$NAME_USER/.nixsave/launcherPath.sh"

