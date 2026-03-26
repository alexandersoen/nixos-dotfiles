{
  config,
  lib,
  pkgs,
  ...
}:

let
  cfg = config.my.codex;

  codex-raw = pkgs.stdenvNoCC.mkDerivation {
    pname = "codex";
    inherit (cfg) version;

    src = pkgs.fetchurl {
      url = "https://github.com/openai/codex/releases/download/rust-v${cfg.version}/codex-x86_64-unknown-linux-musl.tar.gz";
      hash = cfg.hash;
    };

    dontConfigure = true;
    dontBuild = true;
    sourceRoot = ".";

    unpackPhase = ''
      tar -xzf $src
    '';

    installPhase = ''
      mkdir -p $out/bin
      install -m755 codex-x86_64-unknown-linux-musl $out/bin/codex
    '';
  };

  # The upstream Codex release currently probes `/usr/bin/bwrap` directly.
  # On NixOS, bubblewrap lives in the store, so run Codex inside a small
  # FHS environment that exposes `/usr/bin/bwrap`.
  codex-bin = pkgs.buildFHSEnv {
    name = "codex";
    targetPkgs = pkgs: [
      pkgs.bubblewrap
    ];
    runScript = "${codex-raw}/bin/codex";
  };
in
{
  options.my.codex = {
    enable = lib.mkEnableOption "install Codex from the upstream GitHub release";

    version = lib.mkOption {
      type = lib.types.str;
      default = "0.112.0";
      description = "Codex release version.";
    };

    hash = lib.mkOption {
      type = lib.types.str;
      default = lib.fakeSha256;
      description = "Hash for the Codex release tarball.";
    };
  };

  config = lib.mkIf cfg.enable {
    home.packages = [
      codex-bin
    ];
  };
}
