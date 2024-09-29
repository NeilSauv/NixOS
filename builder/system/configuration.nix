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

    boot.kernelModules = [ "xhci_hcd" "usb_storage" "nvme"];

    hardware.enableAllFirmware = true;  # Active tous les firmwares disponibles
    hardware.firmware = [ pkgs.linux-firmware ];
    services.udev.extraRules = ''
      ACTION=="add", SUBSYSTEM=="block", KERNEL=="nvme*", ATTR{queue/scheduler}="none"
    '';

    nixpkgs.config.allowBroken = true;
    nixpkgs.config.allowUnfree = true;

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
    environment.systemPackages = with pkgs; [ mesa glfw tigervnc ];

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

    users.users.USER_NAME = {
      isNormalUser = true;
      description = "USER_MAJ";
      extraGroups = [ "networkmanager" "wheel" "video" "vboxusers" ];
    };

    users.extraGroups.vboxusers.members = [ "USER_NAME" ];

    environment.pathsToLink = [ "/libexec" ];

    programs.light.enable = true;
    services.displayManager.defaultSession = "none+i3";

    services.displayManager.autoLogin.enable = false;
    services.xserver = {
      enable = true;
      displayManager.lightdm.enable = true;
      desktopManager.xterm.enable = false;
      displayManager.lightdm.extraConfig = ''
        [Seat:*]
        lock-session-suspend = true
      '';
      windowManager.i3.enable = true;
      xkb.layout = "us";
      xkb.options = "caps:escape";
    };

    services.openssh.enable = true;

    # Configuration du serveur VNC
    systemd.user.services.vncserver = {
      enable = true;
      description = "TigerVNC Server";
      serviceConfig = {
        ExecStart = "${pkgs.tigervnc}/bin/vncserver :1 -localhost -geometry 1920x1080 -depth 24";
        ExecStop = "${pkgs.tigervnc}/bin/vncserver -kill :1";
        Restart = "on-failure";
      };
      wantedBy = [ "default.target" ];
    };

    # Exécute un script personnalisé pour démarrer l'environnement de bureau VNC
    systemd.user.services.vnc-xstartup = {
      enable = true;
      description = "VNC xstartup script";
      serviceConfig = {
        ExecStart = "${pkgs.bash}/bin/bash -c 'if [ ! -f $HOME/.vnc/xstartup ]; then echo \"#!/usr/bin/env bash\\nexec i3\" > $HOME/.vnc/xstartup; chmod +x $HOME/.vnc/xstartup; fi'";
      };
      wantedBy = [ "default.target" ];
    };

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
