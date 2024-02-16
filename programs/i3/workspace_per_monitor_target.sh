#!/bin/sh
workspace_requested=$1
if [ $workspace_requested = "0" ]
then
    workspace_requested="10"
fi

eval $(xdotool getmouselocation --shell)

active_output=$(xrandr --query | grep ' connected' | awk -v x=$X -v y=$Y '{
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

output_order=$(xrandr --query | grep ' connected' | awk '{print $1}' | sort | awk -v active_output="$active_output" '{
  if ($0 == active_output) {
    print NR;
    exit;
  }
}')

# Calcul de la base pour le workspace (10 workspaces par écran, décalage par écran)
base=$(($output_order - 1))
target_workspace=$((base * 10 + workspace_requested))
echo $target_workspace
