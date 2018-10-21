#lang racket/base

(require ffi/unsafe)
(require ffi/unsafe/define)

(provide (all-defined-out))

(define ndn-lib (ffi-lib "libndn-c" "0"))

(define-ffi-definer define-ndn ndn-lib)
