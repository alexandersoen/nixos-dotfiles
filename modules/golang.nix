{ pkgs, ... }:

{
  home.packages = with pkgs; [
    go

    # LSP / formatting / debugging
    gopls
    gotools
    delve
    golangci-lint
  ];
}
