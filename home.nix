{ config, pkgs, ... }:

let
  dotfiles = "${config.home.homeDirectory}/nixos-dotfiles/config";
  create_symlink = path: config.lib.file.mkOutOfStoreSymlink path;
in

{
  home.username = "asoen";
  home.homeDirectory = "/home/asoen";
  home.stateVersion = "25.11";
  programs.bash = {
    enable = true;
    shellAliases = {
      vim = "nvim";
    };
  };

  # home.file.".config/nvim".source = ./config/nvim;
  xdg.configFile."nvim" = {
    source = config.lib.file.mkOutOfStoreSymlink "${dotfiles}/nvim";
    recursive = true;
  };

  home.packages = with pkgs; [
    neovim
    tree-sitter
    nodejs
    gcc
  ];

  # GitHub
  programs.git = {
    enable = true;
    userName = "alexandersoen";
    userEmail = "alexandersoen@gmail.com";

    extraConfig = {
      init.defaultBranch = "main";
      pull.rebase = true;
      core.editor = "nvim";
    };
  };
}
