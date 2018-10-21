#lang racket

(require ndn-cpp-c-bindings/common)

(module+ main
  (printf "epoch milliseconds: ~a~n" (get-now-milliseconds)))
