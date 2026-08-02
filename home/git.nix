{ pkgs, ... }:

let
  git-aic = pkgs.writeShellApplication {
    name = "git-aic";
    runtimeInputs = [
      pkgs.git
      pkgs.curl
      pkgs.jq
    ];
    text = ''
      if git diff --cached --quiet; then 
        echo "Nothing staged - stage changes first." >&2
        exit 1
      fi
      diff=$(git diff --cached)
      payload=$(jq -n --arg diff "$diff" \
      '{model: "qwen2.5-coder", prompt: ("Write a concise git commit message (imperative mood, subject under 50 chars, optional body, no markdown fences) for this diff:\n\n" + $diff), stream: false}')
      response=$(curl -s http://localhost:11434/api/generate -d "$payload")
      message=$(jq -r '.response' <<<"$response")
      printf '%s' "$message" | git commit -e -F -
    '';
  };
in
{
  programs.git = {
    enable = true;
    settings.user = {
      name = "Jake Turner";
      email = "jaketurner624@gmail.com";
    };
    settings.safe.directory = [ "/etc/nixos" ];
  };

  programs.ssh = {
    enable = true;
    enableDefaultConfig = false;
    settings."github.com" = {
      hostname = "github.com";
      user = "git";
      identityFile = "~/.ssh/id_ed25519";
    };
  };

  home.packages = [ git-aic ];
}
