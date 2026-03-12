{ pkgs, ... }:

{
  home.packages = [ pkgs.xsecurelock ];

  home.shellAliases.lock = "xsecurelock";
}
