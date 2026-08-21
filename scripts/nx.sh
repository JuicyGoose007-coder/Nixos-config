# nx - manage the NixOS configuration in /etc/nixos.

repo=/etc/nixos
lock=$repo/flake.lock

switched=0
backup=""

if [ -t 1 ]; then
  c_blue=$'\033[1;34m'
  c_green=$'\033[1;32m'
  c_yellow=$'\033[1;33m'
  c_red=$'\033[1;31m'
  c_off=$'\033[0m'
else
  c_blue=""
  c_green=""
  c_yellow=""
  c_red=""
  c_off=""
fi

stage() { printf '\n%s==> %s%s\n' "$c_blue" "$c_off" "$1"; }
ok() { printf '%sOK%s%s\n' "$c_green" "${1:+ — $1}" "$c_off"; }
warn() { printf '%s!  %s%s\n' "$c_yellow" "$c_off" "$1"; }
fail() { printf '\n%s!! %s%s\n' "$c_red" "$c_off" "$1" >&2; }

usage() {
  cat <<'EOF'
nx - manage the NixOS configuration in /etc/nixos

Usage: nx [command] [options]

  (none)      build what flake.lock pins, show the diff, then switch
  up          update flake.lock first, then build, diff and switch
  check       nix flake check, without building
  clean [N]   keep the newest N generations (default 5), collect garbage,
              then rewrite the boot menu
  back        roll back one generation, after showing the diff
  lock        restore flake.lock from git
  help        show this

Options, on the build-and-switch path only:

  -u          update flake.lock first, reverted if nothing is activated
  -b          activate at next boot instead of now
  -n          dry run: build and show the diff, then stop
EOF
}

generation() {
  readlink /nix/var/nix/profiles/system | tr -dc '0-9'
}

# Restores the snapshot, not git checkout, so a lock you had edited survives.
revert_lock() {
  [ -n "$backup" ] || return 0
  if [ "$switched" -eq 0 ]; then
    echo "Reverting flake.lock - nothing was activated."
    cp "$backup" "$lock"
  fi
  rm -f "$backup"
}
trap revert_lock EXIT

# Nix cannot see files git does not track. -N records paths only; naming them
# rather than -A avoids also staging pending deletions.
stage_untracked() {
  local untracked
  untracked=$(git -C "$repo" ls-files --others --exclude-standard -z)
  [ -n "$untracked" ] || return 0
  warn "Staging files Nix would otherwise not see:"
  printf '%s' "$untracked" | tr '\0' '\n' | sed 's/^/     /'
  printf '%s' "$untracked" | xargs -0 git -C "$repo" add -N --
}

cmd_deploy() {
  local update=0 dryrun=0 mode="switch" opt before after new snapshot key

  OPTIND=1
  while getopts "ubnh" opt; do
    case "$opt" in
      u) update=1 ;;
      b) mode="boot" ;;
      n) dryrun=1 ;;
      h)
        usage
        return 0
        ;;
      *)
        usage >&2
        return 1
        ;;
    esac
  done

  stage_untracked

  if [ "$update" -eq 1 ]; then
    stage "Updating flake inputs"
    # Set backup only after cp succeeds, or the trap restores an empty file.
    snapshot=$(mktemp)
    cp "$lock" "$snapshot"
    backup="$snapshot"

    if ! nix flake update --flake "$repo"; then
      fail "Updating flake inputs failed - no network, or an input is unreachable."
      return 1
    fi
    ok
  fi

  before=$(generation)

  stage "Building goosenest"
  if ! new=$(nom build --no-link --print-out-paths \
    "$repo#nixosConfigurations.goosenest.config.system.build.toplevel"); then
    fail "Build failed - see the log above."
    return 1
  fi
  ok

  stage "Changes"
  nvd diff /run/current-system "$new"

  if [ "$dryrun" -eq 1 ]; then
    stage "Dry run - generation $before unchanged, nothing activated."
    return 0
  fi

  echo
  while true; do
    read -r -p "[Enter] $mode   [n] abort: " key
    case "$key" in
      "") break ;;
      n | N)
        echo "Aborted." >&2
        return 1
        ;;
      *) ;;
    esac
  done

  # Activates the path just diffed. nixos-rebuild would evaluate a second time
  # and could activate something else.
  stage "Activating"
  sudo nix-env --profile /nix/var/nix/profiles/system --set "$new"
  sudo "$new/bin/switch-to-configuration" "$mode"

  switched=1

  after=$(generation)
  if [ "$mode" = "boot" ]; then
    ok "generation $before -> $after, active at next boot"
  else
    ok "generation $before -> $after"
  fi
}

cmd_check() {
  stage "Checking flake"
  if ! nix flake check "$repo"; then
    fail "Flake check failed - a syntax or type error in the changed .nix files."
    return 1
  fi
  ok
}

cmd_clean() {
  local keep=${1:-5}
  case "$keep" in
    '' | *[!0-9]*)
      fail "clean expects a whole number of generations to keep, got '$keep'."
      return 1
      ;;
  esac

  stage "Deleting all but the newest $keep generations"
  sudo nix-env --profile /nix/var/nix/profiles/system --delete-generations "+$keep"
  ok

  stage "Collecting garbage"
  sudo nix-collect-garbage
  ok

  # nixos-rebuild boot would re-evaluate the flake to do this.
  stage "Rewriting the boot menu"
  sudo /run/current-system/bin/switch-to-configuration boot
  ok "generation $(generation) still current"
}

cmd_back() {
  local current previous target key
  current=$(generation)
  previous=$((current - 1))

  if [ "$current" -le 1 ]; then
    fail "Generation $current is the oldest - nothing to roll back to."
    return 1
  fi

  target=/nix/var/nix/profiles/system-$previous-link
  if [ ! -e "$target" ]; then
    fail "Generation $previous no longer exists - deleted by 'nx clean'?"
    return 1
  fi

  stage "Rolling back generation $current -> $previous"
  nvd diff /run/current-system "$target"

  echo
  while true; do
    read -r -p "[Enter] roll back   [n] abort: " key
    case "$key" in
      "") break ;;
      n | N)
        echo "Aborted." >&2
        return 1
        ;;
      *) ;;
    esac
  done

  stage "Activating"
  sudo nix-env --profile /nix/var/nix/profiles/system --rollback
  sudo /nix/var/nix/profiles/system/bin/switch-to-configuration switch
  ok "generation $current -> $(generation)"
}

cmd_lock() {
  stage "Restoring flake.lock from git"
  git -C "$repo" checkout -- flake.lock
  ok
}

# $1 is a command only if it is not a flag, so bare nx still deploys.
cmd=deploy
case "${1-}" in
  "" | -*) ;;
  *)
    cmd=$1
    shift
    ;;
esac

case "$cmd" in
  deploy) cmd_deploy "$@" ;;
  up) cmd_deploy -u "$@" ;;
  check) cmd_check ;;
  clean) cmd_clean "$@" ;;
  back) cmd_back ;;
  lock) cmd_lock ;;
  help | --help) usage ;;
  *)
    fail "Unknown command '$cmd'."
    usage >&2
    exit 1
    ;;
esac
