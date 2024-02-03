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
    libxcrypt
    nodejs
    vim
    nix-ld
    bat
    ncurses
    nix-index
    qemu
    valgrind
    glibc
    clipman
    bison
    python38
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
    postgresql
    python3Packages.pygments
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
    picom
    dmenu

    #sound
    pavucontrol
    playerctl
    gparted

    #misc
    nerdfonts
    roboto
    ];

  fonts.fontconfig.enable = true;

  programs = {
    home-manager.enable = true;
  }; 

  systemd.user.services.polybar = {
    Install.WantedBy = [ "graphical-session.target" ];
    Service.Environment = lib.mkForce ""; # to override the package's default configuration
    Service.PassEnvironment = "PATH"; # so that the entire PATH is passed to this service (alternatively, you can import the entire PATH to systemd at startup, which I'm not sure is recommended
  };

  home.file = {
  };

  home.sessionVariables = {
    EDITOR = "vim";
  };
}
