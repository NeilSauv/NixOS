#!/bin/sh
screens=$(xrandr --query | grep ' connected' | cut -d ' ' -f1 | cut -d ':' -f2 | sort)
count=1

for screen in $screens
do
    command="workspace number $count; move workspace to output $screen"
    echo "Exécution : i3-msg \"$command\""
    i3-msg "$command"
    count=$((count + 10))
done

count=1

for screen in $screens
do
    command="workspace number $count; move workspace to output $screen"
    echo "Exécution : i3-msg \"$command\""
    i3-msg "$command"
    count=$((count + 10))
done


