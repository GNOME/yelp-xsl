ABS_SRCDIR = @abs_srcdir@

xsldoc_dirs = 						\
	$(ABS_SRCDIR)/../../xslt/common			\
	$(ABS_SRCDIR)/../../xslt/docbook/common		\
	$(ABS_SRCDIR)/../../xslt/docbook/html		\
	$(ABS_SRCDIR)/../../xslt/mallard/cache		\
	$(ABS_SRCDIR)/../../xslt/mallard/common		\
	$(ABS_SRCDIR)/../../xslt/mallard/html

xsldoc_xsls = $(filter-out %db2html-suppressed.xsl,			\
	$(sort $(patsubst ./%, %,					\
	  $(foreach dir,$(xsldoc_dirs), $(wildcard $(dir)/*.xsl)) )) )
xsldoc_base = $(sort $(foreach xsl,$(xsldoc_xsls), $(basename $(notdir $(xsl)))))
xsldoc_ducks = $(patsubst %, ducks/%.duck, $(xsldoc_base))
xsldoc_pages = $(patsubst %, C/%.page, $(xsldoc_base))

.PHONY: xsldoc-clean

if ENABLE_DOC
all: $(xsldoc_pages)

$(xsldoc_ducks): $(xsldoc_xsls) xsldoc.xsl
	xsltproc -o "$@" \
	--stringparam xsldoc.id "$(basename $(notdir $@))" \
	"$(srcdir)/xsldoc.xsl" \
	"$(filter %/$(basename $(notdir $@)).xsl,$(xsldoc_xsls))"

$(xsldoc_pages): $(xsldoc_ducks)
	$(mkdir_p) C
	ls $(srcdir)
	ducktype -o C/ $(srcdir)/ducks/*.duck $(srcdir)/static/*.duck

endif

.PHONY: xsldoc-clean
clean-local: xsldoc-clean
xsldoc-clean:
	rm -f C/*.page
	rm -f ducks/*.duck

EXTRA_DIST = 			\
	$(xsldoc_ducks)		\
	static/index.duck	\
	static/keys.duck	\
	static/modes.duck	\
	static/params.duck	\
	static/stubs.duck	\
	static/stylesheets.duck	\
	static/templates.duck	\
	xsldoc.xsl
