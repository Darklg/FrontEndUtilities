#!/bin/bash

function frontendutilities_center_icon() {

    local INPUT_FILE="${2:-}"
    local OUTPUT_FILE="${3:-}"

    if ! command -v inkscape >/dev/null 2>&1; then
        echo "Error: inkscape is not installed"
        return 0;
    fi

    if [[ -z "${INPUT_FILE}" ]]; then

        local _PARSE_ALL_FILES;
        read -r -p "No input file specified. Do you want to process all .svg files in the current directory? (y/N) " _PARSE_ALL_FILES
        if [[ "${_PARSE_ALL_FILES}" != "y" ]]; then
            echo "Aborting."
            return 0;
        fi

        shopt -s nullglob
        local svgs=( *.svg )
        shopt -u nullglob

        if [[ ${#svgs[@]} -eq 0 ]]; then
            echo "No .svg file found in current directory"
            return 0;
        fi

        local f
        for f in "${svgs[@]}"; do
            frontendutilities_center_icon_one "${f}"
        done
        return 0;
    fi

    frontendutilities_center_icon_one "${INPUT_FILE}" "${OUTPUT_FILE}"
}

function frontendutilities_center_icon_one() {

    local INPUT_FILE="${1:-}"
    local OUTPUT_FILE="${2:-}"

    if [[ -z "${OUTPUT_FILE}" ]]; then
        OUTPUT_FILE="${INPUT_FILE}";
    fi;

    if [[ ! -f "${INPUT_FILE}" ]]; then
        echo "Error: input file does not exist: ${INPUT_FILE}"
        return 0;
    fi

    export LC_ALL=C

    read -r X Y W H <<< "$(
    inkscape "${INPUT_FILE}" --query-all \
    | awk -F',' '
        BEGIN {minx=""; miny=""; maxx=""; maxy=""}
        NF >= 5 {
        x=$2+0; y=$3+0; w=$4+0; h=$5+0;
        if (minx=="" || x<minx) minx=x;
        if (miny=="" || y<miny) miny=y;
        if (maxx=="" || (x+w)>maxx) maxx=x+w;
        if (maxy=="" || (y+h)>maxy) maxy=y+h;
        }
        END {
        if (minx=="" || miny=="" || maxx=="" || maxy=="") exit 1;
        printf "%.6f %.6f %.6f %.6f", minx, miny, maxx-minx, maxy-miny;
        }'
    )"

    if [[ -z "${W}" || -z "${H}" ]]; then
        echo "Error: failed to compute bounding box for ${INPUT_FILE}"
        return 0;
    fi

    local SIZE="$(awk -v w="${W}" -v h="${H}" 'BEGIN {printf "%.6f", (w>h)?w:h}')"
    local OFFSET_X="$(awk -v s="${SIZE}" -v w="${W}" -v x="${X}" 'BEGIN {printf "%.6f", x-((s-w)/2)}')"
    local OFFSET_Y="$(awk -v s="${SIZE}" -v h="${H}" -v y="${Y}" 'BEGIN {printf "%.6f", y-((s-h)/2)}')"

    local VIEWBOX="${OFFSET_X} ${OFFSET_Y} ${SIZE} ${SIZE}"

    inkscape "${INPUT_FILE}" \
    --export-plain-svg \
    --export-filename="${OUTPUT_FILE}"

    local TMP_FILE="$(mktemp)"

    _SVG_VIEWBOX="${VIEWBOX}" _SVG_SIZE="${SIZE}" perl -0pe '
    my $viewbox = $ENV{"_SVG_VIEWBOX"};
    my $size    = $ENV{"_SVG_SIZE"};

    s{<svg\b(.*?)>}{
        my $attrs = $1;

        $attrs =~ s/\s+viewBox="[^"]*"//g;
        $attrs =~ s/\s+width="[^"]*"//g;
        $attrs =~ s/\s+height="[^"]*"//g;

        qq{<svg$attrs viewBox="$viewbox" width="$size" height="$size">};
    }se
    ' "${OUTPUT_FILE}" > "${TMP_FILE}"

    mv "${TMP_FILE}" "${OUTPUT_FILE}"

    echo "centered: ${INPUT_FILE}";
}


frontendutilities_center_icon $@
