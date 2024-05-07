#!/bin/sh
current_workspace=$(echo $current_workspace_json | jq '.[] | select(.focused==true) | .num')
current_workspace=$(i3-msg -t get_workspaces | jq '.[] | select(.focused==true) | .num');
randomid=$(tr -dc '0-9' < /dev/urandom | fold -w 6 | head -n 1)
title="VSCode$randomid"
window_id=$(xdotool getactivewindow)
geometry=$(xdotool getwindowgeometry $window_id)
targetX=$(echo "$geometry" | awk '/Position:/ {print $2}' | cut -d ',' -f1)
targetY=$(echo "$geometry" | awk '/Position:/ {print $2}' | cut -d ',' -f2)
window_before=$(xdotool search --class "Code")

close()
{
    i3-msg [title=$title] move container to workspace $current_workspace > /dev/null
    i3-msg [title=$title] focus > /dev/null
    sleep 0.1
    position $1 $2 $window_id
}

position()
{
    window=$3
    geo=$(xdotool getwindowgeometry $window)
    srcX=$(echo "$geo" | awk '/Position:/ {print $2}' | cut -d ',' -f1)
    srcY=$(echo "$geo" | awk '/Position:/ {print $2}' | cut -d ',' -f2)
    trgX=$1
    trgY=$2
    while [ "$srcX" != "$trgX" ] || [ "$srcY" != "$trgY" ]; do
        if [ "$srcX" -lt "$trgX" ]; then
            i3-msg move right > /dev/null
        elif [ "$srcX" -gt "$trgX" ]; then
            i3-msg move left > /dev/null
        fi
        if [ "$srcY" -lt "$trgY" ]; then
            i3-msg move down > /dev/null
        elif [ "$srcY" -gt "$trgY" ]; then
            i3-msg move up > /dev/null
        fi

        geo=$(xdotool getwindowgeometry $window)
        srcX=$(echo "$geo" | awk '/Position:/ {print $2}' | cut -d ',' -f1)
        srcY=$(echo "$geo" | awk '/Position:/ {print $2}' | cut -d ',' -f2)
        sleep 0.1
    done
}

echo -e "\e]2;$title\007"
i3-msg [title=$title] move container to workspace "VSCode" > /dev/null
instances=($(pstree | grep -oP '[| \\/-]*\s+\K\d+(?=\s+\w+\s+.*[/]vscode/code --type=renderer)'))
code --new-window "$1"
sleep 0.3

window_after=$(xdotool search --onlyvisible --class "Code")
vs_id=$window_after
for id in $window_after; do
    if [[ ! $window_before =~ $id ]]; then
        vs_id=$id
        break
    fi
done

all=($(pstree | grep -oP '[| \\/-]*\s+\K\d+(?=\s+\w+\s+.*[/]vscode/code --type=renderer)'))

if [[ ${#instances[@]} == ${#all[@]} || ${#all[@]} -eq 0 ]]; then
    close $targetX $targetY
fi

vscode_pid=$all
for pid in $all; do
    if [[ ! $instances =~ $pid ]]; then
        vscode_pid=$pid
        break
    fi
done

position $targetX $targetY $vs_id

while ps -p $vscode_pid > /dev/null; do
    vs_geo=$(xdotool getwindowgeometry $vs_id)
    if [ $? -ne 0 ]
    then
        break;
    fi
    current_workspace=$(i3-msg -t get_workspaces | jq '.[] | select(.focused==true) | .num' 2> /dev/null);
    vsX=$(echo "$vs_geo" | awk '/Position:/ {print $2}' | cut -d ',' -f1)
    vsY=$(echo "$vs_geo" | awk '/Position:/ {print $2}' | cut -d ',' -f2)
    sleep 0.1
done

close $vsX $vsY
