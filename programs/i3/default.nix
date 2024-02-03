
{ pkgs, lib, ... }:

let
  wallpaper = "/$HOME/.dotfiles/wallpaper/wallpaper.jpg";
in
{
  programs.i3status.enable = true;

  xsession = {
    enable = true;

    windowManager.i3 = {
      enable = true;

      extraConfig = ''
        workspace_auto_back_and_forth yes
        popup_during_fullscreen smart

        for_window [class="^.*"] border pixel 1
        for_window [title="^.*"] border pixel 1

        for_window [class="feh"] floating enable
        for_window [class="Pavucontrol"] floating enable

        workspace 1 output HDMI-A-1
        workspace 9 output DisplayPort-0
        workspace 10 output HDMI-A-0
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

          "${modifier}+Shift+h" = "move left";
          "${modifier}+Shift+j" = "move down";
          "${modifier}+Shift+k" = "move up";
          "${modifier}+Shift+l" = "move right";

          "${modifier}+v" = "split v";
          "${modifier}+f" = "fullscreen toggle";
          "${modifier}+ctrl+space" = "floating toggle";
          "${modifier}+Shift+a" = "kill";
          "${modifier}+Shift+e" = "exec i3-nagbar -t warning -m 'Do you want to exit i3?' -b 'Yes' 'i3-msg exit'";
          "${modifier}+Shift+c" = "reload";
          "${modifier}+Shift+r" = "restart";

          "${modifier}+s" = "layout stacking";
          "${modifier}+z" = "layout tabbed";
          "${modifier}+e" = "layout toggle split";
          "${modifier}+r" = "mode resize";

          # Screenshot
          # Copy to clipboard
          "Print"                = "exec --no-startup-id flameshot gui -c";
          # save in Pictures folder
          "Ctrl+Print"           = "exec --no-startup-id flameshot gui -p \"/$HOME/Pictures/\"";

          "${modifier}+d"       = "exec --no-startup-id dmenu_run";
        };

        startup = [
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
            command = "${pkgs.feh}/bin/feh --bg-fill ${wallpaper}";
            always = true;
            notification = false;
          }
          {
            command = "xrandr --output HDMI-A-0 --mode 1920x1080 && xrandr --output DisplayPort-0 --mode 1280x1024 --auto --output HDMI-A-1 --auto --right-of DisplayPort-0 --output HDMI-A-0 --right-of HDMI-A-1 && xrandr --output DP-1 --mode 1280x1024 --auto --output HDMI-2 --auto --right-of DP-1 --output HDMI-1 --right-of HDMI-2";
            always = true;
            notification = false;
          }
        ];

        bars = [
          #{
          #  statusCommand = "${pkgs.i3status}/bin/i3status";
          #  position = "bottom";
          #}
        ];

        gaps = {
          top = 40;
          inner = 12;
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
