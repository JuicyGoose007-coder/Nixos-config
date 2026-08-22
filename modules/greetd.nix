# Display manager. tuigreet is a native-Wayland TUI greeter, so there is no
# X server in the login path.
{ ... }:

{
  flake.modules.nixos.greetd =
    { pkgs, ... }:
    {
      services.greetd = {
        enable = true;
        settings = {
          default_session = {
            command = ''${pkgs.tuigreet}/bin/tuigreet --time --remember --remember-session --cmd "env XDG_SESSION_DESKTOP=niri XDG_CURRENT_DESKTOP=niri XDG_SESSION_CLASS=user niri-session"'';
            user = "greeter";
          };
        };
      };
    };
}
