
{ pkgs, lib, ... }:

let
wallpaper = "/$HOME/.dotfiles/wallpaper/wallpaper.jpg";
wallpaper_lock = "/$HOME/.dotfiles/wallpaper/wallpaper_lock.jpg";
workspaceScript = "/$HOME/.dotfiles/programs/i3/workspace_per_monitor.sh";
workspaceScriptReturn = "/$HOME/.dotfiles/programs/i3/workspace_per_monitor_target.sh";
workspaceScriptInit = "/$HOME/.dotfiles/programs/i3/workspace_init.sh";
in
{
    programs.i3status.enable = true;

    xsession = {
        enable = true;

        windowManager.i3 = {
            enable = true;

            extraConfig = ''
                workspace_auto_back_and_forth no
                popup_during_fullscreen smart

                for_window [class="^.*"] border pixel 1
                for_window [title="^.*"] border pixel 1

                for_window [class="feh"] floating enable
                for_window [class="Pavucontrol"] floating enable

                exec --no-startup-id ${workspaceScriptInit}
                exec --no-startup-id numlockx on
                exec-always --no-startup-id xset r rate 150 25
                '';

            config = rec {
                modifier = "Mod4";
                keybindings = lib.mkOptionDefault {
                    XF86AudioPlay          = "exec ${pkgs.playerctl}/bin/playerctl play";
                    XF86AudioPause         = "exec ${pkgs.playerctl}/bin/playerctl play-pause";
                    XF86AudioStop          = "exec ${pkgs.playerctl}/bin/playerctl stop";
                    XF86AudioNext          = "exec ${pkgs.playerctl}/bin/playerctl next";
                    XF86AudioPrev          = "exec ${pkgs.playerctl}/bin/playerctl previous";
                    XF86AudioLowerVolume   = "exec amixer -q sset Master 5%-";
                    XF86AudioRaiseVolume   = "exec amixer -q sset Master 5%+";
                    XF86AudioMute          = "exec amixer -q sset Master toggle";

                    XF86MonBrightnessUp    = "exec light -A 5%";
                    XF86MonBrightnessDown  = "exec light -U 5%";

                    "${modifier}+Return"        = "exec ${pkgs.alacritty}/bin/alacritty";
                    "${modifier}+Shift+s"       = "exec --no-startup-id maim -s | xclip -selection clipboard -t image/png";

                    "${modifier}+h" = "focus left";
                    "${modifier}+j" = "focus down";
                    "${modifier}+k" = "focus up";
                    "${modifier}+l" = "focus right";

                    "${modifier}+1" = "exec --no-startup-id ${workspaceScript} 1";
                    "${modifier}+2" = "exec --no-startup-id ${workspaceScript} 2";
                    "${modifier}+3" = "exec --no-startup-id ${workspaceScript} 3";
                    "${modifier}+4" = "exec --no-startup-id ${workspaceScript} 4";
                    "${modifier}+5" = "exec --no-startup-id ${workspaceScript} 5";
                    "${modifier}+6" = "exec --no-startup-id ${workspaceScript} 6";
                    "${modifier}+7" = "exec --no-startup-id ${workspaceScript} 7";
                    "${modifier}+8" = "exec --no-startup-id ${workspaceScript} 8";
                    "${modifier}+9" = "exec --no-startup-id ${workspaceScript} 9";
                    "${modifier}+0" = "exec --no-startup-id ${workspaceScript} 10";
                    "${modifier}+Shift+1" = "exec --no-startup-id sh -c 'wk=$(${workspaceScriptReturn} 1) && i3-msg move container to workspace number $wk'";
                    "${modifier}+Shift+2" = "exec --no-startup-id sh -c 'wk=$(${workspaceScriptReturn} 2) && i3-msg move container to workspace number $wk'";
                    "${modifier}+Shift+3" = "exec --no-startup-id sh -c 'wk=$(${workspaceScriptReturn} 3) && i3-msg move container to workspace number $wk'";
                    "${modifier}+Shift+4" = "exec --no-startup-id sh -c 'wk=$(${workspaceScriptReturn} 4) && i3-msg move container to workspace number $wk'";
                    "${modifier}+Shift+5" = "exec --no-startup-id sh -c 'wk=$(${workspaceScriptReturn} 5) && i3-msg move container to workspace number $wk'";
                    "${modifier}+Shift+6" = "exec --no-startup-id sh -c 'wk=$(${workspaceScriptReturn} 6) && i3-msg move container to workspace number $wk'";
                    "${modifier}+Shift+7" = "exec --no-startup-id sh -c 'wk=$(${workspaceScriptReturn} 7) && i3-msg move container to workspace number $wk'";
                    "${modifier}+Shift+8" = "exec --no-startup-id sh -c 'wk=$(${workspaceScriptReturn} 8) && i3-msg move container to workspace number $wk'";
                    "${modifier}+Shift+9" = "exec --no-startup-id sh -c 'wk=$(${workspaceScriptReturn} 9) && i3-msg move container to workspace number $wk'";
                    "${modifier}+Shift+0" = "exec --no-startup-id sh -c 'wk=$(${workspaceScriptReturn} 10) && i3-msg move container to workspace number $wk'";

                    "${modifier}+Shift+h" = "move left";
                    "${modifier}+Shift+j" = "move down";
                    "${modifier}+Shift+k" = "move up";
                    "${modifier}+Shift+l" = "move right";

                    "${modifier}+v" = "split v";
                    "${modifier}+f" = "fullscreen toggle";
                    "${modifier}+ctrl+space" = "floating toggle";
                    "${modifier}+Shift+a" = "kill";
                    "${modifier}+Shift+e" = "exec i3lock -t warning -m 'Do you want to exit i3?' -b 'Yes' 'i3-msg exit'";
                    "${modifier}+Shift+c" = "reload";
                    "${modifier}+Shift+r" = "restart";

                    "${modifier}+s" = "layout stacking";
                    "${modifier}+z" = "layout tabbed";
                    "${modifier}+e" = "layout toggle split";
                    "${modifier}+d" = "exec ~/.nixsave/launcherPath.sh";
                    "${modifier}+r" = "mode resize";
                    "${modifier}+b" = "exec i3lock-color -i ${wallpaper_lock} -F --clock -S 0 --indicator --inside-color=ffffff11 ";
                    "Print"                = "exec --no-startup-id flameshot gui -c";
                    "Ctrl+Print"           = "exec --no-startup-id flameshot gui -p \"/$HOME/Pictures/\"";

                };

                startup = [
                {
                    command = "xrandr --output HDMI-A-0 --mode 1920x1080 && xrandr --output DisplayPort-0 --mode 1280x1024 --auto --output HDMI-A-1 --auto --right-of DisplayPort-0 --output HDMI-A-0 --right-of HDMI-A-1 && xrandr --output DP-1 --mode 1280x1024 --auto --output HDMI-2 --auto --right-of DP-1 --output HDMI-1 --right-of HDMI-2";
                    always = false;
                    notification = false;
                }
                {
                    command = "~/.dotfiles/programs/polybar/scripts/launch.sh";
                    always = true;
                    notification = false;
                }
                {
                    command = "${pkgs.networkmanagerapplet}/bin/nm-applet";
                    always = true;
                }
                {
                    command = "bash -c 'sleep 1; ${pkgs.picom}/bin/picom'";
                    always = false;
                    notification = false;
                }
                {
                    command = "${pkgs.feh}/bin/feh --bg-fill ${wallpaper}";
                    always = true;
                    notification = false;
                }

                {
                    command = "${pkgs.ckb-next}/bin/ckb-next --background"; 
                    always = false;
                    notification = false;
                }

                ];

                bars = [
                ];

                gaps = {
                    top = 40;
                    inner = 6;
                    outer = 0;
                    smartBorders = "on";
                    smartGaps = false;
                };

                window = {
                    hideEdgeBorders = "smart";
                };
            };
        };
    };
}
