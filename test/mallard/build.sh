#!/bin/sh

yelp-build cache source/*.page
if [ ! -d output ]; then mkdir output; fi
rm -f output/*.*
cp ../../js/highlight.pack.js output/
for page in source/*.page; do
    xsltproc \
        --stringparam mal.cache.file ../index.cache \
        -o output/ \
        ../../xslt/mallard/html/mal2html.xsl \
        $page;
done
rm index.cache
