#!/bin/sh

if [ ! -d output ]; then mkdir output; fi

# Mallard
if [ ! -d output/mallard ]; then mkdir output/mallard; fi
rm -f output/mallard/*.*
cp ../../js/highlight.pack.js output/mallard/
xsltproc -o output/mallard/ --xinclude \
	../../xslt/mallard/html/mal2html.xsl \
	source/mallard.page

# DocBook
if [ ! -d output/docbook ]; then mkdir output/docbook; fi
rm -f output/docbook/*.*
cp ../../js/highlight.pack.js output/docbook/
xsltproc -o output/docbook/ --xinclude \
	--param db.chunk.max_depth 0 \
	../../xslt/docbook/html/db2html.xsl \
	source/docbook.docbook

# DITA
if [ ! -d output/dita ]; then mkdir output/dita; fi
rm -f output/dita/*.*
cp ../../js/highlight.pack.js output/dita/
xsltproc -o output/dita/ --xinclude \
	../../xslt/dita/html/dita2html.xsl \
	source/dita.dita
