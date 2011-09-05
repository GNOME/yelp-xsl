AC_INIT([yelp-xsl],[3.1.5],[http://bugzilla.gnome.org/enter_bug.cgi?product=yelp-xsl])

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

AC_ARG_VAR([ITSTOOL], [Path to the `itstool` command])
AC_CHECK_PROG([ITSTOOL], [itstool], [itstool])
if test x"$ITSTOOL" = x; then
  AC_MSG_ERROR([itstool is required to build the translation XML files])
fi

# Dependecies
PKG_CHECK_MODULES(YELP_XSL,
[
	libxml-2.0 >= 2.6.12
	libxslt    >= 1.1.8
])

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
icons/hicolor/watermarks/Makefile
js/Makefile
doc/Makefile
doc/yelp-xsl/Makefile
po/Makefile.in
xslt/Makefile
xslt/common/Makefile
xslt/docbook/Makefile
xslt/docbook/common/Makefile
xslt/docbook/html/Makefile
xslt/docbook/omf/Makefile
xslt/docbook/utils/Makefile
xslt/mallard/Makefile
xslt/mallard/cache/Makefile
xslt/mallard/common/Makefile
xslt/mallard/html/Makefile
xslt/gettext/Makefile
xslt/gettext/domains/Makefile
])

AC_OUTPUT

dnl ==========================================================================
echo "
yelp-xsl-$VERSION:

	prefix:                   ${prefix}

	Documentation:            ${enable_doc}
"
