#lang racket/base

(require ffi/unsafe)

(require ndn-cpp-c-bindings/ffi)

(provide (all-defined-out))

(define ndn_Milliseconds _double)
(define ndn_MillisecondsSince1970 _double)

(define-ndn ndn_getNowMilliseconds (_fun -> ndn_MillisecondsSince1970))

(define MAX_NDN_PACKET_SIZE 8800)
(define ndn_SHA256_DIGEST_SIZE 32)
(define ndn_AES_128_BLOCK_SIZE 16)
