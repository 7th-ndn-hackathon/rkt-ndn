#lang racket/base

(require ffi/unsafe)
(require ffi/unsafe/define)
(require ffi/unsafe/define/conventions)

(provide (all-defined-out))

(define ndn-lib (ffi-lib "libndn-c"))

(define-ffi-definer define-ndn ndn-lib #:make-c-id convention:hyphen->camelcase)
