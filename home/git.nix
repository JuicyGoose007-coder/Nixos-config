{ pkgs, ... }:

let
  git-aic = pkgs.writeShellApplication {
    name = "git-aic";
    runtimeInputs = [
      pkgs.git
      pkgs.curl
      pkgs.jq
      pkgs.gnused
    ];
    text = ''
      # git aic - write a commit message from staged changes with a local LLM.
      #
      #   git aic        plain imperative subject
      #   git aic -c     Conventional Commit subject
      #
      # Conventional Commit types the -c prefix chooses from:
      #   feat      a new feature
      #   fix       a bug fix
      #   docs      documentation only
      #   style     formatting, no behaviour change
      #   refactor  restructure, neither feature nor fix
      #   perf      performance improvement
      #   test      add/adjust tests
      #   build     build system / deps (e.g. flake.lock bumps)
      #   ci        CI configuration
      #   chore     other maintenance

      conventional=0
      while getopts "c" opt; do
        case "$opt" in
          c) conventional=1 ;;
          *) echo "Usage: git aic [-c]" >&2; exit 1 ;;
        esac
      done

      if git diff --cached --quiet; then
        echo "Nothing staged - stage changes first." >&2
        exit 1
      fi

      diff=$(git diff --cached)
      stat=$(git diff --cached --stat)

      # Subject wording: plain imperative, or a Conventional Commit prefix.
      if [ "$conventional" -eq 1 ]; then
        instr='Format the subject as a Conventional Commit "type(scope): description".
               Choose type from: feat, fix, docs, style, refactor, perf, test, build, ci, chore.
               Examples:
               feat(auth): add OAuth login flow
               fix(parser): handle empty input without crashing
               build(flake): pin stylix to release-26.05
               Keep the subject under 60 characters. Output only the line, no quotes, no markdown.'
      else
        instr='Write a single imperative commit subject line under 50 characters.
              Examples:
              add dark mode toggle to settings page
              fix crash when opening an empty file
              remove unused logging from the auth handler
              Output only the subject line: no quotes, no markdown, no trailing period.'           
      fi

      # One model, shared with iris (home/iris.nix) so it's always warm - no extra
      # VRAM, no cold-load lag. 3B fits comfortably on the 8GB 2070 with headroom.
      model="qwen2.5-coder:3b"

      # Diff FIRST, instruction LAST so the model reliably follows it. num_predict
      # + stop:["\n"] keep it to a single fast line; "Subject: " primes the answer.
      payload=$(jq -n \
        --arg diff "$diff" \
        --arg stat "$stat" \
        --arg model "$model" \
        --arg instr "$instr" '{
          model: $model,
          prompt: ($stat + "\n\n" + $diff + "\n\n---\n" + $instr + "\nSubject: "),
          stream: false,
          options: { temperature: 0.3, num_predict: 40, stop: ["\n"] }
        }')
      raw=$(curl -s http://localhost:11434/api/generate -d "$payload" | jq -r '.response')
      # Strip a stray "Subject:" label, surrounding quotes, trailing whitespace.
      msg=$(printf '%s' "$raw" | sed -E 's/^[[:space:]]*(Subject:[[:space:]]*)?//I; s/^"//; s/"$//; s/[[:space:]]+$//')

      # Show it and take one key: Enter commits, e edits inline (bash readline,
      # prefilled - no editor launch), n aborts.
      while true; do
        printf '\n%s\n\n' "$msg"
        read -r -p "[Enter] commit   [e] edit   [n] abort: " key
        case "$key" in
          "") break ;;
          e | E) read -r -e -i "$msg" -p "edit> " msg ;;
          n | N) echo "Aborted." >&2; exit 1 ;;
          *) ;;
        esac
      done

      printf '%s' "$msg" | git commit -F -
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
