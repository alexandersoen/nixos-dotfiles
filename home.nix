{ config, pkgs, ... }:

let
  dotfiles = "${config.home.homeDirectory}/nixos-dotfiles/config";
  create_symlink = path: config.lib.file.mkOutOfStoreSymlink path;
in

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
  };

  # home.packages = with pkgs; [
  # ];


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
