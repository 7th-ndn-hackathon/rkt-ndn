{ pkgs ? import (import ../pins/nixpkgs) {}
, ndn-cpp ? pkgs.callPackage ../ndn-cpp {}
}:

let inherit (pkgs) libtool stdenv swig; in

stdenv.mkDerivation {
  name = "rkt-ndn-swig";
  nativeBuildInputs = [ libtool swig ndn-cpp ];
  src = ./.;
  buildPhase = ''
    swig -I${ndn-cpp.out}/include -c++ -mzscheme -declaremodule face.i
  '';

  installPhase = ''
    mkdir -p $out
    cp face_wrap.cxx $out/
  '';
}
