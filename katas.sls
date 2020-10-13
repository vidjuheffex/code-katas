;; -*- mode: scheme; coding: utf-8 -*-
;; Copyright (c) 2020 Guy Q. Schemer
;; SPDX-License-Identifier: MIT
#!r6rs

(library (katas)
  (export gen-trigram-text)
  (import (chezscheme)
          (prefix (srfi :13 strings) srfi13:)
          (prefix (srfi :27 random-bits) srfi27:))

  (define make-trigram-hashtable
    (lambda (text)
      (let ([trigram-hashtable (make-hashtable string-hash string=?)]
            [text-list (srfi13:string-tokenize text)])
        (let build-table ([l text-list])
          (if (> (length l) 2)
              (let ([word-pair-hash (string-append (car l) " " (car (cdr l)))])
                (hashtable-set! trigram-hashtable word-pair-hash
                                (cons (car (cdr (cdr l)))
                                      (hashtable-ref trigram-hashtable word-pair-hash '())))
                (build-table (cdr l))))
          trigram-hashtable))))

  (define get-random-word-pair-string
    (lambda (trigram-hashtable)
      (if (not (eq? (hashtable-size trigram-hashtable) 0))
          (let* ([keys (hashtable-keys trigram-hashtable)]
                 [keys-length (vector-length keys)])
            (vector-ref keys (srfi27:random-integer keys-length))))))

  (define build-trigram-string
    (lambda (trigram-hashtable)
      (if (eq? (hashtable-size trigram-hashtable) 0) ""
          (let ([word-pair (get-random-word-pair-string trigram-hashtable)])
            (let build-string ([word-pair word-pair]
                               [gen-text word-pair])
              (let ([word-list (hashtable-ref trigram-hashtable word-pair '())])
                (if (null? word-list)
                    gen-text
                    (let* ([new-word (list-ref word-list (srfi27:random-integer (length word-list)))]
                           [new-string-pair (string-append
                                             (car (cdr (srfi13:string-tokenize word-pair)))
                                             " "
                                             new-word)])
                      (build-string new-string-pair (string-append gen-text " " new-word))))))))))

  (define gen-trigram-text
    (lambda (text)
      (let ([trigram-hashtable (make-trigram-hashtable text)])
        (build-trigram-string trigram-hashtable)))))



