#!/bin/bash


###################################
## Autocomplete commands
###################################

_frontendutilities_complete() {
    local cur prev

    COMPREPLY=()
    cur=${COMP_WORDS[COMP_CWORD]}
    prev=${COMP_WORDS[COMP_CWORD-1]}

    if [ $COMP_CWORD -eq 1 ]; then
        COMPREPLY=( $(compgen -W "fix-icons order-fonts" -- $cur) )
    elif [ $COMP_CWORD -eq 2 ]; then
        case "$prev" in
            "order-fonts")
                COMPREPLY=( $(compgen -W "cssc-font-face font-face" -- $cur) )
            ;;
            *)
            ;;
        esac
    fi

    return 0
}

complete -F _frontendutilities_complete frontendutilities
