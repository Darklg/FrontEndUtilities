#!/bin/bash


###################################
## Fonts dir : must be run from a dir containing assets/fonts/
###################################

function frontendutilities_get_fonts_dir() {
    if [[ ! -d "${_CURRENTDIR}assets/fonts" ]]; then
        echo "/!\ No 'assets/fonts' dir in '${_CURRENTDIR}' : run this command from the theme root." >&2
        return 1
    fi
    echo "${_CURRENTDIR}assets/fonts/"
}
