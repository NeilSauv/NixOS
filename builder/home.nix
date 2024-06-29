{ config, pkgs, lib, ... }:

{

    imports = [
        ../../programs
    ]; 


# Home Manager needs a bit of information about you and the paths it should
# manage.
    home.username = "USER_NAME";
    home.homeDirectory = "/home/USER_NAME";
    home.stateVersion = "23.05"; # Do not change value.

# The home.packages option allows you to install Nix packages into your
# environment.
        home.packages = with pkgs; [
        google-chrome
            texlive.combined.scheme-basic
            sbt
            wine
            rstudio
            nsis
            android-tools
            android-studio
            ovftool
            sway
            wayland
            wireshark
            openjdk17
            waybar
            wofi
            xorg.xhost
            pstree
            patchelf
            nix-index
            steam-run
            libreoffice-fresh
            saleae-logic-2
            docker
            nextcloud-client
            xdotool
            yara
            nextcloud29
            openvpn
            jq
            cglm
            python3.pkgs.ipykernel
            virtualbox
            vscode
            yarn
            burpsuite
            gimp
            numlockx
            glfw
            mesa
            bear
            lsof
            direnv
            jupyter
            xdotool
            libxcrypt
            i3lock-color
            dunst
            jetbrains.idea-ultimate
            nodejs
            libnotify
            netcat
            imagemagick
            bat
            libtool
            maven
            ncurses
            nix-index
            qemu
            keychain
            valgrind
            glibc
            clipman
            bison
            htop
            clang-tools
            man-pages-posix
            man-pages
            graphviz
            autoconf
            doxygen
            criterion
            gcc
            automake
            gdb
            ghc
            sbcl
            ckb-next
            man-db
            sqlfluff
            udisks2
            stdenv
            glibc
            udev
            usbutils
            pkg-config
            krb5
            xclip
            sshfs
            maim
            libthai
            wget
            neofetch
            feh
            binutils
            file
            tree
            zip
            unzip
            patchelf
            pciutils
            flameshot
            unrar
            findutils
            ntfs3g
            p7zip
#command line env

#dev
            gnome3.nautilus
            gnupg
            appimage-run
            pinentry
            gcc
            gnumake
            cmake
            docker-compose
            inxi
            gedit

#desktop
            firefox
            spotify
            rofi-bluetooth
            rofi-power-menu
            rofi-systemd
            rofi-pulse-select
            networkmanager_dmenu
            killall
            discord
            postgresql
            picom
            dmenu

#sound
            pavucontrol
            playerctl
            gparted

#misc
            nerdfonts
            roboto

#Secu
            ghidra
            radare2
            ];

    fonts.fontconfig.enable = true;

    programs = {
        home-manager.enable = true;
    };

    systemd.user.services.polybar = {
        Install.WantedBy = [ "graphical-session.target" ];
        Service.Environment = lib.mkForce "";
        Service.PassEnvironment = "PATH";
    };

    home.file = {
    };

    home.sessionVariables = {
        JAVA_HOME = "${pkgs.openjdk22}";
        EDITOR = "code";
    };

}
