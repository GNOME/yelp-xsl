yelp_xslt_common_data = [
  'color.xsl',
  'icons.xsl',
  'l10n.xsl',
  'l10n-numbers.xsl',
  'html.xsl',
  'tmpl.xsl',
  'ttml.xsl',
  'utils.xsl',
]

install_data(
  yelp_xslt_common_data,
  install_dir: join_paths(
    pkgxsltdir,
    'common',
  )
)

subdir('css')
subdir('domains')
subdir('icons')

foreach data: yelp_xslt_common_data
  if data.endswith('.xsl')
    yelp_xslt_doc_data += [
      [data.split('.').get(0), files(data)]
    ]
  endif
endforeach
