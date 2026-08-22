# The aspect registry.
#
# Turns on `flake.modules.<class>.<name>` — the option every topic file in this
# repo registers itself into (see modules/superfile.nix for the first one).
# It is a flake-parts *extra*: mkFlake does not include it, so without this
# import the option is undeclared. `flake` is a freeform submodule, so a bare
# `flake.modules = ...` would appear to work, but the values would be raw-typed:
# they would not merge across files and would carry no module `_class`.
#
# The classes used here are "nixos" and "homeManager" — the same strings NixOS
# and home-manager evaluate their own module trees with, so a module registered
# under the wrong class fails loudly instead of silently.
#
# Consumed in modules/host.nix via `config.flake.modules.<class>`.
{ inputs, ... }:

{
  imports = [ inputs.flake-parts.flakeModules.modules ];
}
