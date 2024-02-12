#!/bin/sh

work_mode_file="/tmp/work_mode_state"

function toggle_work() {
    if [[ $(cat "$work_mode_file") == "OFF" ]]; then
        dunstify "Work Mode" "Work Mode: ON" --icon=dialog-information
        echo "ON" > "$work_mode_file"
        echo ""
    else
        dunstify "Work Mode" "Work Mode: OFF" --icon=dialog-information
        echo "OFF" > "$work_mode_file"
        echo ""
    fi
}

function check_work() {
    if [[ $(cat "$work_mode_file") == "OFF" ]]; then
        echo ""
    else
        echo ""
    fi
}

if [[ ! -f "$work_mode_file" ]]; then
    echo "OFF" > "$work_mode_file"
fi

if [[ "$1" = "toggle" ]]; then
    toggle_work
else
    check_work
fi

