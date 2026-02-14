#!/bin/bash

sbcl \
    --noinform \
    --eval '(asdf:load-system :cl-divsufsort)' \
    --eval '(asdf:test-system :cl-divsufsort)' \
    --quit
