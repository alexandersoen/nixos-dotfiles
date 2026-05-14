{ pkgs, ... }:

{
  home.packages = with pkgs; [
    jq
    skim
    fd
    xdotool
  ];
}
