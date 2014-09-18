#!/bin/sh

if [ ! -d ~/.quicklisp ] ; then
    echo '(quicklisp-quickstart:install :path "~/.quicklisp/")
    (ql:update-client)
    (ql:update-all-dists)
    (quit)' | sbcl --noinform --load /tmp/quicklisp.lisp
else
    echo '(ql:update-client)
    (ql:update-all-dists)
    (quit)' | sbcl --noinform
fi
