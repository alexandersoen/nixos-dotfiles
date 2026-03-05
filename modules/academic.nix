{ pkgs, ... }:

{
  home.packages = with pkgs; [
    texliveFull

    # LSP + Formatters
    texlab
    ltex-ls
    bibtex-tidy

    zotero
  ];
}
