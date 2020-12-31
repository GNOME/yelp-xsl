#!/bin/sh

if [ ! -d output ]; then mkdir output; fi
rm -f output/*.*
xsltproc --nonet --xinclude -o output/ \
         --param db.chunk.chunk_top 1 \
         ../../xslt/docbook/html/db2html.xsl \
         source/index.docbook
