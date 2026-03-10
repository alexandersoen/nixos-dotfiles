{
  config,
  lib,
  pkgs,
  ...
}:

let
  hasSwapPartition = config.swapDevices != [ ];
in
{
  assertions = [
    {
      assertion = hasSwapPartition;
      message = ''
        power.nix requires at least one swap device in hardware-configuration.nix.
        Your current setup should use a swap partition for hibernation.
      '';
    }
  ];

  # Clean, automatic resume target:
  # uses the first swap device already declared in hardware-configuration.nix
  boot.resumeDevice = (builtins.head config.swapDevices).device;

  # Close lid -> suspend immediately, then hibernate after a delay
  services.logind.settings.Login.HandleLidSwitch = "suspend-then-hibernate";
  services.logind.settings.Login.HandleLidSwitchExternalPower = "ignore";
  services.logind.settings.Login.HandleLidSwitchDocked = "ignore";

  # Delay before going from suspend to hibernate
  systemd.sleep.extraConfig = ''
    [Sleep]
    HibernateDelaySec=30m
  '';

  services.thermald.enable = true;
  powerManagement.powertop.enable = true;

  powerManagement.enable = true;
}
