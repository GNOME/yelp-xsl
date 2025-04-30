#!/bin/sh

# This script is for building enough of yelp-xsl to run transforms
# against the local, in-tree build. It's not for installing, disting,
# or doing anything else fancy. Tools like Pintail use local yelp-xsl
# copies, and this script means they don't have to pull in autotools.

command -v msgfmt >/dev/null 2>&1 || { echo >&2 "msgfmt required to build yelp-xsl"; exit 1; }
command -v itstool >/dev/null 2>&1 || { echo >&2 "itstool required to build yelp-xsl"; exit 1; }

ALL_LINGUAS=$(grep -v '^#' po/LINGUAS | tr '\n' ' ')

for lang in $ALL_LINGUAS; do
    msgfmt -o "po/$lang.mo" "po/$lang.po" || exit 1
done
itstool -o xslt/common/domains/yelp-xsl.xml -j xslt/common/domains/yelp-xsl.xml.in \
    $(for lang in $ALL_LINGUAS; do echo "po/$lang.mo"; done)

exit 0
