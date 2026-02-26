{ pkgs, ... }:

{
  home.packages = with pkgs; [
    (pkgs.dmenu.overrideAttrs (_: {
      src = /home/asoen/nixos-dotfiles/config/dmenu;
      patches = [ ];
    }))
  ];
}
