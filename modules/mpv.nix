# mpv — primary media player.
#
# Deliberately a plain package plus mime claims, not `programs.mpv.enable`:
# enabling it generates an mpv.conf and lights up stylix's mpv target (OSD and
# subtitle fonts, base16 colours). Left for when there's a reason to configure
# mpv rather than just point file managers at it.
{ ... }:

{
  flake.modules.homeManager.mpv =
    { pkgs, ... }:
    {
      home.packages = [ pkgs.mpv ];

      xdg.mimeApps = {
        # modules/xdg-mime.nix already sets this, but repeating it keeps the aspect
        # self-contained: if that file is ever converted or dropped, mpv doesn't
        # silently stop being the default. Two identical `true` definitions of a
        # bool option merge without conflict.
        enable = true;

        # Only `defaultApplications` — no `associations.added`. mpv ships its own
        # desktop entry declaring ~80 MIME types (`Exec=mpv
        # --player-operation-mode=pseudo-gui -- %U`), so the *association* already
        # exists; what was missing is mpv winning the *default* slot for them.
        # Adding them again would be redundant.
        #
        # The list below is hand-curated rather than read out of mpv.desktop:
        # `builtins.readFile "${pkgs.mpv}/share/applications/mpv.desktop"` would
        # force mpv to build during evaluation. This attrset merges with the
        # browser/editor entries in modules/xdg-mime.nix — it does not replace them.
        defaultApplications = {
          # Video
          "video/mp4" = "mpv.desktop";
          "video/x-matroska" = "mpv.desktop"; # .mkv — there is no "video/mkv"
          "video/webm" = "mpv.desktop";
          "video/quicktime" = "mpv.desktop";
          "video/x-msvideo" = "mpv.desktop";
          "video/mpeg" = "mpv.desktop";
          "video/x-m4v" = "mpv.desktop";
          "video/x-flv" = "mpv.desktop";
          "video/ogg" = "mpv.desktop";
          "video/x-ms-wmv" = "mpv.desktop";
          "video/3gpp" = "mpv.desktop";

          # Audio
          "audio/mpeg" = "mpv.desktop";
          "audio/flac" = "mpv.desktop";
          "audio/x-flac" = "mpv.desktop";
          "audio/ogg" = "mpv.desktop";
          "audio/x-vorbis+ogg" = "mpv.desktop";
          "audio/opus" = "mpv.desktop";
          "audio/wav" = "mpv.desktop";
          "audio/x-wav" = "mpv.desktop";
          "audio/mp4" = "mpv.desktop";
          "audio/x-m4a" = "mpv.desktop";
          "audio/aac" = "mpv.desktop";
          "audio/aiff" = "mpv.desktop";
          "audio/x-ms-wma" = "mpv.desktop";

          # Playlists
          "audio/x-mpegurl" = "mpv.desktop";
          "application/x-mpegurl" = "mpv.desktop";
          "audio/x-scpls" = "mpv.desktop";

          # Streaming schemes
          "x-scheme-handler/mms" = "mpv.desktop";
          "x-scheme-handler/rtmp" = "mpv.desktop";
          "x-scheme-handler/rtsp" = "mpv.desktop";
        };
      };
    };
}
