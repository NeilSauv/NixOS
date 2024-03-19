#!/bin/sh

# Chemin du fichier cache
cache_file="/tmp/active_output_cache"

# Suppression du fichier cache existant pour garantir que les données soient à jour
rm -f "$cache_file"

# Récupération de la position de la souris
eval $(xdotool getmouselocation --shell)

# Détermination de l'écran actif et de son ordre
active_output=$(xrandr --query | grep ' connected')

# Stockage des informations dans le fichier cache
echo "$active_output" > "$cache_file"
