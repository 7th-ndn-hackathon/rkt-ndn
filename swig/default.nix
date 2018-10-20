{ pkgs ? import (import ../pins/nixpkgs) {}
, ndn-cpp ? pkgs.callPackage ../ndn-cpp {}
}:

let inherit (pkgs) libtool stdenv swig; in

stdenv.mkDerivation {
  name = "rkt-ndn-swig";
  nativeBuildInputs = [ libtool swig ndn-cpp ];
  src = ./.;
  buildPhase = ''
    for i in $(cd ${ndn-cpp.out}/include/ndn-cpp; find lite -name '*.hpp'); do
      mkdir -p ''${i%/*}
      i_base=''${i##*/}
      i_base_under=''${i_base//-/_}
      cat > ''${i%.hpp}.i <<EOF
    %module ''${i_base_under%.hpp}
    %{
    #include <ndn-cpp/$i>
    %}

    %include <ndn-cpp/$i>
    EOF
    swig -I${ndn-cpp.out}/include -c++ -mzscheme -declaremodule ''${i%.hpp}.i
    done
  '';

  installPhase = ''
    for i in $(find . -name '*_wrap.cxx'); do
      mkdir -p $out/''${i%/*}
      cp $i $out/$i
    done
  '';
}
