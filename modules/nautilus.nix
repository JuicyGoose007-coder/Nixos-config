# The file manager. gvfs — trash, mounts, network shares — is system-wide in
# modules/udisks2.nix rather than here.
{ ... }:

{
  flake.modules.homeManager.nautilus =
    { pkgs, ... }:
    {
      home.packages = [ pkgs.nautilus ];

      # Nautilus' desktop entry claims inode/directory along with a pile of
      # archive types; only the directory half is pinned as the default.
      xdg.mimeApps = {
        enable = true;
        defaultApplications."inode/directory" = "org.gnome.Nautilus.desktop";
      };
    };
}
