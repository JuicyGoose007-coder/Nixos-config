{ pkgs, ... }:

let
  nls = pkgs.buildGoModule rec {
    pname = "nls";
    version = "0.12.0";

    src = pkgs.fetchFromGitHub {
      owner = "nolight132";
      repo = "nls";
      rev = "v${version}";
      hash = "sha256-OlFiMd8Q8qmhWJi0Ge0Tudid3vlTPO2Zc7gdR4OBjb8=";
    };

    vendorHash = "sha256-BPSYn+oL6OTdKCcIcmTZnyUui+5IH+ZXD10FHjJlMOs=";

    subPackages = [ "cmd/nls" ];

    meta = {
      description = "Nushell-inspired ls replacement";
      homepage = "https://github.com/nolight132/nls";
      mainProgram = "nls";
    };
  };
in
{
  home.packages = [ nls ];
}
