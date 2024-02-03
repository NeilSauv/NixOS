RECOVER=~/.dotfiles/tools/utils/.recover

if [ ! -f "$RECOVER" ]; then
    echo "no"
    exit 0
fi

if [ $# -ge 1 ]; then
    PTH=$(pwd)
    cd ~/.trash
    mv "$@" "$PTH"
    exit 0
fi

PTH=$(head -n 1 "$RECOVER")
cd ~/.trash/

# Récupère la liste des fichiers à déplacer
files_to_move=$(tail -n 1 "$RECOVER")

# Utilise eval pour exécuter correctement la commande mv avec des guillemets
eval mv $files_to_move "$PTH"

