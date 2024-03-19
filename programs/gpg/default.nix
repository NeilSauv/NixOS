{ pkgs, ... }:

{
  programs.gpg = {
    enable = true;
  };

  services.gpg-agent = {
    enable = true;
    pinentryPackage = pkgs.pinentry-gtk2;
    extraConfig = ''
      default-cache-ttl 3600
      max-cache-ttl 86400
    '';
  };
}

