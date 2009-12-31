ABS_SRCDIR = @abs_srcdir@

xsldoc_dirs = 						\
	$(ABS_SRCDIR)/../../xslt/common			\
	$(ABS_SRCDIR)/../../xslt/gettext		\
	$(ABS_SRCDIR)/../../xslt/docbook/common		\
	$(ABS_SRCDIR)/../../xslt/docbook/html		\
	$(ABS_SRCDIR)/../../xslt/docbook/omf		\
	$(ABS_SRCDIR)/../../xslt/mallard/common		\
	$(ABS_SRCDIR)/../../xslt/mallard/html

xsldoc_xsls = $(filter-out %db2html-suppressed.xsl,			\
	$(sort $(patsubst ./%, %,					\
	  $(foreach dir,$(xsldoc_dirs), $(wildcard $(dir)/*.xsl)) )) )
xsldoc_base = $(sort $(foreach xsl,$(xsldoc_xsls), $(basename $(notdir $(xsl)))))
xsldoc_pages = $(patsubst %, C/%.page, $(xsldoc_base))

if ENABLE_DOC
all: $(xsldoc_pages)

$(xsldoc_pages): $(xsldoc_xsls) xsldoc-scan.awk xsldoc-scan.xsl
	$(YELP_XSL_AWK) -f "$(srcdir)/xsldoc-scan.awk" "$(filter %/$(basename $(notdir $@)).xsl,$(xsldoc_xsls))" \
	| xsltproc -o "$@" \
	--stringparam xsldoc.id "$(basename $(notdir $@))" \
	--stringparam xsldoc.xslt_file "$(filter %/$(basename $(notdir $@)).xsl,$(xsldoc_xsls))" \
	"$(srcdir)/xsldoc-scan.xsl" -

C/index.cache: $(xsldoc_pages)
	$(srcdir)/mal2cache "$@" "$(ABS_SRCDIR)/../../xslt/mallard/utils/mal2cache.xsl" C/*.page

.PHONY: yelp-xsl-check-links
check: yelp-xsl-check-links

yelp-xsl-check-links: C/index.cache
	for page in $(wildcard C/*.page); do \
	  xsltproc --stringparam xsldoc.cache.file C/index.cache "$(srcdir)/xsldoc-check.xsl" "$$page" || exit 1; \
	done
endif

gnome-doc-xslt-check-includes:
	@incs=`$(YELP_XSL_AWK) $(gnome_doc_xslt_includes) "$(srcdir)/C/gnome-doc-xslt.xml" | sort`; \
	xmls=`echo $(xsldoc_base) | sort`; \
	exs=""; \
	for xml in $$xmls; do \
	  if echo "$$incs" | tr '\n' '\ ' | grep -v "\<$$xml\>" 1>/dev/null; then \
	    exs="$$exs$$xml "; \
	fi; done; \
	if [ "x$$exs" != "x" ]; then \
	  echo "gnome-doc-xslt.xml does not include the following reference pages: $$exs" 1>&2; \
	  exit 1; \
	fi
gnome-doc-xslt-check-xsldoc: $(xsldoc_docs)
	@echo "Running xsldoc checks";
	@(echo "<xsldoc>"; cat $(xsldoc_docs); echo "</xsldoc>") \
	| xsltproc "$(srcdir)/xsldoc-check.xsl" - 1> /dev/null

#.PHONY: clean-xsldoc
clean-local: clean_xsldoc
clean-doc-dir: clean_xsldoc
clean_xsldoc:
	rm -f $(xsldoc_pages)

EXTRA_DIST = xsldoc-scan.awk xsldoc-scan.xsl
