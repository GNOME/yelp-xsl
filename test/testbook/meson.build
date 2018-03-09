if get_option('docbook') == true
  test(
    'test-testbook-html',
    xsltproc_prg,
    args: [
      '--timing',
      '--nonet',
      '--xinclude',
      '--param', 'db.chunk.chunk_top', '1',
      '--stringparam', 'theme.icon.admon.path', '../../../data/icons/hicolor/48x48/',
      '--output', 'html',
      yelp_xslt_docbook_html_test_data.get(0), # db2html.xsl
      files('testbook.xml'),
    ],
  )

  test(
    'test-testbook-xhtml',
    xsltproc_prg,
    args: [
      '--timing',
      '--nonet',
      '--xinclude',
      '--param', 'db.chunk.chunk_top', '1',
      '--stringparam', 'theme.icon.admon.path', '../../../data/icons/hicolor/48x48/',
      '--output', 'xhtml',
      yelp_xslt_docbook_html_test_data.get(1), # db2xhtml.xsl
      files('testbook.xml'),
    ],
  )
endif