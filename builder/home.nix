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
            flatpak
            numlockx
            docker
            bear
            lsof
            direnv
            jupyter
            xdotool
            jetbrains.idea-ultimate
            libxcrypt
            i3lock-color
            dunst
            nodejs
            libnotify
            netcat
            imagemagick
            nix-ld
            bat
            openjdk17
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
            virtualbox
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
#wine
#android-studio
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
        EDITOR = "vim";
        JAVA_HOME = "${pkgs.openjdk17}";
    };

}
