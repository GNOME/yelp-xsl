#!/bin/sh

if [ ! -d output ]; then mkdir output; fi
rm -f output/*.*
xsltproc -o output/testcolors.html testcolors.xsl testcolors.xsl
