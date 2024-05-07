{ pkgs, ... }:
{
  programs.zsh = {
    enable = true;
    autosuggestion.enable = true;
    enableCompletion = true;
    syntaxHighlighting.enable = true;

    plugins = [
      {
        name = "zsh-syntax-highlighting";
        src = pkgs.fetchFromGitHub {
          owner = "zsh-users";
          repo = "zsh-syntax-highlighting";
          rev = "754cefe0181a7acd42fdcb357a67d0217291ac47";
          sha256 = "kWgPe7QJljERzcv4bYbHteNJIxCehaTu4xU9r64gUM4=";
        };
      }
    ];

    shellAliases = {
      ll = "ls -l";
      lsa = "ls -lah";
    };

    oh-my-zsh = {
      enable = true;

      custom = "$HOME/extra/zsh";
      theme = "sigma";

      plugins = [
        "git"
      ];
    };

    initExtra = ''
        if [[ ":$PATH:" != *":/nix/store/vd679zh0i8vdixl7d0f65yvsq5nmr50h-home-manager-path/bin:"* ]]; then
            export PATH="/nix/store/vd679zh0i8vdixl7d0f65yvsq5nmr50h-home-manager-path/bin:$PATH"
        fi
        alias srt='~/.dotfiles/tools/utils/gccRunProg.sh'
        alias grep='grep --color -n'
        alias ccat='pygmentize -f terminal -g'
        alias epita='cd ~/EPITA/Cours/S6'
        alias lss='tail -n +1 *'
        alias rtc='~/.dotfiles/tools/utils/rtc -o result *.tig; ./result'
        alias tools='cd ~/.dotfiles/tools/utils'
        alias nixvim='vs ~/.dotfiles/programs/vim/default.nix'
        alias screen='xrandr --output HDMI-A-0 --mode 1920x1080 && xrandr --output DisplayPort-0 --mode 1280x1024 --auto --output HDMI-A-1 --auto --right-of DisplayPort-0 --output HDMI-A-0 --right-of HDMI-A-1 && xrandr --output DP-1 --mode 1280x1024 --auto --output HDMI-2 --auto --right-of DP-1 --output HDMI-1 --right-of HDMI-2'
        alias cpy='~/.dotfiles/tools/utils/copy.sh'
        alias pst='~/.dotfiles/tools/utils/paste.sh'
        alias xcut='~/.dotfiles/tools/utils/xcut.sh'
        alias rm='~/.dotfiles/tools/utils/rm.sh'
        alias recover='~/.dotfiles/tools/utils/recover.sh'
        alias trashclean='~/.dotfiles/tools/utils/trashclean.sh'
        alias cm='git commit -m "commit"; git tag -m tag -a '
        alias update='~/.dotfiles/apply-user.sh USER_NAME && up'
        alias cleanupdate='~/.dotfiles/apply-user.sh USER_NAME -d && up'
        alias up='source ~/.zshrc'
        alias sysupdate='sudo ~/.dotfiles/apply-system.sh USER_NAME'
        alias nixconfig='vs ~/.dotfiles/builder/system/configuration.nix'
        alias initclangc='cp ~/.dotfiles/tools/utils/clang-format-c .clang-format'
        alias dwn='cd ~/Downloads'
        alias prg='cd ~/.dotfiles/programs/'
        alias mk='clear; make'
        alias nixsh='vs ~/.dotfiles/builder/zsh.nix'
        alias vs='~/.dotfiles/tools/utils/vscode.sh'
        alias dtf='cd ~/.dotfiles'
        alias nixi3='vs ~/.dotfiles/programs/i3/default.nix'
        alias nixhome='vs ~/.dotfiles/builder/home.nix'
        alias val='valgrind --leak-check=full --show-leak-kinds=all --track-origins=yes'
        alias setdir='~/.dotfiles/tools/utils/setdir.sh'
        alias ddir='. ~/.dotfiles/tools/utils/ddir.sh'
        alias makeinitc='cp ~/.dotfiles/tools/utils/Makefilec Makefile'
        alias makeinitcpp='cp ~/.dotfiles/tools/utils/Makefilecpp Makefile'
        alias sf='sqlfluff lint --dialect postgres'

        alias quizlet=google-chrome-stable --app="https://quizlet.com"
        alias moodle=google-chrome-stable --app="https://moodle.epita.fr/"
        alias chatgpt=google-chrome-stable --app="https://chat.openai.com/"
        alias afsinit=~/.dotfiles/tools/afs/install.sh
        alias afs=~/afs
        alias dev='mv .git .gitsave; nix develop; mv .gitsave .git'

        alias launcherManager=~/.config/rofi/launchers/find_launcher.sh

        export CFLAGS='-Wall -Wextra -Wvla -std=c99 -pedantic -Werror -g'
        export CXX='g++'
        export FS='-fsanitize=address'

        setxkbmap -option caps:escape
        export PGDATA="$HOME/postgres_data"
        export PGHOST="/tmp"
        export NAME_USER="USER_NAME"

        if [ $(cat "/tmp/work_mode_state") = "ON" ]
        then
            eval $(keychain --eval --agents gpg,ssh id_ed25519)
            eval $(keychain --eval --agents gpg --quiet 0xGPG_KEY)
        fi

        FUNCNEST=1000
        eval "$(direnv hook zsh)"
        export JAVA_HOME=${pkgs.openjdk22}
        export NODEJS_HOME=${pkgs.nodejs}
    '';
  };

  home.file.omz_zsh_theme = {
    source = ./sigma.zsh-theme;
    target = "extra/zsh/themes/sigma.zsh-theme";
  };
}

