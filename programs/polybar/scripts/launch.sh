#!/bin/sh
# Tuer toutes les instances de Polybar en cours d'exécution pour éviter les doublons
pkill polybar

# Attendre que toutes les instances soient réellement terminées
while pgrep -x polybar >/dev/null; do sleep 1; done

# Lancer Polybar sur tous les moniteurs détectés
for m in $(polybar --list-monitors | cut -d":" -f1); do
    MONITOR=$m polybar --reload main &
done
