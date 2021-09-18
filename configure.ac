# Do not split AC_INIT across multiple lines without making localbuild.sh smarter
AC_INIT([yelp-xsl],[41.0],[https://gitlab.gnome.org/gnome/yelp-xsl/issues])

AC_CONFIG_MACRO_DIR([m4])

AM_INIT_AUTOMAKE([1.11.2 no-dist-gzip dist-bzip2])

# Check for programs
dnl  In the interest of portability, we don't use GNU awk extensions,
dnl  even though they rule.  To prevent accidental use and subsequent
dnl  bug reports after busted tarballs were shipped, we use -W compat
dnl  whenever our awk is gawk.
AC_PROG_AWK
if test x$AWK = xgawk; then
   YELP_XSL_AWK='gawk --traditional';
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
AM_GNU_GETTEXT_VERSION([0.19.4])
AM_GNU_GETTEXT([external])

GETTEXT_PACKAGE=yelp-xsl
AC_SUBST(GETTEXT_PACKAGE)
AC_DEFINE_UNQUOTED(GETTEXT_PACKAGE,"$GETTEXT_PACKAGE")

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
js/Makefile
doc/Makefile
doc/yelp-xsl/Makefile
po/Makefile.in
xslt/Makefile
xslt/common/Makefile
xslt/common/css/Makefile
xslt/common/domains/Makefile
xslt/common/icons/Makefile
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
