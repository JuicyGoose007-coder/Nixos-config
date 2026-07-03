{ config, pkgs, ... }:

{
  hardware.graphics = {
    enable      = true;
    enable32Bit = true;
    extraPackages = with pkgs; [
      nvidia-vaapi-driver
    ];
  };

  hardware.nvidia = {
    modesetting.enable  = true;
    powerManagement.enable = true;
    open            = true;
    nvidiaSettings  = true;
    package         = config.boot.kernelPackages.nvidiaPackages.stable;
  };

  services.xserver.videoDrivers = [ "nvidia" ];

  # Early KMS: load the NVIDIA modules in the initrd so the driver drives the
  # console from the start. Avoids the mid-boot mode switch (black screen) and
  # the console/getty briefly appearing on the secondary output (DP-1).
  boot.initrd.kernelModules = [ "nvidia" "nvidia_modeset" "nvidia_uvm" "nvidia_drm" ];

  # Wayland + NVIDIA environment
  environment.sessionVariables = {
    LIBVA_DRIVER_NAME        = "nvidia";
    GBM_BACKEND              = "nvidia-drm";
    __GLX_VENDOR_LIBRARY_NAME = "nvidia";
    NVD_BACKEND              = "direct";
  };
}
