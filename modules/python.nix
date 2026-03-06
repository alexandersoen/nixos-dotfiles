{ pkgs, ... }:

{
  home.packages = with pkgs; [
    uv

    # lsp
    ruff
    pyright
  ];
}
