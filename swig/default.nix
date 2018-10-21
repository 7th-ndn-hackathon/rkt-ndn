{ pkgs ? import (import ../pins/nixpkgs) {}
, ndn-cpp ? pkgs.callPackage ../ndn-cpp {}
, racket2nix ? import (import ../pins/racket2nix) {}
}:

let
  inherit (pkgs) libtool stdenv swig;
  inherit (racket2nix) buildRacketPackage;
in

let src = stdenv.mkDerivation {
  name = "ndn-cpp-lite-bindings";
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
    extensions=$(find lite -name '*_wrap.cxx')
    for i in $extensions; do
      mkdir -p $out/''${i%/*}
      cp $i $out/''$i
    done
    cat > $out/install.rkt <<EOF
    #lang racket

    (require make/setup-extension)
    (require dynext)

    (provide pre-installer)

    (define extensions (string-split "$extensions"))

    (define (pre-installer collections-top-path collection-path)
      (for [(extension extensions)]
        (eprintf "extension '~a'~n" extension)
        (pre-install collection-path
                     (build-path collection-path "private")
                     extension
                     "."
                     '() '() '() '() '() '()
                     (lambda (thunk) (thunk)))))
    EOF
    cp info.rkt $out
  '';
}; in

buildRacketPackage src
