{ pkgs, ... }:

{
  programs.tmux = {
    enable = true;
    prefix = "C-a";
    baseIndex = 1;
    escapeTime = 50;
    aggressiveResize = true;
    mouse = true;
    keyMode = "vi";
    terminal = "tmux-256color";
    historyLimit = 50000;
    sensibleOnTop = false;

    plugins = with pkgs.tmuxPlugins; [
      {
        plugin = resurrect;
        extraConfig = "set -g @resurrect-strategy-nvim 'session'";
      }
      {
        plugin = continuum;
        extraConfig = ''
          set -g @continuum-restore 'on'
          set -g @continuum-save-interval '15'
        '';
      }
    ];

    extraConfig = ''
      bind-key C-a last-window
      bind-key a send-prefix

      # Activity monitoring
      setw -g monitor-activity on
      set -g visual-activity on

      # Vi copypaste
      bind-key -T copy-mode-vi v send -X begin-selection
      bind-key -T copy-mode-vi y send -X copy-pipe-and-cancel
      bind-key -T copy-mode-vi C-v send -X rectangle-toggle

      set -g focus-events on

      # Splits preserving current path
      bind-key -N "New window"          c new-window -c "#{pane_current_path}"
      bind-key -N "Split horizontal"    b split-window -v -c "#{pane_current_path}"
      bind-key -N "Split vertical"      v split-window -h -c "#{pane_current_path}"

      # Smart pane switching with vim-tmux-navigator (no prefix required)
      is_vim="ps -o state= -o comm= -t '#{pane_tty}' | grep -iqE '^[^TXZ ]+ +(\S+\/)?g?(view|l?n?vim?x?|fzf)(diff)?$'"
      bind-key -n 'C-h' if-shell "$is_vim" 'send-keys C-h' 'select-pane -L'
      bind-key -n 'C-j' if-shell "$is_vim" 'send-keys C-j' 'select-pane -D'
      bind-key -n 'C-k' if-shell "$is_vim" 'send-keys C-k' 'select-pane -U'
      bind-key -n 'C-l' if-shell "$is_vim" 'send-keys C-l' 'select-pane -R'
      bind-key -T copy-mode-vi 'C-h' select-pane -L
      bind-key -T copy-mode-vi 'C-j' select-pane -D
      bind-key -T copy-mode-vi 'C-k' select-pane -U
      bind-key -T copy-mode-vi 'C-l' select-pane -R

      # Prefix + hjkl as fallback
      bind-key -N "Select pane left"    h select-pane -L
      bind-key -N "Select pane down"    j select-pane -D
      bind-key -N "Select pane up"      k select-pane -U
      bind-key -N "Select pane right"   l select-pane -R

      # Layouts (integer fallback for 3.1)
      bind-key -N "Main-horizontal"    m select-layout main-horizontal
      bind-key -N "Main-vertical"      M select-layout main-vertical

      bind-key -N "New named window"    C command-prompt -p "Name of new window: " "new-window -n '%%'"

      # Reload config
      bind-key -N "Reload config"       r source-file ~/.config/tmux/tmux.conf \; display-message "Config reloaded..."

      # Quick-action menu
      bind Space display-menu -T "Quick Actions" \
        "Horizontal Split"  h "split-window -v -c '#{pane_current_path}'" \
        "Vertical Split"    v "split-window -h -c '#{pane_current_path}'" \
        "" \
        "Swap Up"           u "swap-pane -U" \
        "Swap Down"         d "swap-pane -D" \
        "" \
        "Kill Pane"         x "kill-pane" \
        "Kill Window"       X "kill-window"

      set-window-option -g automatic-rename

      set -ga terminal-overrides ",xterm-256color:Tc"

      # 3.2+: terminal-features, extended-keys, popups, clipboard
      if-shell -F "#{>=:#{version},3.2}" {
          set -as terminal-features ",xterm-256color:RGB"
          set -g extended-keys on
          bind-key -N "Main-horizontal 66%" m setw main-pane-height 66% \; select-layout main-horizontal
          bind-key -N "Main-vertical 50%"   M setw main-pane-width 50% \; select-layout main-vertical
          bind-key -N "Popup shell"    t display-popup -E -w 80% -h 80%
          bind-key -N "Popup git log"  g display-popup -E -w 80% -h 80% "git log --oneline --graph -30"
          set -s set-clipboard on
          if-shell "command -v clip.exe" {
              set -s copy-command "clip.exe"
          } {
              if-shell "command -v pbcopy" {
                  set -s copy-command "pbcopy"
              } {
                  if-shell "command -v xclip" {
                      set -s copy-command "xclip -selection clipboard >/dev/null"
                  }
              }
          }
      }

      # 3.3+: pane border arrows
      if-shell -F "#{>=:#{version},3.3}" {
          set -g pane-border-indicators arrows
      }

      # ── Status bar (Gruvbox Dark) ──────────────────────────────────────────
      set -g status-style          "bg=#3c3836,fg=#d5c4a1"
      set -g status-interval       1
      set -g status-justify        centre
      set -g status-left-length    30
      set -g status-right-length   30

      set-option -g pane-border-style           "fg=#504945"
      set-option -g pane-active-border-style    "fg=#fabd2f"
      set-option -g message-style               "bg=#3c3836,fg=#fe8019"
      set-option -g display-panes-colour        "#fabd2f"
      set-option -g display-panes-active-colour "#b8bb26"
      set-window-option -g clock-mode-colour    "#83a598"

      set -g window-status-style         "fg=#bdae93,bg=#3c3836,dim"
      set -g window-status-current-style "fg=#fabd2f,bg=#3c3836,bold"
      set -g window-status-separator     " "

      # Left:  [󱄅] > [session]
      set -g status-left  '#[fg=#ebdbb2,bg=#3c3836] 󱄅 #[fg=#3c3836,bg=#b8bb26]#[fg=#282828,bg=#b8bb26,bold] #S #[fg=#b8bb26,bg=#3c3836]#[none]          '

      # Right: [date] > [time]
      set -g status-right '#[fg=#504945,bg=#3c3836]#[fg=#d5c4a1,bg=#504945] %Y-%m-%d #[fg=#fabd2f,bg=#504945]#[fg=#282828,bg=#fabd2f,bold] %I:%M %p #[fg=#3c3836,bg=#fabd2f]'

      # Window tabs (centre)
      set -g window-status-format         '#[fg=#3c3836,bg=#504945]#[fg=#bdae93,bg=#504945] #I:#W #[fg=#504945,bg=#3c3836]'
      set -g window-status-current-format '#[fg=#3c3836,bg=#83a598]#[fg=#282828,bg=#83a598,bold] #I:#W #[fg=#83a598,bg=#3c3836]'

    '';
  };
}
