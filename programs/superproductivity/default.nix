{ pkgs, lib, ... }:

let
  superProductivityWrapper = pkgs.writeShellScriptBin "superproductivity" ''
    #!${pkgs.runtimeShell}
    exec appimage-run ${pkgs.fetchurl {
      url = "https://github.com/johannesjo/super-productivity/releases/download/v7.15.0/superProductivity-7.15.0.AppImage";
      sha256 = "3911006833f9827f7c8dd6c24578248d9cb496f7f08e0fe0f86a53c4dea0d176";
    }}
  '';

in
{
  home.packages = [ superProductivityWrapper ];

  home.activation.createDesktopEntry = lib.hm.dag.entryAfter [ "writeBoundary" ] ''
    mkdir -p $HOME/.local/share/applications
    cat >$HOME/.local/share/applications/superproductivity.desktop <<EOF
    [Desktop Entry]
    Name=SuperProductivity
    Exec=${superProductivityWrapper}/bin/superproductivity
    Type=Application
    Terminal=false
    Icon=superproductivity
    Categories=Office;
    EOF
  '';
}

