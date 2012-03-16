#!/bin/sh

yelp-build cache .
for page in *.page; do
    xsltproc \
        --stringparam mal.cache.file index.cache \
        ../../xslt/mallard/html/mal2html.xsl \
        $page
done
