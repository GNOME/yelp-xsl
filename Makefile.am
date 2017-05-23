SUBDIRS = js xslt doc
DIST_SUBDIRS = $(SUBDIRS) po

ACLOCAL_AMFLAGS = -I m4 ${ACLOCAL_FLAGS}

pkgconfigdir = $(datadir)/pkgconfig
pkgconfig_DATA = yelp-xsl.pc

EXTRA_DIST = 						\
	$(pkgdata_DATA)					\
	ChangeLog					\
	COPYING.GPL					\
	COPYING.LGPL					\
	intltool-extract.in  				\
	intltool-merge.in    				\
	intltool-update.in

DISTCLEANFILES =					\
	intltool-extract  				\
	intltool-merge    				\
	intltool-update

AM_DISTCHECK_CONFIGURE_FLAGS = --enable-doc

ChangeLog:
	@if test -f $(top_srcdir)/.git/HEAD; then \
	  git log --stat > $@; \
	fi

dist: ChangeLog
.PHONY: ChangeLog
