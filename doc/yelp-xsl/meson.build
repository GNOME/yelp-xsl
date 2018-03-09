xsldoc_scan_prg = find_program('xsldoc-scan')
mal2cache_prg = find_program('mal2cache')

yelp_xslt_doc_pages = []
yelp_xslt_doc_checks = []

foreach data: yelp_xslt_doc_data
  data_name = data.get(0)
  data_file = data.get(1)

  data_page = custom_target(
    '@0@.page'.format(data_name),
    input: data_file,
    output: '@0@.page'.format(data_name),
    install: false,
    command: [
      xsldoc_scan_prg,
      '-o', '@OUTDIR@',
      '@INPUT@',
    ],
  )

  yelp_xslt_doc_pages += [data_page]
  yelp_xslt_doc_checks += [[data_name, data_page]]
endforeach

yelp_xslt_doc_index = custom_target(
  'index.cache',
  output: 'index.cache',
  build_by_default: true,
  install: false,
  depends: yelp_xslt_doc_pages,
  command: [
    mal2cache_prg,
    '@OUTPUT@',
    yelp_xslt_mallard_index_cache_xsl,
    yelp_xslt_doc_pages,
  ],
)

foreach check: yelp_xslt_doc_checks
  check_name = check.get(0)
  check_target = check.get(1)

  test(
    'test-doc-@0@'.format(check_name),
    xsltproc_prg,
    args: [
      '--stringparam', 'xsldoc.cache.file', yelp_xslt_doc_index,
      files('xsldoc-check.xsl'),
      check_target,
    ],
  )
endforeach