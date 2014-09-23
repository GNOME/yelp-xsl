AC_INIT([yelp-xsl],[3.14.0],[http://bugzilla.gnome.org/enter_bug.cgi?product=yelp-xsl])

AC_CONFIG_MACRO_DIR([m4])

AM_INIT_AUTOMAKE([1.10 no-dist-gzip dist-bzip2])

# Check for programs
dnl  In the interest of portability, we don't use GNU awk extensions,
dnl  even though they rule.  To prevent accidental use and subsequent
dnl  bug reports after busted tarballs were shipped, we use -W compat
dnl  whenever our awk is gawk.
AC_PROG_AWK
if test x$AWK = xgawk; then
   YELP_XSL_AWK='gawk -W compat';
else
   YELP_XSL_AWK=$AWK;
fi
AC_SUBST(YELP_XSL_AWK)

AC_CHECK_PROG([ITSTOOL], [itstool], [itstool])
if test x"$ITSTOOL" = x; then
  AC_MSG_ERROR([itstool is required to build the translation XML files])
fi
ITSTOOL_VERSION=`itstool --version | cut -d' ' -f2 | awk -F. '{print $ 1 * 10000 + $ 2 * 100 + $ 3; }'`
if test "$ITSTOOL_VERSION" -lt 10200; then
  AC_MSG_ERROR([itstool >= 1.2.0 is required to build the translation XML files])
fi

# i18n stuff
GETTEXT_PACKAGE=yelp-xsl
AC_SUBST(GETTEXT_PACKAGE)
AC_DEFINE_UNQUOTED(GETTEXT_PACKAGE,"$GETTEXT_PACKAGE")

IT_PROG_INTLTOOL([0.40.0])

ALL_LINGUAS="`grep -v '^#' "$srcdir/po/LINGUAS" | tr '\n' ' '`"
AC_SUBST(ALL_LINGUAS)

AC_ARG_ENABLE(doc,
              [AS_HELP_STRING([--enable-doc],[build and install developer documentation [default=no]])],,
              enable_doc=no)
AM_CONDITIONAL(ENABLE_DOC, test "x$enable_doc" != "xno")

AS_IF([test "x$enable_doc" != "xno"],[
AC_CHECK_PROG(XMLLINT, xmllint, xmllint)
if test x"$XMLLINT" = x; then
  AC_MSG_ERROR([xmllint not found])
fi
AC_CHECK_PROG(XSLTPROC, xsltproc, xsltproc)
if test x"$XSLTPROC" = x; then
  AC_MSG_ERROR([xsltproc not found])
fi
])

AC_CONFIG_FILES([
Makefile
yelp-xsl.pc
icons/Makefile
icons/hicolor/Makefile
icons/hicolor/24x24/Makefile
icons/hicolor/24x24/status/Makefile
icons/hicolor/48x48/Makefile
icons/hicolor/48x48/status/Makefile
icons/hicolor/scalable/Makefile
icons/hicolor/scalable/status/Makefile
js/Makefile
doc/Makefile
doc/yelp-xsl/Makefile
po/Makefile.in
xslt/Makefile
xslt/common/Makefile
xslt/common/domains/Makefile
xslt/docbook/Makefile
xslt/docbook/common/Makefile
xslt/docbook/html/Makefile
xslt/mallard/Makefile
xslt/mallard/cache/Makefile
xslt/mallard/common/Makefile
xslt/mallard/html/Makefile
])

AC_OUTPUT

dnl ==========================================================================
echo "
yelp-xsl-$VERSION:

	prefix:                   ${prefix}

	Documentation:            ${enable_doc}
"
