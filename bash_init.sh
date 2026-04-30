#!/bin/bash

alias ll='ls -alFh'
alias cd2='cd ../..'
alias ec='emacsclient -c'

export COLORTERM=truecolor

if command -v emacs &> /dev/null; then
    export VISUAL='emacs -nw'
    export EDITOR="${VISUAL}"
fi
