// svgo-clean.cjs
module.exports = {
    multipass: true,
    plugins: [
        'preset-default',
        {
            name: 'removeAttrs',
            params: {
                attrs: [
                    'id',
                    'class',
                    'xmlns',
                    'data.*',
                    'inkscape:.*',
                    'sodipodi:.*',
                    'xml:.*'
                ]
            }
        },
        'removeTitle',
        'removeDesc',
        'removeMetadata',
        'removeEditorsNSData',
        'removeUselessDefs',
        'convertStyleToAttrs',
        'convertPathData',
        'cleanupNumericValues',
        'collapseGroups',
        'mergePaths'
    ]
};
