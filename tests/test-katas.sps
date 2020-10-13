#!/usr/bin/env scheme-script
;; -*- mode: scheme; coding: utf-8 -*- !#
;; Copyright (c) 2020 Guy Q. Schemer
;; SPDX-License-Identifier: MIT
#!r6rs

(import (rnrs (6))
        (srfi :64 testing)
        (srfi :13 strings)
        (katas))
 
;;(test-log-to-file "./trigrams.log")

(test-begin "Trigrams")
(define trigram-text (gen-trigram-text "I wish I may I wish I might"))
(test-assert "get trigram-text returns a string" (string? trigram-text))
(test-assert "gen-trigram-text length is at least 3" (> (length (string-tokenize trigram-text)) 2))

(define short-trigram-text (gen-trigram-text "too short"))
(test-equal "short text returns an empty string" "" short-trigram-text)
(test-end)

(exit (if (zero? (test-runner-fail-count (test-runner-get))) 0 1))

