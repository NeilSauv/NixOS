{ pkgs, lib, ... }:

let
  makeWebApp = { name, url, iconName }:
    let
      iconPath = pkgs.runCommand "${name}-icon" {} ''
        mkdir -p $out/share/icons
        cp ${iconName} $out/share/icons/${name}.png
      '';

      appWrapper = pkgs.writeShellScriptBin name ''
        #!${pkgs.runtimeShell}
        exec ${pkgs.google-chrome}/bin/google-chrome-stable --app=${url}
      '';

    in {
      icon = iconPath;
      wrapper = appWrapper;
      desktopEntry = ''
        mkdir -p $HOME/.local/share/applications
        cat >$HOME/.local/share/applications/${name}.desktop <<EOF
        [Desktop Entry]
        Name=${name}
        Exec=${appWrapper}/bin/${name}
        Type=Application
        Terminal=false
        Icon=${iconPath}/share/icons/${name}.png
        Comment=${name} Web Application
        Categories=Office;Productivity;
        EOF
      '';
    };

  webApps = [
    { name = "Notion"; url = "https://www.notion.so"; iconName = ./notion.png; }
    { name = "ChatGPT"; url = "https://chat.openai.com"; iconName = ./chatgpt.png; }
    { name = "Quizlet"; url = "https://quizlet.com"; iconName = ./quizlet.png; }
  ];

  apps = lib.lists.foldl' (acc: app: acc // { "${app.name}" = makeWebApp app; }) {} webApps;

in
{
  home.packages = with apps; lib.attrValues (lib.mapAttrs (_: app: app.wrapper) apps);

  home.activation.createDesktopEntries = lib.strings.concatStringsSep "\n" (lib.attrValues (lib.mapAttrs (_: app: app.desktopEntry) apps));
}
