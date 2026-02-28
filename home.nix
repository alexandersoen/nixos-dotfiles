{ config, pkgs, ... }:

{
  imports = [
    ./modules/suckless.nix
    ./modules/neovim.nix
  ];

  home.username = "asoen";
  home.homeDirectory = "/home/asoen";
  home.stateVersion = "25.11";
  programs.bash = {
    enable = true;

    bashrcExtra = ''
      set -o vi
    '';

    initExtra = ''
      export PS1="\[\e[38;5;75m\]\u@\h \[\e[38;5;113m\]\w \[\e[38;5;189m\]\$ \[\e[0m\]"
    '';
  };

  home.packages = with pkgs; [
  ];

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
}
