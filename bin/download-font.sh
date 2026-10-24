#!/usr/bin/env bash

function frontendutilities_download_font() {
    local _api="https://api.fontsource.org/v1/fonts"
    local _font_name="${*:2}"
    local _font_id _font_json _query _matches _count _choice _dir _family
    local _weight _style _url _weight_name _file _files _total _i=0

    if [[ -z "$_font_name" ]]; then
        echo "Usage: frontendutilities download-font \"Font Name\""
        return 1
    fi
    if ! command -v jq >/dev/null 2>&1; then
        echo "jq is required."
        return 1
    fi

    # Try the exact slug first
    _font_id="$(tr '[:upper:]' '[:lower:]' <<< "$_font_name" | tr ' ' '-')"
    _font_json="$(curl -fsSL "${_api}/${_font_id}" 2>/dev/null)"

    # Fallback : search families containing the query (case and spaces ignored)
    if [[ -z "$_font_json" ]]; then
        _query="$(tr '[:upper:]' '[:lower:]' <<< "$_font_name" | tr -d ' ')"
        _matches="$(curl -fsSL "$_api" | jq -r --arg q "$_query" '.[] | select(.family | ascii_downcase | gsub(" "; "") | contains($q)) | "\(.id)\t\(.family)"' | head -n 10)"
        _count="$(grep -c . <<< "$_matches")"

        if [[ "$_count" == "0" ]]; then
            echo "No font found for '${_font_name}'."
            return 1
        elif [[ "$_count" == "1" ]]; then
            read -r -p "Did you mean '$(cut -f2 <<< "$_matches")' ? [Y/n] " _choice
            if [[ "$_choice" =~ ^[nN] ]]; then
                return 1
            fi
            _font_id="$(cut -f1 <<< "$_matches")"
        else
            echo "Several fonts found for '${_font_name}' :"
            cut -f2 <<< "$_matches" | nl -w2 -s'. '
            read -r -p "Choose a number : " _choice
            if [[ ! "$_choice" =~ ^[0-9]+$ ]] || (( _choice < 1 || _choice > _count )); then
                echo "Invalid choice."
                return 1
            fi
            _font_id="$(sed -n "${_choice}p" <<< "$_matches" | cut -f1)"
        fi
        _font_json="$(curl -fsSL "${_api}/${_font_id}")"
    fi

    # Target dir : assets/fonts/raw if in a project root, else current dir
    _family="$(jq -r '.family' <<< "$_font_json" | tr -d ' ')"

    _dir="./${_family}/"
    if [[ -d "./assets/fonts" ]]; then
        _dir="./assets/fonts/raw/${_family}/"
    fi
    mkdir -p "$_dir"

    # Static ttf files only, latin-ext with latin fallback
    _files="$(jq -r '.variants | to_entries[] | .key as $w | .value | to_entries[] | "\($w) \(.key) \((.value["latin-ext"] // .value.latin).url.ttf // empty)"' <<< "$_font_json")"
    _total="$(grep -c . <<< "$_files")"
    if [[ "$_total" == "0" ]]; then
        echo "No latin-ext or latin files found for '${_font_id}'."
        return 1
    fi

    while read -r _weight _style _url; do
        case "$_weight" in
            100) _weight_name="Thin" ;;
            200) _weight_name="ExtraLight" ;;
            300) _weight_name="Light" ;;
            500) _weight_name="Medium" ;;
            600) _weight_name="SemiBold" ;;
            700) _weight_name="Bold" ;;
            800) _weight_name="ExtraBold" ;;
            900) _weight_name="Black" ;;
            *) _weight_name="Regular" ;;
        esac
        if [[ "$_style" == "italic" ]]; then
            _weight_name="${_weight_name/Regular/}Italic"
        fi

        _file="${_dir}${_family}-${_weight_name}.ttf"
        _i=$((_i + 1))
        if [[ -f "$_file" ]]; then
            echo "- ${_i}/${_total} ${_file} already exists"
            continue
        fi
        if curl -fsSL "$_url" -o "$_file"; then
            echo "- ${_i}/${_total} ${_file} downloaded"
        else
            rm -f "$_file"
            echo "/!\ ${_i}/${_total} ${_file} failed"
        fi
    done <<< "$_files"
}

frontendutilities_download_font "$@"
