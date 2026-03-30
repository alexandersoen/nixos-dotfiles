{
  config,
  pkgs,
  lib,
  ...
}:

{
  boot.kernelModules = [
    "uvcvideo"
  ];

  services.udisks2.enable = true;
  services.gvfs.enable = true;
  security.polkit.enable = true;

  boot.supportedFilesystems = [
    "ntfs"
    "exfat"
  ];

  environment.systemPackages = with pkgs; [
    usbutils
    v4l-utils
  ];
}
