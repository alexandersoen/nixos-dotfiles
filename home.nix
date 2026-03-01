{ config, pkgs, ... }:

let
  dotfiles = "${config.home.homeDirectory}/nixos-dotfiles/config";
  create_symlink = path: config.lib.file.mkOutOfStoreSymlink path;

  wallpaper = "${config.home.homeDirectory}/nixos-dotfiles/wallpapers/wallhaven-8ge2x1.png";
in

{
  imports = [
    ./modules/suckless.nix
    ./modules/neovim.nix
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

    # For scripts
    skim
    fd
  ];

  # Terminal
  xdg.configFile."alacritty" = {
    source = create_symlink "${dotfiles}/alacritty";
    recursive = true;
  };
  xdg.configFile."tmux" = {
    source = create_symlink "${dotfiles}/tmux";
    recursive = true;
  };
  xdg.configFile."scripts" = {
    source = create_symlink "${dotfiles}/scripts";
    recursive = true;
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
      Partof = [ "graphical-session.target" ];
    };

    Install = {
      WantedBy = [ "graphical-session.target" ];
    };

    Service = {
      Type = "oneshot";
      ExecStart = "${pkgs.feh}/bin/feh --bg-fill ${wallpaper}";
      RemainAfterExit = true;
    };
  };
}
