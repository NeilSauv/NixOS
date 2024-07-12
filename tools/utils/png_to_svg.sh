#!/bin/bash

# Vérifie si ImageMagick et vectorizer sont installés
if ! command -v convert &> /dev/null
then
    echo "ImageMagick n'est pas installé. Veuillez l'installer avec 'sudo apt-get install imagemagick'."
    exit 1
fi

if ! command -v vectorizer &> /dev/null
then
    echo "vectorizer n'est pas installé. Veuillez l'installer avec 'npm install -g @jscad/svg-deserializer'."
    exit 1
fi

# Boucle sur chaque argument passé au script
for file in "$@"
do
    if [[ $file == *.png ]]; then
        # Retire l'extension du fichier
        base_name=$(basename "$file" .png)
        
        # Convertit le fichier PNG en SVG avec vectorizer
        vectorizer "$file" --output="${base_name}.svg"

        # Vérifie si le fichier SVG est valide (par exemple, non vide)
        if [ -s "${base_name}.svg" ]; then
            echo "Le fichier $file a été converti en ${base_name}.svg"
        else
            echo "La conversion de $file a échoué."
        fi
    else
        echo "$file n'est pas un fichier PNG. Ignoré."
    fi
done
