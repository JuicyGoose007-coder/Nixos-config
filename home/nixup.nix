# The nixup derivation itself lives in modules/nixup.nix as a flake package
# output. This module only installs it, the same way home/packages.nix pulls
# zen-browser out of its flake.
{
  inputs,
  pkgs,
  ...
}:

{
  home.packages = [
    inputs.self.packages.${pkgs.stdenv.hostPlatform.system}.nixup
  ];
}
