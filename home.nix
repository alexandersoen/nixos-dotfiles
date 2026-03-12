{ config, pkgs, ... }:

let
  dotfiles = "${config.home.homeDirectory}/nixos-dotfiles/config";
  create_symlink = path: config.lib.file.mkOutOfStoreSymlink path;

  wallpaper = "${config.home.homeDirectory}/nixos-dotfiles/wallpapers/wallhaven-8ge2x1.png";

  configs = {
    alacritty = "alacritty";
    tmux = "tmux";
    scripts = "scripts";
    picom = "picom";
    statusbar = "statusbar";
    ruff = "ruff";
    dunst = "dunst";
  };
in

{
  imports = [
    ./modules/suckless.nix
    ./modules/neovim.nix
    ./modules/academic.nix
    ./modules/python.nix
    ./modules/codex.nix
    ./modules/lockscreen.nix
  ];

  home.username = "asoen";
  home.homeDirectory = "/home/asoen";
  home.stateVersion = "25.11";

  home.sessionVariables = {
    EDITOR = "vim";
    VISUAL = "vim";
  };

  home.packages = with pkgs; [
    feh
    google-chrome
    unzip

    opencode
    zathura
    spotify

    # For scripts
    skim
    fd
    xdotool
  ];

  my.codex = {
    enable = true;
    version = "0.114.0";
    hash = "sha256-kinejFHI7zBWW7UHyXou3ASoCzjkmkNj8zf+Bb7fNOs=";
  };

  services.flameshot.enable = true;

  # Default apps
  xdg.mimeApps = {
    enable = true;
    defaultApplications = {
      "application/pdf" = [ "org.pwmt.zathura.desktop" ];
    };
  };

  # Config files
  xdg.configFile = builtins.mapAttrs (name: subpath: {
    source = create_symlink "${dotfiles}/${subpath}";
    recursive = true;
  }) configs;

  # picom
  systemd.user.services.picom = {
    Unit = {
      Description = "Picom compositor";
      After = [ "graphical-session-pre.target" ];
      PartOf = [ "graphical-session.target" ];
    };
    Install = {
      WantedBy = [ "graphical-session.target" ];
    };
    Service = {
      # This points directly to the symlink created by your configs map
      ExecStart = "${pkgs.picom}/bin/picom --config ${dotfiles}/picom/picom.conf";
      Restart = "always";
    };
  };

  # Bash
  programs.bash = {
    enable = true;

    bashrcExtra = ''
      set -o vi
    '';

    initExtra = ''
      export PS1="\[\e[38;5;75m\]\u@\h \[\e[38;5;113m\]\w \[\e[38;5;189m\]\$ \[\e[0m\]"
    '';
  };

  # GitHub
  programs.git = {
    enable = true;

    settings = {
      user = {
        name = "alexandersoen";
        email = "alexandersoen@gmail.com";
      };

      init.defaultBranch = "main";
      pull.rebase = true;
      core.editor = "nvim";
    };
  };

  systemd.user.services.feh-wallpaper = {
    Unit = {
      Description = "Set wallpaper using feh";
      After = [ "graphical-session-pre.target" ];
      PartOf = [ "graphical-session.target" ];
    };

    Install = {
      WantedBy = [ "graphical-session.target" ];
    };

    Service = {
      Type = "oneshot";
      ExecStart = "${pkgs.feh}/bin/feh --bg-fill ${wallpaper}";
    };
  };

  # Monitors
  programs.autorandr = {
    enable = true;
    hooks.postswitch = {
      wallpaper = "${pkgs.feh}/bin/feh --no-fehbg --bg-fill ${wallpaper}";
    };
  };
}
