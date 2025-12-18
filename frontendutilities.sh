#!/bin/bash

cat <<TXT
###################################
## Frontend Utilities v 0.7.0
###################################
TXT

function frontendutilities_init() {
    local _SOURCEDIR="$(dirname "${BASH_SOURCE[0]}")/"
    local _CURRENTDIR="$(pwd)/"


    local _help_text="Help :\n\
- frontendutilities convert-fonts\n\
- frontendutilities fix-icons\n\
- frontendutilities order-fonts\n\
- frontendutilities download-font\n";


    # Autocomplete
    . "${_SOURCEDIR}bin/autocomplete.sh";

    case "$1" in
    "order-fonts" | "convert-fonts" | "fix-icons" | "download-font" )
        . "${_SOURCEDIR}bin/${1}.sh";
        ;;
    "" | "help")
        echo -e "${_help_text}";
        ;;
    *)
        echo -e "/!\ '$1' is not a frontendutilities command."
        echo -e "${_help_text}";
        ;;
    esac

    # Clean
    . "${_SOURCEDIR}bin/stop.sh"

}
frontendutilities_init $@
