#!/bin/sh
# Run this to generate all the initial makefiles, etc.

srcdir=`dirname $0`
test -z "$srcdir" && srcdir=.
abs_srcdir=`(cd $srcdir && pwd)`

PKG_NAME="yelp-xsl"

(test -f $srcdir/configure.in \
  && test -f $srcdir/README \
  && test -d $srcdir/xslt) || {
    echo -n "**Error**: Directory "\`$srcdir\'" does not look like the"
    echo " top-level $PKG_NAME directory"
    exit 1
}

which gnome-autogen.sh || {
    echo "You need to install gnome-common from git.gnome.org"
    exit 1
}

REQUIRED_AUTOMAKE_VERSION=1.9 USE_GNOME2_MACROS=1 . gnome-autogen.sh
