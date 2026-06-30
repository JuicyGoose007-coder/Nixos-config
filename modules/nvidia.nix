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

  # Wayland + NVIDIA environment
  environment.sessionVariables = {
    LIBVA_DRIVER_NAME        = "nvidia";
    GBM_BACKEND              = "nvidia-drm";
    __GLX_VENDOR_LIBRARY_NAME = "nvidia";
    NVD_BACKEND              = "direct";
  };
}
