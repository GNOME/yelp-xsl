yelp_xslt_mallard_common_data = [
  'mal-gloss.xsl',
  'mal-if.xsl',
  'mal-link.xsl',
  'mal-sort.xsl',
]

install_data(
  yelp_xslt_mallard_common_data,
  install_dir: join_paths(
    pkgxsltdir,
    'mallard',
    'common',
  )
)

foreach data: yelp_xslt_mallard_common_data
  if data.endswith('.xsl')
    yelp_xslt_doc_data += [
      [data.split('.').get(0), files(data)]
    ]
  endif
endforeach