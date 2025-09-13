project('yelp-xsl',
  version: '49.0',
  license: ['GPL2+', 'LGPL2.1+', 'MIT'],
  meson_version: '>= 1.3',
)

i18n = import('i18n')

version = meson.project_version()
package_name = meson.project_name()

prefix = get_option('prefix')

datadir = join_paths(prefix, get_option('datadir'))

pkgconfigdir = join_paths(datadir, 'pkgconfig')
pkgdir = join_paths(datadir, package_name)
pkgxsltdir = join_paths(pkgdir, 'xslt')
pkgjsdir = join_paths(pkgdir, 'js')

# Dependencies
xsltproc_prg = find_program('xsltproc', required: true)
itstool_prg = find_program('itstool', required: true)

awk_prg = find_program('awk', required: false)

itstool = find_program('itstool', version: '>=1.2.0')


# Options
build_yelp_manual = get_option('yelp_manual')
if not awk_prg.found()
  build_yelp_manual = false
endif

yelp_xsl_pc = configuration_data()
yelp_xsl_pc.set('prefix', prefix)
yelp_xsl_pc.set('datarootdir', join_paths('${prefix}', get_option('datadir')))
yelp_xsl_pc.set('datadir', '${datarootdir}')

yelp_xsl_pc.set('VERSION', version)

configure_file(
  input: 'yelp-xsl.pc.in',
  output: 'yelp-xsl.pc',
  configuration: yelp_xsl_pc,
  install: true,
  install_dir: pkgconfigdir,
)

yelp_xslt_doc_data = []

subdir('po')

subdir('xslt')
subdir('js')

subdir('test')

if build_yelp_manual == true
  subdir('doc')
endif

summary = [
  '',
  '------',
  'yelp-xsl @0@'.format(version),
  '',
  '     DITA: @0@'.format(get_option('dita')),
  '  DocBook: @0@'.format(get_option('docbook')),
  '  Mallard: @0@'.format(get_option('mallard')),
  '   Manual: @0@'.format(build_yelp_manual),
  '',
  'Directories:',
  '   prefix: @0@'.format(prefix),
  '  datadir: @0@'.format(datadir),
  '------',
]

message('\n'.join(summary))
