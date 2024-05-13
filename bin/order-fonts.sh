#!/bin/bash

function frontendutilities_order_fonts() {
    local font_file
    local font_name
    local font_name_no_ext
    local font_name_no_ext_base
    local file
    local font_weight
    local font_style

    if [[ ! -d "assets/fonts/raw" ]]; then
        echo 'The dir "assets/fonts/raw" does not exists'
        return 0
    fi

    # Parcourir tous les fichiers dans le répertoire 'raw'
    for file in assets/fonts/raw/*.woff; do

        # Supprimer le préfixe 'subset-' et obtenir le nom de la police et l'extension
        font_file=$(basename "$file")
        font_name=${font_file#subset-}
        font_name_no_ext=${font_name%.*}
        font_name_no_ext_base=${font_name_no_ext}

        # Replace -Black, -BlackItalic, etc in font_name_no_ext
        font_name_no_ext=${font_name_no_ext//-BlackItalic/}
        font_name_no_ext=${font_name_no_ext//-Black/}
        font_name_no_ext=${font_name_no_ext//-BoldItalic/}
        font_name_no_ext=${font_name_no_ext//-Bold/}
        font_name_no_ext=${font_name_no_ext//-Italic/}
        font_name_no_ext=${font_name_no_ext//-LightItalic/}
        font_name_no_ext=${font_name_no_ext//-Light/}
        font_name_no_ext=${font_name_no_ext//-MediumItalic/}
        font_name_no_ext=${font_name_no_ext//-Medium/}
        font_name_no_ext=${font_name_no_ext//-Regular/}
        font_name_no_ext=${font_name_no_ext//-SemiBoldItalic/}
        font_name_no_ext=${font_name_no_ext//-SemiBold/}
        font_name_no_ext=${font_name_no_ext//-ThinItalic/}
        font_name_no_ext=${font_name_no_ext//-Thin/}

        font_weight='400'
        font_style='normal'
        # Detect black, italic, etc in font_name and set font_style and font_weight
        if [[ $font_name == *"-Black"* ]]; then
            font_weight='900'
        elif [[ $font_name == *"-Bold"* ]]; then
            font_weight='700'
        elif [[ $font_name == *"-SemiBold"* ]]; then
            font_weight='600'
        elif [[ $font_name == *"-Medium"* ]]; then
            font_weight='500'
        elif [[ $font_name == *"-Regular"* ]]; then
            font_weight='400'
        elif [[ $font_name == *"-Light"* ]]; then
            font_weight='300'
        elif [[ $font_name == *"-Thin"* ]]; then
            font_weight='100'
        fi

        if [[ $font_name == *"Italic"* ]]; then
            font_style='italic'
        fi

        # Créer un nouveau répertoire pour chaque police de caractères
        mkdir -p "assets/fonts/$font_name_no_ext"

        # Déplacer les fichiers dans le bon répertoire
        cp "$file" "assets/fonts/$font_name_no_ext/$font_name"
        if [[ -f "${file}2" ]]; then
            cp "${file}2" "assets/fonts/$font_name_no_ext/${font_name}2"
        fi

        # Générer une liste de @font-face pour chaque fichier
        echo "@include cssc-font-face('$font_name_no_ext', '../fonts/$font_name_no_ext/$font_name_no_ext_base', $font_weight, $font_style, woff2 woff);"
    done

}
frontendutilities_order_fonts;
