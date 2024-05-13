#!/bin/bash

cat <<TXT
###################################
## Frontend Utilities v 0.1.0
###################################
TXT

function frontendutilities_init() {
    local _SOURCEDIR="$(dirname "${BASH_SOURCE[0]}")/"
    local _CURRENTDIR="$(pwd)/"

    case "$1" in
    "order-fonts")
        . "${_SOURCEDIR}bin/order-fonts.sh"
        ;;
    *)
        echo "frontendutilities: '$1' is not a frontendutilities command."
        ;;
    esac

}
frontendutilities_init $@
