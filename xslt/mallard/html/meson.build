yelp_xslt_mallard_html_data = [
  'mal2html-api.xsl',
  'mal2html-block.xsl',
  'mal2html-gloss.xsl',
  'mal2html-inline.xsl',
  'mal2html-links.xsl',
  'mal2html-list.xsl',
  'mal2html-math.xsl',
  'mal2html-media.xsl',
  'mal2html-page.xsl',
  'mal2html-svg.xsl',
  'mal2html-table.xsl',
  'mal2html-ui.xsl',
  'mal2html.xsl',
  'mal2xhtml.xsl',
]

install_data(
  yelp_xslt_mallard_html_data,
  install_dir: join_paths(
    pkgxsltdir,
    'mallard',
    'html',
  )
)

yelp_xslt_mallard_html_test_data = files(
  'mal2html.xsl',
)

foreach data: yelp_xslt_mallard_html_data
  if data.endswith('.xsl')
    yelp_xslt_doc_data += [
      [data.split('.').get(0), files(data)]
    ]
  endif
endforeach