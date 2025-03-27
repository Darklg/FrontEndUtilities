#!/bin/bash

function frontendutilities_order_fonts() {
    local font_file
    local font_name
    local font_name_no_ext
    local font_name_no_ext_base
    local file
    local font_weight
    local font_style
    local font_rel_path

    local _dir="${_CURRENTDIR}assets/fonts/"

    # Stop if the 'raw' directory is empty
    if [[ ! -d "${_dir}raw" ]]; then
        echo "The dir '${_dir}raw' does not exists"
        return 0
    fi
    if [[ -z "$(ls -A ${_dir}raw)" ]]; then
        echo "The dir '${_dir}raw' is empty"
        return 0
    fi

    _lastfontname="";

    # Browse all files in the 'raw' directory
    for file in ${_dir}raw/*.woff; do

        # Remove 'subset-' prefix and get font name and extension
        font_file=$(basename "$file")
        font_name=${font_file#subset-}
        font_name_no_ext=${font_name%.*}
        font_name_no_ext_base=${font_name_no_ext}

        # Replace -Black, -BlackItalic, etc in font_name_no_ext
        font_name_no_ext=${font_name_no_ext//-BlackItalic/}
        font_name_no_ext=${font_name_no_ext//-Black/}
        font_name_no_ext=${font_name_no_ext//-ExtraBoldItalic/}
        font_name_no_ext=${font_name_no_ext//-ExtraBold/}
        font_name_no_ext=${font_name_no_ext//-BoldItalic/}
        font_name_no_ext=${font_name_no_ext//-Bold/}
        font_name_no_ext=${font_name_no_ext//-SemiBoldItalic/}
        font_name_no_ext=${font_name_no_ext//-SemiBold/}
        font_name_no_ext=${font_name_no_ext//-MediumItalic/}
        font_name_no_ext=${font_name_no_ext//-Medium/}
        font_name_no_ext=${font_name_no_ext//-Regular/}
        font_name_no_ext=${font_name_no_ext//-Italic/}
        font_name_no_ext=${font_name_no_ext//-LightItalic/}
        font_name_no_ext=${font_name_no_ext//-Light/}
        font_name_no_ext=${font_name_no_ext//-BookItalic/}
        font_name_no_ext=${font_name_no_ext//-Book/}
        font_name_no_ext=${font_name_no_ext//-ThinItalic/}
        font_name_no_ext=${font_name_no_ext//-Thin/}

        # Detect font weight
        font_weight='400'
        if [[ $font_name == *"-Black"* ]]; then
            font_weight='900'
        elif [[ $font_name == *"-ExtraBold"* ]]; then
            font_weight='800'
        elif [[ $font_name == *"-Bold"* ]]; then
            font_weight='700'
        elif [[ $font_name == *"-SemiBold"* ]]; then
            font_weight='600'
        elif [[ $font_name == *"-Medium"* ]]; then
            font_weight='500'
        elif [[ $font_name == *"-Regular"* ]]; then
            font_weight='400'
        elif [[ $font_name == *"-Light"* || $font_name == *"-Book"* ]]; then
            font_weight='300'
        elif [[ $font_name == *"-Thin"* ]]; then
            font_weight='100'
        fi

        # Detect font style
        font_style='normal'
        if [[ $font_name == *"Italic"* ]]; then
            font_style='italic'
        fi

        # Create a new directory for each font
        mkdir -p "${_dir}$font_name_no_ext"

        # Move files to the correct directory
        cp "$file" "${_dir}$font_name_no_ext/$font_name"
        if [[ -f "${file}2" ]]; then
            cp "${file}2" "${_dir}$font_name_no_ext/${font_name}2"
        fi

        if [[ "$_lastfontname" != "$font_name_no_ext" ]]; then
            _lastfontname="$font_name_no_ext";
            echo "/* $font_name_no_ext */";
        fi

        # Generate a list of @font-face for each file
        font_rel_path="../fonts/$font_name_no_ext/$font_name_no_ext_base"
        if [[ "${2}" == "font-face" ]]; then
            echo "@font-face {"
            echo "    font-family: '$font_name_no_ext';"
            echo "    font-style: $font_style;"
            echo "    font-weight: $font_weight;"
            echo "    src: url('$font_rel_path.woff2') format('woff2'),"
            echo "         url('$font_rel_path.woff') format('woff');"
            echo "}"
        else
            echo "@include cssc-font-face('$font_name_no_ext', '${font_rel_path}', $font_weight, $font_style, woff2 woff);"
        fi
    done


    # Remove the 'raw' directory
    read -r -p "Do you want to remove the 'raw' directory? [y/N] " yn
    if [[ "$yn" == "y" ]]; then
        rm -rf "${_dir}raw";
        echo "The 'raw' directory has been removed";
    fi

}
frontendutilities_order_fonts $@
