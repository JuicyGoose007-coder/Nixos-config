# Audio server. pavucontrol and wiremix are its GUIs and live in their own
# aspects; this is the service.
{ ... }:

{
  flake.modules.nixos.pipewire =
    { ... }:
    {
      services.pulseaudio.enable = false;
      security.rtkit.enable = true;

      services.pipewire = {
        enable = true;
        alsa.enable = true;
        pulse.enable = true;
      };
    };
}
