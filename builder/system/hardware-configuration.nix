{ config, lib, pkgs, modulesPath, ... }:

{
  imports =
    [ (modulesPath + "/installer/scan/not-detected.nix")
    ];

  boot.initrd.availableKernelModules = [ "nvme" "xhci_pci" "usbhid" "uas" "usb_storage" "sd_mod" ];
  boot.initrd.kernelModules = [ ];
  boot.kernelModules = [ "kvm-amd"
  ];
  boot.extraModulePackages = [ ];
  boot.blacklistedKernelModules = [];
  fileSystems."/" =
    { device = "/dev/disk/by-uuid/UUID_EXT4";
      fsType = "ext4";
    };

  fileSystems."/boot" =
    { device = "/dev/disk/by-uuid/UUID_VFAT";
      fsType = "vfat";
    };

  swapDevices =
    [ { device = "/dev/disk/by-uuid/UUID_SWAP"; }
    ];

  networking.useDHCP = lib.mkDefault true;

  nixpkgs.hostPlatform = lib.mkDefault "x86_64-linux";
  hardware.cpu.amd.updateMicrocode = lib.mkDefault config.hardware.enableRedistributableFirmware;
}
