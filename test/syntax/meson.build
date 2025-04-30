if get_option('dita') == true
  test(
    'test-syntax-dita',
    xsltproc_prg,
    args: [
      '--xinclude',
      yelp_xslt_dita_html_test_data.get(0), # dita2html.xsl
      files('source/dita.dita'),
    ],
  )
endif

if get_option('docbook') == true
  test(
    'test-syntax-docbook',
    xsltproc_prg,
    args: [
      '--xinclude',
      '--param', 'db.chunk.max_depth', '0',
      yelp_xslt_docbook_html_test_data.get(0), # db2html.xsl
      files('source/docbook.docbook'),
    ],
  )
endif

if get_option('mallard') == true
  test(
    'test-syntax-mallard',
    xsltproc_prg,
    args: [
      '--xinclude',
      yelp_xslt_mallard_html_test_data.get(0), # mal2html.xsl
      files('source/mallard.page'),
    ],
  )
endif