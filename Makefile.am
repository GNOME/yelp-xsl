SUBDIRS = data xslt doc

ACLOCAL_AMFLAGS = -I m4

pkgconfigdir = $(datadir)/pkgconfig
pkgconfig_DATA = yelp-xsl.pc

EXTRA_DIST = 						\
	$(pkgdata_DATA)					\
	COPYING.GPL					\
	COPYING.LGPL					\
	intltool-extract.in  				\
	intltool-merge.in    				\
	intltool-update.in

DISTCLEANFILES =					\
	intltool-extract  				\
	intltool-merge    				\
	intltool-update

DISTCHECK_CONFIGURE_FLAGS = --enable-doc
