{
  # Shared system modules pulled in by every host (see flake.nix mkHost).
  imports = [
    ./common.nix
    ./stylix.nix
  ];
}
