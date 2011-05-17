db2html = db2html.xsl

tests = $(filter-out template.xml,$(wildcard *.xml))
htmls = $(patsubst %.xml,html/%,$(tests))

htmlargs =							\
	--stringparam db.chunk.max_depth 0 			\
	--stringparam theme.icons.base_url			\
	../../../../icons/hicolor/48x48/status/			\
	--stringparam theme.icons.watermark.code		\
	../../../../icons/hicolor/watermarks/watermark-code.png	\
	--param db.chunk.chunk_top 'false()'			\
	$(db2html)

test: $(htmls) html/index.html

$(htmls) : html/% : %.xml
	@mkdir -p $@
	@mkdir -p $@-a
	xsltproc \
	 -o $@/ \
	 --param annotate 'false()' \
	 --stringparam db.chunk.basename $(patsubst html/%,%,$@) \
	 $(call htmlargs,$@) $<
	xsltproc \
	 -o $@-a/ \
	 --param annotate 'true()' \
	 --stringparam db.chunk.basename $(patsubst html/%,%-a,$@) \
	 $(call htmlargs,$@) $<

html/index.html:
	(cd html && echo '<html><body><ul>' &&				\
	 for html in $(sort $(htmls)); do				\
	  base=`basename $$html`;					\
	  echo "<li><a href='"`ls $$base/*.html`"'>$$base</a>";		\
	  echo "(<a href='"`ls $$base-a/*.html`"'>annotated</a>)</li>";	\
	 done && echo '</ul></body></html>') > $@

clean:
	rm -rf html/*
