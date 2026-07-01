{ ... }:

{
  programs.starship = {
    enable = true;
    settings = {
      add_newline = true;

      format = ''
        [╭╴](base03)$env_var$all[╰─](base03)$character'';

      character = {
        success_symbol = "[➜](bold base0B)";
        error_symbol   = "[✗](bold base08) ";
        vimcmd_symbol  = "[](bold base0B)";
      };

      cmd_duration = {
        format = "[$duration]($style) ";
        style  = "base0A";
      };

      aws = {
        format   = "[$symbol($profile )(\\($region\\) )(\\[$duration\\] )]($style)";
        symbol   = "󰸏  ";
        disabled = true;
      };

      username = {
        style_user  = "bold base09";
        style_root  = "bold base08";
        format      = "[󱄅](bold base0B) [$user]($style)";
        disabled    = false;
        show_always = true;
      };

      hostname = {
        ssh_only = false;
        format   = "-[NixOS](bold #8ec07c)";
        disabled = false;
      };

      directory = {
        style             = "bold base08";
        truncation_length = 3;
        truncation_symbol = "…/";
        home_symbol       = " ~";
        read_only_style   = "bold base0A";
        read_only         = "  ";
        format            = "[$path]($style)[$read_only]($read_only_style) ";
      };

      git_branch = {
        style  = "base0E";
        format = "[$symbol$branch]($style) ";
        symbol = " ";
      };

      git_status = {
        format     = "[(\($all_status$ahead_behind\))]($style) ";
        style      = "bold base0B";
        conflicted = "🏳";
        up_to_date = " ";
        untracked  = " ";
        ahead      = "⇡\${count}";
        diverged   = "⇕⇡\${ahead_count}⇣\${behind_count}";
        behind     = "⇣\${count}";
        stashed    = " ";
        modified   = " ";
        staged     = "[++\\($count\\)](bold base0A)";
        renamed    = "» ";
        deleted    = " ";
      };

      golang = {
        symbol = " ";
        style  = "base0C";
        format = "via [$symbol($version )]($style)";
      };

      terraform = {
        format = "via [ terraform $version]($style) [$workspace]($style) ";
        style  = "base09";
      };

      docker_context = {
        format = "via [ $context]($style) ";
        style  = "bold base0C";
      };

      helm = {
        format = "via [ $version]($style) ";
        style  = "bold base0C";
      };

      python = {
        symbol        = " ";
        python_binary = "python3";
        style         = "base0A";
        format        = "via [$symbol$pyenv_prefix($version )(\($virtualenv\) )]($style)";
      };

      nodejs = {
        format = "via [ $version]($style) ";
        style  = "bold base0B";
      };

      ruby = {
        format = "via [ $version]($style) ";
        style  = "base08";
      };

      rust = {
        symbol = " ";
        style  = "base09";
        format = "via [$symbol($version )]($style)";
      };

      bun = {
        format = "[$symbol($version )]($style)";
        symbol = "󰳮 ";
        style  = "base0A";
      };

      c = {
        format = "[$symbol($version(-$name) )]($style)";
        symbol = " ";
        style  = "base0C";
      };

      conda = {
        format = "[$symbol$environment]($style) ";
        symbol = " ";
        style  = "base0B";
      };

      container = {
        format = "[$symbol\\[$name\\]]($style) ";
        symbol = " ";
        style  = "base09";
      };
    };
  };
}
