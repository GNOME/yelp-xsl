yelp_xslt_docbook_common_data = [
  'db-chunk.xsl',
  'db-common.xsl',
  'db-profile.xsl',
  'db-title.xsl',
  'db-xref.xsl',
  'db-selectors.mod',
]

install_data(
  yelp_xslt_docbook_common_data,
  install_dir: join_paths(
    pkgxsltdir,
    'docbook',
    'common',
  )
)

foreach data: yelp_xslt_docbook_common_data
  if data.endswith('.xsl')
    yelp_xslt_doc_data += [
      [data.split('.').get(0), files(data)]
    ]
  endif
endforeach