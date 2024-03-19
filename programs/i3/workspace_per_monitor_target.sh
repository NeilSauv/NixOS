#!/bin/sh

# Chemin du fichier cache
cache_file="/tmp/active_output_cache"

workspace_requested=$1
if [ "$workspace_requested" = "0" ]; then
    workspace_requested="10"
fi

eval $(xdotool getmouselocation --shell)

# Création du cache s'il n'existe pas
if [ ! -f "$cache_file" ]; then
    save=$(xrandr --query | grep ' connected')
    echo "$active_output" > "$cache_file"
else
    save=$(cat "$cache_file")
fi

active_output=$(echo "$save" | awk -v x=$X -v y=$Y '{
name = $1;
$0 = $0; # Recalcule $0 pour appliquer le changement de FS
match($0, /[0-9]+x[0-9]+\+[0-9]+\+[0-9]+/);
dimensions_positions = substr($0, RSTART, RLENGTH);
split(dimensions_positions, dp, /[x+]/);

width = dp[1];
height = dp[2];
offset_x = dp[3];
offset_y = dp[4];

if (x >= offset_x && x <= offset_x + width && y >= offset_y && y <= offset_y + height) {
    print name;
    exit;
}
}')

output_order=$(echo "$save" | awk '{print $1}' | sort | awk -v active_output="$active_output" '{
if ($0 == active_output) {
    print NR;
    exit;
}
}')

base=$(($output_order - 1))
target_workspace=$((base * 10 + workspace_requested))

echo $target_workspace
