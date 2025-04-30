yelp_xslt_docbook_html_data = [
  'db2html-bibliography.xsl',
  'db2html-block.xsl',
  'db2html-callout.xsl',
  'db2html-classsynopsis.xsl',
  'db2html-cmdsynopsis.xsl',
  'db2html-division.xsl',
  'db2html-ebnf.xsl',
  'db2html-footnote.xsl',
  'db2html-funcsynopsis.xsl',
  'db2html-index.xsl',
  'db2html-inline.xsl',
  'db2html-links.xsl',
  'db2html-math.xsl',
  'db2html-media.xsl',
  'db2html-list.xsl',
  'db2html-refentry.xsl',
  'db2html-suppressed.xsl',
  'db2html-table.xsl',
  'db2html-xref.xsl',
  'db2html.xsl',
  'db2xhtml.xsl',
]

install_data(
  yelp_xslt_docbook_html_data,
  install_dir: join_paths(
    pkgxsltdir,
    'docbook',
    'html',
  )
)

yelp_xslt_docbook_html_test_data = files(
  'db2html.xsl',
  'db2xhtml.xsl',
)

foreach data: yelp_xslt_docbook_html_data
  if data.endswith('.xsl')
    yelp_xslt_doc_data += [
      [data.split('.').get(0), files(data)]
    ]
  endif
endforeach

# custom_target(
#   'report.xml.in',
#   input: 'elements',
#   output: 'report.xml.in',
#   build_by_default: true,
#   capture: true,
#   install: false,
#   command: files('report.sh', 'elements'),
# )