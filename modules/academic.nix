{ pkgs, ... }:

let
  zotero-tui-flake = builtins.getFlake "github:alexandersoen/zotero-tui";
  zotero-tui-pkg = zotero-tui-flake.packages.${pkgs.stdenv.hostPlatform.system}.default;
in

{
  home.packages = with pkgs; [
    texliveFull

    # LSP + Formatters
    texlab
    ltex-ls
    tex-fmt
    bibtex-tidy

    zotero
    zotero-tui-pkg
    xclip
  ];
}
