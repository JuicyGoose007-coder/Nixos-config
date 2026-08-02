#!/usr/bin/env sh
# Resolve the real terminal + its font, seeing past wrappers (iris/tmux) that
# confuse fastfetch's process-tree walk. Usage: term.sh name|font

term() {
  if   [ -n "$GHOSTTY_BIN_DIR" ];  then echo ghostty
  elif [ -n "$KITTY_WINDOW_ID" ];  then echo kitty
  elif [ -n "$ALACRITTY_SOCKET" ]; then echo alacritty
  elif [ -n "$WEZTERM_PANE" ];     then echo wezterm
  else t=${TERM_PROGRAM:-${TERM#*-}}; echo "${t:-unknown}"
  fi
}

case "$1" in
  name) term ;;
  font)
    case "$(term)" in
      ghostty)   grep -m1 '^font-family' "$HOME/.config/ghostty/config"   | cut -d= -f2- | sed 's/^ *//' ;;
      kitty)     grep -m1 '^font_family' "$HOME/.config/kitty/kitty.conf" | cut -d' ' -f2- ;;
      alacritty) grep -m1 'family'       "$HOME/.config/alacritty/alacritty.toml" | cut -d'"' -f2 ;;
      *)         echo "" ;;
    esac ;;
esac
