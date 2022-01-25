#!/bin/bash

alias ll='ls -alFh'
alias cd2='cd ../..'

if command -v emacs &> /dev/null; then
    export VISUAL='emacs -nw'
    export EDITOR="${VISUAL}"
fi
