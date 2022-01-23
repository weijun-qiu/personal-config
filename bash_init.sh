#!/bin/bash

if command -v emacs &> /dev/null; then
    export VISUAL='emacs -nw'
    export EDITOR="${VISUAL}"
fi
