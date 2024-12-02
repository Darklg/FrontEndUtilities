#!/bin/bash

cat <<TXT
###################################
## Frontend Utilities v 0.2.1
###################################
TXT

function frontendutilities_init() {
    local _SOURCEDIR="$(dirname "${BASH_SOURCE[0]}")/"
    local _CURRENTDIR="$(pwd)/"

    # Autocomplete
    . "${_SOURCEDIR}bin/autocomplete.sh"

    case "$1" in
    "order-fonts")
        . "${_SOURCEDIR}bin/order-fonts.sh"
        ;;
    *)
        echo "frontendutilities: '$1' is not a frontendutilities command."
        ;;
    esac

    # Clean
    . "${_SOURCEDIR}bin/stop.sh"

}
frontendutilities_init $@
