{ pkgs ? import (import ../pins/nixpkgs) {}
, ndn-cpp ? pkgs.callPackage ../ndn-cpp {}
, racket2nix ? import (import ../pins/racket2nix) {}
}:

let
  inherit (racket2nix) buildRacketPackage;
in

(buildRacketPackage ./.).overrideAttrs (oldAttrs: { buildInputs = oldAttrs.buildInputs ++ [ ndn-cpp ]; })
