highlight.pack.js:
	cp ../../js/highlight.pack.js .

mallard: highlight.pack.js
	xsltproc --xinclude ../../xslt/mallard/html/mal2html.xsl mallard.page

docbook: highlight.pack.js
	xsltproc --xinclude --param db.chunk.max_depth 0 ../../xslt/docbook/html/db2html.xsl docbook.docbook

dita: highlight.pack.js
	xsltproc --xinclude ../../xslt/dita/html/dita2html.xsl dita.dita
