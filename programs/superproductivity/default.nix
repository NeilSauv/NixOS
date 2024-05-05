{ pkgs, lib, ... }:

let
  # Chemin local vers l'icône dans le répertoire du fichier Nix
  localIconPath = ./superproductivity.png;

  # Création d'un paquet pour copier l'icône
  superProductivityIcon = pkgs.runCommand "superproductivity-icon" {} ''
    mkdir -p $out/share/icons
    cp ${localIconPath} $out/share/icons/superproductivity.png
  '';

  # Wrapper pour lancer Super Productivity
  superProductivityWrapper = pkgs.writeShellScriptBin "superproductivity" ''
    #!${pkgs.runtimeShell}
    exec appimage-run ${pkgs.fetchurl {
      url = "https://github.com/johannesjo/super-productivity/releases/download/v8.0.1/superProductivity-8.0.1.AppImage";
      sha256 = "056ff88cfe2587795e01c772dc91c44ff3d4c9b37ed02cbdc313128b9edd01cc";
    }}
  '';

in
{
  home.packages = [ superProductivityWrapper superProductivityIcon ];

  home.activation.createDesktopEntry = lib.hm.dag.entryAfter [ "writeBoundary" ] ''
    mkdir -p $HOME/.local/share/applications
    cat >$HOME/.local/share/applications/superproductivity.desktop <<EOF
    [Desktop Entry]
    Name=SuperProductivity
    Exec=${superProductivityWrapper}/bin/superproductivity
    Type=Application
    Terminal=false
    Icon=${superProductivityIcon}/share/icons/superproductivity.png
    Categories=Office;
    EOF
  '';
}
