{ ... }:

{
  programs.gpg = {
    enable = true;
  };

  services.gpg-agent = {
    enable = true;
    pinentryFlavor = "gtk2";
    extraConfig = ''
      default-cache-ttl 3600
      max-cache-ttl 86400
    '';
  };
}

