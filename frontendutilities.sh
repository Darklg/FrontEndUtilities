#!/bin/bash

cat <<TXT
###################################
## Frontend Utilities v 0.4.0
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
    "fix-icons")
        . "${_SOURCEDIR}bin/fix-icons.sh"
        ;;
    "" | "help")
        echo "Help :"
        echo "- frontendutilities order-fonts";
        echo "- frontendutilities fix-icons";
        ;;
    *)
        echo "frontendutilities: '$1' is not a frontendutilities command."
        ;;
    esac

    # Clean
    . "${_SOURCEDIR}bin/stop.sh"

}
frontendutilities_init $@
