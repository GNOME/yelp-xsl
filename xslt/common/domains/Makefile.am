ALL_LINGUAS = @ALL_LINGUAS@

$(srcdir)/yelp-xsl.pot: yelp-xsl.xml.in
	itstool -o "$@" yelp-xsl.xml.in

all: $(srcdir)/yelp-xsl.pot

yelp-xsl.xml: yelp-xsl.xml.in
	@echo "  GEN    $@"; \
	if [ ! -d .yelp-xsl ]; then mkdir .yelp-xsl; fi; \
	echo '<files>' > ".yelp-xsl.files"; \
	echo '<source href="yelp-xsl.xml.in"/>' >> ".yelp-xsl.files"; \
	for lang in $(ALL_LINGUAS); do \
	  msgfmt -o ".yelp-xsl/$$lang.mo" "$(top_srcdir)/po/$$lang.po" || exit 1; \
	  (cd .yelp-xsl && itstool -o "$$lang.xml" -m "$$lang.mo" "../yelp-xsl.xml.in") || exit 1; \
	  rm ".yelp-xsl/$$lang.mo" || exit 1; \
	  echo '<file href="'".yelp-xsl/$$lang.xml"'"/>' >> ".yelp-xsl.files"; \
	done; \
	echo '</files>' >> ".yelp-xsl.files"; \
	xsltproc -o "$@" "msgs.xsl" ".yelp-xsl.files" || exit 1; \
	for lang in $(ALL_LINGUAS); do rm ".yelp-xsl/$$lang.xml"; done; \
	rmdir .yelp-xsl; \
	rm .yelp-xsl.files

xsldir=$(datadir)/yelp-xsl/xslt/common/domains

xsl_DATA = yelp-xsl.xml

EXTRA_DIST = yelp-xsl.xml yelp-xsl.xml.in

CLEANFILES = yelp-xsl.xml yelp-xsl.pot
