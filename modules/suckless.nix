{ pkgs, ... }:

let
  myDwmblocks = pkgs.dwmblocks.overrideAttrs (_: {
    src = /home/asoen/nixos-dotfiles/config/dwmblocks;
    patches = [ ];
  });
in

{
  home.packages = with pkgs; [
    (dmenu.overrideAttrs (_: {
      src = /home/asoen/nixos-dotfiles/config/dmenu;
      patches = [ ];
    }))
    myDwmblocks
  ];

  xsession.enable = true;
  xsession.initExtra = ''
    ${myDwmblocks}/bin/dwmblocks
  '';
}
