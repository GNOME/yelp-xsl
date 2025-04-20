gen_yelp_xml = find_program('gen_yelp_xml.sh')
msgfmt = find_program('msgfmt')

custom_target('yelp-xsl-xml-domain',
              input: 'yelp-xsl.xml.in',
              output: 'yelp-xsl.xml',
              command: [
                gen_yelp_xml,
                '--po-dir', '@0@'.format(meson.project_source_root() / 'po'),
                '--itstool', itstool,
                '--msgfmt', msgfmt,
                '--input', '@INPUT@',
                '--output', '@OUTPUT@',
                '--target', 'yelp-xml-domain',
              ],
              install: true,
              install_dir: datadir / 'yelp-xsl/xslt/common/domains')
