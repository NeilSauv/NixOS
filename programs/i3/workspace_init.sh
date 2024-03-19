#!/bin/sh

screens=$(xrandr --query | grep ' connected' | cut -d ' ' -f1 | cut -d ':' -f2 | sort)
count=1

active_output=""
output_order=1

for screen in $screens
do
    if [ -z "$active_output" ]; then
        # Supposons que le premier écran dans la liste est l'écran actif pour le démarrage
        active_output="$screen"
    fi
    command="workspace number $count; move workspace to output $screen"
    echo "Exécution : i3-msg \"$command\""
    i3-msg "$command"
    count=$((count + 10))
    output_order=$((output_order + 1))
done

count=1

for screen in $screens
do
    command="workspace number $count; move workspace to output $screen"
    echo "Exécution : i3-msg \"$command\""
    i3-msg "$command"
    count=$((count + 10))
done
