{pkgs, ...}: {
  home.file = {
    ".config/picom/picom.conf".source = ../../programs/picom/picom.conf;

  };
}
