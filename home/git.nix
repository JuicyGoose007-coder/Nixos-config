{ pkgs, ... }:

let
  git-aic = pkgs.writeShellApplication {
    name = "git-aic";
    runtimeInputs = [
      pkgs.git
      pkgs.curl
      pkgs.jq
      pkgs.fzf
    ];
    text = ''
       if git diff --cached --quiet; then 
         echo "Nothing staged - stage changes first." >&2
         exit 1
       fi
       diff=$(git diff --cached)
      candidates=""
         for _ in 1 2; do
           payload=$(jq -n --arg diff "$diff" \
             '{model: "qwen2.5-coder", prompt: ("Write ONE concise git commit message subject line, imperative mood, under 50 characters, no body, no quotes, no markdown, for this diff:\n\n" + $diff), stream: false, options: {temperature: 0.9}}')
           msg=$(curl -s http://localhost:11434/api/generate -d "$payload" | jq -r '.response')
           candidates+="$msg"$'\n'
         done

         chosen=$(printf '%s' "$candidates" | grep . | \
           fzf --print-query --height=40% --reverse --prompt="commit> ") || true
         chosen=$(printf '%s\n' "$chosen" | tail -n1)

         if [ -z "$chosen" ]; then
           echo "Aborted - no message chosen." >&2
           exit 1
         fi

         printf '%s' "$chosen" | git commit -F -
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
