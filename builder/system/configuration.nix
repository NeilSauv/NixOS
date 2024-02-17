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

    hardware.opengl.enable = true;
    hardware.opengl.driSupport32Bit = true;

    boot.blacklistedKernelModules = [ "kvm_amd" ];

    boot.loader.systemd-boot.enable = true;
    boot.loader.efi.canTouchEfiVariables = true;
    boot.kernelModules = [ "vboxdrv" "vboxnetflt" "vboxnetadp" "amdgpu" ];
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

    services.gvfs.enable = true;

    console = {
        keyMap = "us";
        font = "Lat2-Terminus16";
    };

    services.printing.enable = true;

    sound = {
        enable = true;
    };

    hardware.bluetooth.enable = true;
    security.rtkit.enable = true;
    services.blueman.enable = true;

    services.pipewire = {
        enable = true;
        alsa.enable = true;
        alsa.support32Bit = true;
        pulse.enable = true;
    };

    users.users.USER_NAME = {
        isNormalUser = true;
        description = "USER_MAJ";
        extraGroups = [ "networkmanager" "wheel" "video" "vboxusers"];
        packages = with pkgs; [
        ];
    };

    users.users.dev = {
        isNormalUser = true;
        description = "Dev";
        home = "/home/dev";
        shell = pkgs.bash;
        extraGroups = [ "networkmanager" "wheel" "video" "vboxusers"];
        packages = with pkgs; [
        ];
    };


    nixpkgs.config.allowUnfree = true;
    hardware.cpu.amd.updateMicrocode = true;
    hardware.enableRedistributableFirmware = true;
    boot.kernelPackages = pkgs.linuxPackages_latest;

    users.extraGroups.vboxusers.members = [ "USER_NAME" ];

    environment.systemPackages = with pkgs; [
    ];

    environment.pathsToLink = [ "/libexec" ];

    programs.light.enable = true;

    services.xserver = {

        enable = true;
        layout = "us";
        videoDrivers = [ "amdgpu" ];
        xkbVariant = "";

        desktopManager = {
            xterm.enable = false;
        };

        displayManager = {
            lightdm.enable = true;
            defaultSession = "none+i3";
        };
        windowManager.i3.enable = true;

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
    };

    systemd.services.ckb-next-daemon.enable = true;

}
