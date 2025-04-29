yelp_xslt_mallard_cache_data = [
  'mal-cache.xsl',
]

install_data(
  yelp_xslt_mallard_cache_data,
  install_dir: join_paths(
    pkgxsltdir,
    'mallard',
    'cache',
  )
)

yelp_xslt_mallard_index_cache_xsl = files('mal-cache.xsl')

foreach data: yelp_xslt_mallard_cache_data
  if data.endswith('.xsl')
    yelp_xslt_doc_data += [
      [data.split('.').get(0), files(data)]
    ]
  endif
endforeach