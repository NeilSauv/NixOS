{ config, pkgs, ... }:

{
  imports =
    [
      ./hardware-configuration.nix
    ];

    nix = {
      package = pkgs.nixFlakes;
      extraOptions = ''
          experimental-features = nix-command flakes
      '';
    };

    boot.kernelModules = [ "nvidia" "nvidia_uvm" "nvidia_modeset" "nvidia_drm" "bbswitch" "vboxdrv" "vboxnetflt" "vboxnetadp" ];


    nixpkgs.config.allowBroken = true;
    nixpkgs.config.allowUnfree = true;
    nixpkgs.config.nvidia.acceptLicense = true;

    networking.firewall = {
      enable = true;
      allowedTCPPorts = [ 2409 ]; # Liste des ports TCP autorisés
      allowedUDPPorts = [ 2409 ]; # Liste des ports UDP autorisés, si nécessaire
    };

    system.autoUpgrade.enable = false;
    system.autoUpgrade.allowReboot = false;

    boot.loader.systemd-boot.enable = true;
    boot.loader.efi.canTouchEfiVariables = true;
    virtualisation.virtualbox.host.enable = true;

    networking.hostName = "nixos";
    networking.networkmanager.enable = true;

    boot.plymouth.enable = true;
    time.timeZone = "Europe/Paris";

    i18n.defaultLocale = "en_US.UTF-8";
    i18n.extraLocaleSettings = {
      LC_ADDRESS = "fr_FR.UTF-8";
      LC_IDENTIFICATION = "fr_FR.UTF-8";
      LC_MEASUREMENT = "fr_FR.UTF-8";
      LC_MONETARY = "fr_FR.UTF-8";
      LC_NAME = "fr_FR.UTF-8";
      LC_NUMERIC = "fr_FR.UTF-8";
      LC_PAPER = "fr_FR.UTF-8";
      LC_TELEPHONE = "fr_FR.UTF-8";
      LC_TIME = "fr_FR.UTF-8";
    };
    environment.systemPackages = with pkgs; [ mesa glfw ];
    hardware.opengl = {
      enable = true;
      driSupport32Bit = true;
      extraPackages = with pkgs; [ mesa ];
    };

    hardware.bluetooth.enable = true;
    hardware.enableRedistributableFirmware = true;

    services.logind.extraConfig = ''
      HandlePowerKey=suspend
    '';
    services.gvfs.enable = true;
    services.printing.enable = true;
    services.blueman.enable = true;
    services.pipewire = {
      enable = true;
      alsa.enable = true;
      alsa.support32Bit = true;
      pulse.enable = true;
    };

    console = {
      keyMap = "us";
      font = "Lat2-Terminus16";
    };

    sound.enable = true;

    security.rtkit.enable = true;

    boot.kernelPackages = pkgs.linuxPackages_latest;

    users.users.USER_NAME = {
      isNormalUser = true;
      description = "USER_MAJ";
      extraGroups = [ "networkmanager" "wheel" "video" "vboxusers" ];
    };

    users.extraGroups.vboxusers.members = [ "USER_NAME" ];

    environment.pathsToLink = [ "/libexec" ];

    programs.light.enable = true;
    services.displayManager.defaultSession = "none+i3";

    services.xserver = {
      enable = true;
      displayManager.lightdm.enable = true;
      displayManager.lightdm.autoLogin.enable = false;
      desktopManager.xterm.enable = false;
      displayManager.lightdm.extraConfig = ''
        [Seat:*]
        lock-session-suspend = true
        '';
      windowManager.i3.enable = true;
      xkb.layout = "us";
    };



    services.openssh.enable = true;

    system.stateVersion = "23.05";

    systemd.services.ckb-next-daemon = {
      description = "ckb-next daemon for Corsair keyboards and mice";
      after = [ "network.target" ];
      wantedBy = [ "multi-user.target" ];
      serviceConfig = {
        ExecStart = "${pkgs.ckb-next}/bin/ckb-next-daemon";
        Restart = "always";
        User = "root";
        Group = "root";
      };
      enable = true;
    };
  }
