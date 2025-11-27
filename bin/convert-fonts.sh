#!/bin/bash

function frontendutilities_convert_fonts(){
    local _base;
    local _f;
    local _dir="${_CURRENTDIR}assets/fonts/";

    # Test if pyftsubset is installed
    if ! command -v pyftsubset >/dev/null 2>&1; then
        echo "Error: pyftsubset is not installed or not in PATH."
        echo "You can install it with 'pip install fonttools'."
        return 0;
    fi;

    # Stop if the 'raw' directory is empty
    if [[ ! -d "${_dir}raw" ]]; then
        echo "The dir '${_dir}raw' does not exists"
        return 0
    fi
    if [[ -z "$(ls -A ${_dir}raw)" ]]; then
        echo "The dir '${_dir}raw' is empty"
        return 0
    fi

    cd "${_dir}raw";

    for _f in *.ttf; do
        _base="${_f.*}"
        pyftsubset "$_f" --output-file="${_base}.woff" \
            --flavor=woff --layout-features='*' \
            --unicodes="U+0000-00FF,U+0100-024F"
        pyftsubset "$_f" --output-file="${_base}.woff2" \
            --flavor=woff2 --layout-features='*' \
            --unicodes="U+0000-00FF,U+0100-024F"
    done;

    cd "${_CURRENTDIR}";

    echo "Font conversion completed.";

    # Clean
    . "${_SOURCEDIR}bin/stop.sh"

}

frontendutilities_convert_fonts;
