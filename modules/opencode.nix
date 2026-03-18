{
  config,
  lib,
  pkgs,
  ...
}:

let
  cfg = config.my.opencode;

  opencode-bin = pkgs.stdenvNoCC.mkDerivation {
    pname = "opencode";
    inherit (cfg) version;

    src = pkgs.fetchurl {
      url = "https://github.com/anomalyco/opencode/releases/download/v${cfg.version}/opencode-linux-x64.tar.gz";
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
      install -m755 opencode $out/bin/opencode
    '';
  };
in
{
  options.my.opencode = {
    enable = lib.mkEnableOption "install OpenCode from the upstream GitHub release";

    version = lib.mkOption {
      type = lib.types.str;
      default = "1.2.24";
      description = "OpenCode release version.";
    };

    hash = lib.mkOption {
      type = lib.types.str;
      default = lib.fakeSha256;
      description = "Hash for the OpenCode release tarball.";
    };
  };

  config = lib.mkIf cfg.enable {
    home.packages = [ opencode-bin ];
  };
}
