#!/bin/bash

function frontendutilities_fix_icons(){

    local _newfile;
    local _has_svgo=1;
    local _answer;
    local svg_files;
    local can_override=0;
    local inkscape_meta_files;

    # Test if inkscape is installed
    if ! command -v inkscape >/dev/null 2>&1; then
        echo "Error: inkscape is not installed or not in PATH."
        return 0;
    fi;

    # Test if svgo is installed
    if ! command -v svgo >/dev/null 2>&1; then
        echo "Notice: svgo is not installed or not in PATH."
        echo "You can install it with 'npm install -g svgo'."
        _has_svgo=0;
    fi;

    # Find SVG files in the current directory containing "stroke-width"
    svg_files=($(find . -type f -name "*.svg" -exec grep -l "stroke-width=" {} +))

    # Find SVG files containing inkscape metadata and add them to the list
    inkscape_meta_files=($(find . -type f -name "*.svg" -exec grep -l "inkscape:" {} +))
    for file in "${inkscape_meta_files[@]}"; do
        # Add file if not already in svg_files
        if [[ ! " ${svg_files[*]} " =~ " ${file} " ]]; then
            svg_files+=("$file")
        fi
    done

    # If no SVG files are found, return
    if [[ ${#svg_files[@]} -eq 0 ]]; then
        echo "No SVG files found with 'stroke-width' or inkscape metadata."
        read -p "Do you want to continue anyway? (y/N): " _answer
        if [[ ! "$_answer" =~ ^[Yy]$ ]]; then
            return 0
        fi
        svg_files=($(find . -type f -name "*.svg"));
    fi;

    # Ask if the user wants to override existing files
    read -p "Do you want to override existing files? (y/N): " _answer
    if [[ "$_answer" =~ ^[Yy]$ ]]; then
        can_override=1;
    else
        echo "Existing files will not be overridden."
    fi

    # Process each SVG file
    for svg_file in "${svg_files[@]}"; do
        echo "Processing $svg_file..."
        _newfile="${svg_file%.svg}-fixed.svg";
        if [[ "$can_override" -eq 1 ]]; then
            _newfile="${svg_file}";
        fi;

        # Convert strokes to fills
        inkscape \
            --actions="select-all;object-stroke-to-path;export-filename:${_newfile};export-plain-svg;export-do;file-close" \
            "$svg_file"

        # Clean up the new file
        if [[ "${_has_svgo}" -eq 1 ]]; then
            svgo \
                "${_newfile}" \
                --config="${_SOURCEDIR}bin/tools/fix-icons-svgo-config.cjs"
        fi;
    done;

}

frontendutilities_fix_icons;
