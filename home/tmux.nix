{ pkgs, ... }:

{
  programs.tmux = {
    enable = true;
    prefix = "C-b";
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

      # Status bar colors + layout are provided by stylix (tinted-tmux base16 template).
      set -g status-interval 1
    '';
  };
}
