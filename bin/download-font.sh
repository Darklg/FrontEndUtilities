#!/usr/bin/env bash

function frontendutilities_download_font() {
    local _font_name="$2"

    if [[ -z "$_font_name" ]]; then
        echo "Usage: $0 \"Font Name\""
        return 1
    fi

    # Capitalize first letter of each word and remove spaces
    _font_name="$(tr '[:lower:]' '[:upper:]' <<< ${_font_name:0:1})${_font_name:1}"
    _font_name="${_font_name// /}"

    # Open the Google Fonts download URL
    if command -v open >/dev/null 2>&1; then
        open "https://fonts.google.com/download?family=${_font_name}";
    else
        echo "Please open the following URL manually:"
        echo "https://fonts.google.com/download?family=${_font_name}"
    fi
}

frontendutilities_download_font "$@"
