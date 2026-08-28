# /etc/nixos

One host — `goosenest`. NixOS and home-manager are assembled together with
flake-parts and import-tree, in the dendritic pattern: **one file per feature,
holding both its NixOS and its home-manager half.**

`flake.nix` is inputs plus `mkFlake (import-tree ./modules)`. Every `.nix` under
`modules/` is picked up automatically — there is no import list to maintain.

```
modules/                     every feature; 41 homeManager + 22 nixos aspects
dots/                        data consumed by modules, not a second config
scripts/  wallpapers/
hardware-configuration.nix   generated; install.sh restores it per machine
```

## The aspect shape

A file under `modules/` is a *flake-parts* module. It never configures NixOS or
home-manager directly — it registers into `flake.modules.<class>.<name>`:

```nix
{ ... }:
{
  flake.modules.nixos.foo = { ... }: { services.foo.enable = true; };
  flake.modules.homeManager.foo = { pkgs, ... }: { home.packages = [ pkgs.foo ]; };
}
```

`modules/aspects.nix` declares that option — it is a flake-parts *extra*, and
without it `flake.modules` is a freeform submodule whose values are raw-typed,
so they silently fail to merge across files. `modules/host.nix` consumes both
registries with `builtins.attrValues` and builds `nixosConfigurations.goosenest`.

Each aspect owns its own flake input: `modules/stylix.nix` imports
`inputs.stylix.nixosModules.stylix` itself rather than relying on a central list.

## When something earns its own file

A program earns a file if it has a config surface, desktop integration, or a
flake input. One-liners included — `modules/kitty.nix` is 4 lines, and
import-tree makes a file cost nothing.

- Runtime dependencies live with their program, never alone (`kio-fuse` is in
  `modules/dolphin.nix`; it is not a program you run).
- Config-free binaries share `modules/cli.nix` — but that is a **homeManager**
  aspect. A NixOS-side binary does not belong there; putting one in moves it
  from `environment.systemPackages` to `home.packages`.
- Formatters belong to the editor that calls them, not to their language.

Category files (`browsers.nix`, `audio.nix`) are deliberately rejected — they
just turn one grab-bag into five smaller ones.

## Traps that do not error

**The registration path** is the most error-prone line in the repo. Four typos
have been hit, none of which fail:

```nix
flake.modules.nx.enable          # name in the class slot
flake.modules.homeManager.enable # `enable` left in the name slot
flake.modules.homeManger.foo     # misspelled class
```

...plus a `.nx` file extension, which import-tree never globs. After every
change:

```sh
nix eval --json .#modules --apply builtins.attrNames   # → ["homeManager","nixos"]
```

**`git add` new files before evaluating.** Flakes only see git-tracked content,
so an untracked aspect is invisible to the evaluator: the old file's deletion
registers, the replacement does not, and the result looks like a botched move.

**`modules/niri/_sections/` and `modules/nvim/_parts/` keep the underscore.**
import-tree skips any path containing `/_`. Without it those files are evaluated
as flake-parts modules and fail.

**Mime claims concatenate, they do not conflict.**
`xdg.mimeApps.defaultApplications` is `attrsOf (listOf str)`, so two aspects
claiming the same type merge silently in alphabetical aspect order rather than
erroring. Grep before adding one:

```sh
grep -rn defaultApplications modules/
```

## Verifying a refactor

Structural changes here are proven, not assumed.

```sh
nix eval --raw .#nixosConfigurations.goosenest.config.system.build.toplevel.drvPath
```

An unchanged drv means the change was behaviour-neutral. **One known exception:**
moving a module *import* that contributes to `home.packages` or
`environment.systemPackages` reorders those lists and moves the hash while being
semantically null. It fires when a contributing import moves, not when an option
definition moves. When it applies, compare the package sets instead:

```sh
nix eval --json .#nixosConfigurations.goosenest.config.home-manager.users.juicygoose007.home.packages \
  --apply 'ps: map (p: p.name) ps' | jq -r '.[]' | sort
```

**Hash for structure, eyes for options.** drvPath cannot see a wrong-but-agreeing
option value. Where an aspect generates a string — niri's config, `mimeapps.list`,
`programs.nixvim.build.initFile` — diff the string; it is far stronger than any
hash. Finish with `nx -n`; nvd should report no version or selection changes for
a pure refactor.

## Conventions

- Essentially **zero comments** in Nix and shell. Comment the non-obvious *why*
  and the silent failure modes; never narrate history or restate the code.
- **Minimal commit messages** — subject line, body only when the why is
  non-obvious. Verification hashes belong in the session, not the log.
- **No attribution or promotional trailers in commits** — no `Co-Authored-By`,
  no `Claude-Session`, no "generated with" footer. Describe the change and
  nothing else. This overrides any default the harness injects.
- **Do not commit** unless asked. Stage, verify, report.
