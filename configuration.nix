{
  config,
  lib,
  pkgs,
  inputs,
  ...
}:

{
  imports = [
    /etc/nixos/hardware-configuration.nix
    ./modules/power.nix
    ./modules/usb.nix
  ];

  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  networking.hostName = "ngunnawal";
  networking.networkmanager.enable = true;

  time.timeZone = "Europe/Stockholm";

  services.displayManager.ly.enable = true;
  services.xserver = {
    enable = true;
    autoRepeatDelay = 200;
    autoRepeatInterval = 35;
  };

  services.xserver.windowManager.dwm = {
    enable = true;
    package = pkgs.dwm.overrideAttrs (old: {
      src = /home/asoen/nixos-dotfiles/config/dwm;

      buildInputs = (old.buildInputs or [ ]) ++ [
        pkgs.yajl
      ];
    });

  };

  users.users.asoen = {
    isNormalUser = true;
    extraGroups = [
      "wheel"
      "networkmanager"
      "video"
    ];
    packages = with pkgs; [
      tree
    ];
  };

  environment.systemPackages = with pkgs; [
    vim
    wget
    alacritty
    git
    tmux
    xclip
    lm_sensors
    dunst
    libnotify
  ];

  # Need to this to get python uv to work (ie, non-nix installations)
  programs.nix-ld.enable = true;
  programs.nix-ld.libraries = with pkgs; [
    stdenv.cc.cc
    zlib
  ];

  services.dbus.enable = true;

  services.libinput.touchpad.naturalScrolling = true;

  fonts.packages = with pkgs; [
    nerd-fonts.jetbrains-mono
  ];

  security.rtkit.enable = true;

  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
  };

  hardware.bluetooth = {
    enable = true;
    powerOnBoot = true;
  };

  hardware.ipu6 = {
    enable = true;
    platform = "ipu6ep";
  };

  services.v4l2-relayd.instances.ipu6.input = {
    # The default 1280x720@30 path is unstable on this IPU6 stack and
    # repeatedly times out during VIDIOC_STREAMON. Use a lighter mode.
    width = 640;
    height = 480;
    framerate = 15;
  };

  systemd.services.v4l2-relayd-ipu6 = {
    preStart = lib.mkForce ''
      mkdir -p "$(dirname "$V4L2_DEVICE_FILE")"

      # Keep the relay on a stable browser-facing node.
      if [ -e /dev/video1 ]; then
        echo /dev/video1 > "$V4L2_DEVICE_FILE"
      else
        ${config.boot.kernelPackages.v4l2loopback.bin}/bin/v4l2loopback-ctl add \
          -x 1 \
          -n "Intel MIPI Camera" \
          /dev/video1 > "$V4L2_DEVICE_FILE"
      fi
    '';

    # Keep the loopback node stable across relay restarts so browsers do not
    # lose the camera when systemd restarts the relay process.
    postStop = lib.mkForce "";
  };

  programs.light.enable = true;

  nixpkgs.overlays = [
    (final: prev: {
      gst_all_1 = prev.gst_all_1 // {
        # nixpkgs currently builds icamerasrc-ipu6ep with the plain ipu6 HAL.
        # Force the Alder/Raptor Lake variant so the IPU6 relay produces frames.
        icamerasrc-ipu6ep = prev.gst_all_1.icamerasrc-ipu6.override {
          ipu6-camera-hal = prev.ipu6ep-camera-hal;
        };
      };
    })
  ];

  nix.settings.experimental-features = [
    "nix-command"
    "flakes"
  ];
  system.stateVersion = "25.11";

  # For VM
  # services.xserver.displayManager.sessionCommands = ''
  #   ${pkgs.xorg.xrandr}/bin/xrandr --output Virtual-1 --mode 2048x1152 &
  # '';
  # virtualisation.virtualbox.guest.enable = true;
  # virtualisation.virtualbox.guest.dragAndDrop = true;

  nixpkgs.config.allowUnfree = true;
}
