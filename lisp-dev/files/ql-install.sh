#!/bin/sh

echo '(quicklisp-quickstart:install :path "$HOME/.quicklisp/")
(ql:update-client)
(ql:update-all-dists)
(quit)' | sbcl --noinform --load /tmp/quicklisp.lisp
