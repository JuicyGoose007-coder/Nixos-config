# Which systems flake-parts should instantiate `perSystem` outputs for
# (packages, devShells, checks...). Only this machine's platform for now.
{
  systems = [ "x86_64-linux" ];
}
