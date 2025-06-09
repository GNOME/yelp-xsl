<?xml version='1.0' encoding='UTF-8'?><!-- -*- indent-tabs-mode: nil -*- -->
<!--
This program is free software; you can redistribute it and/or modify it under
the terms of the GNU Lesser General Public License as published by the Free
Software Foundation; either version 2 of the License, or (at your option) any
later version.

This program is distributed in the hope that it will be useful, but WITHOUT
ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or FITNESS
FOR A PARTICULAR PURPOSE. See the GNU Lesser General Public License for more
details.

You should have received a copy of the GNU Lesser General Public License
along with this program; see the file COPYING.LGPL. If not, see <http://www.gnu.org/licenses/>.
-->

<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
                xmlns:html="http://www.w3.org/1999/xhtml"
                xmlns:mml="http://www.w3.org/1998/Math/MathML"
                xmlns:exsl="http://exslt.org/common"
                xmlns:set="http://exslt.org/sets"
                xmlns:str="http://exslt.org/strings"
                xmlns:its="http://www.w3.org/2005/11/its"
                xmlns="http://www.w3.org/1999/xhtml"
                exclude-result-prefixes="html mml set str its"
                extension-element-prefixes="exsl"
                version="1.0">

<!--!!==========================================================================
HTML Output
Common utilities and CSS for transformations to HTML.
@revision[version=1.0 date=2010-05-26 status=final]

This stylesheet contains common templates for creating HTML output. The
{html.output} template creates an output file for a node in the source XML
document, calling {html.page} to create the actual output. Output files can
be either XHTML or HTML, depending on the {html.xhtml} parameter.

This stylesheet matches `/` and calls {html.output} on the root XML element.
This works for most input formats. If you need to do something different, you
should override the match for `/`.
-->
<xsl:template match="/">
  <xsl:call-template name="html.output">
    <xsl:with-param name="node" select="*"/>
  </xsl:call-template>
</xsl:template>


<!--@@==========================================================================
html.basename
The base filename of the primary output file.
@revision[version=1.0 date=2010-05-25 status=final]

This parameter specifies the base filename of the primary output file, without
the filename extension. This is used by {html.output} to determine the output
filename, and may be used by format-specific linking code. By default, it uses
the value of an `id` or `xml:id` attribute, if present. Otherwise, it uses
the static string `index`.
-->
<xsl:param name="html.basename">
  <xsl:choose>
    <xsl:when test="/*/@xml:id">
      <xsl:value-of select="/*/@xml:id"/>
    </xsl:when>
    <xsl:when test="/*/@id">
      <xsl:value-of select="/*/@id"/>
    </xsl:when>
    <xsl:otherwise>
      <xsl:text>index</xsl:text>
    </xsl:otherwise>
  </xsl:choose>
</xsl:param>


<!--@@==========================================================================
html.xhtml
Whether to output XHTML.
@revision[version=1.0 date=2010-05-25 status=final]

If this parameter is set to true, this stylesheet will output XHTML. Otherwise,
the output is assumed to be HTML. Note that for HTML output, the importing
stylesheet still needs to call `xsl:namespace-alias` to map the XHTML namespace
to `#default`. The {html.namespace} parameter will be set automatically based
on this parameter. Stylesheets can use this parameter to check the output type,
for example when using `xsl:element`.
-->
<xsl:param name="html.xhtml" select="true()"/>


<!--@@==========================================================================
html.namespace
The XML namespace for the output document.
@revision[version=1.0 date=2010-05-25 status=final]

This parameter specifies the XML namespace of all output documents. It will be
set automatically based on the {html.xhtml} parameter, either to the XHTML
namespace, or to the empty namespace. Stylesheets can use this parameter when
using `xsl:element`.
-->
<xsl:param name="html.namespace">
  <xsl:choose>
    <xsl:when test="$html.xhtml">
      <xsl:value-of select="'http://www.w3.org/1999/xhtml'"/>
    </xsl:when>
    <xsl:otherwise>
      <xsl:text></xsl:text>
    </xsl:otherwise>
  </xsl:choose>
</xsl:param>


<!--@@==========================================================================
html.mathml.namespace
The XML namespace for MathML in the output document.
@revision[version=3.18 date=2015-05-04 status=final]

This parameter specifies the XML namespace for MathML in output documents. It
will be set automatically based on the {html.xhtml} parameter, either to the
MathML namespace namespace, or to the empty namespace. Stylesheets can use this
parameter when using `xsl:element`.
-->
<xsl:param name="html.mathml.namespace">
  <xsl:choose>
    <xsl:when test="$html.xhtml">
      <xsl:value-of select="'http://www.w3.org/1998/Math/MathML'"/>
    </xsl:when>
    <xsl:otherwise>
      <xsl:text></xsl:text>
    </xsl:otherwise>
  </xsl:choose>
</xsl:param>


<!--@@==========================================================================
html.svg.namespace
The XML namespace for SVG in the output document.
@revision[version=3.18 date=2015-05-04 status=final]

This parameter specifies the XML namespace for SVG in output documents. It
will be set automatically based on the {html.xhtml} parameter, either to the
SVG namespace namespace, or to the empty namespace. Stylesheets can use this
parameter when using `xsl:element`.
-->
<xsl:param name="html.svg.namespace">
  <xsl:choose>
    <xsl:when test="$html.xhtml">
      <xsl:value-of select="'http://www.w3.org/2000/svg'"/>
    </xsl:when>
    <xsl:otherwise>
      <xsl:text></xsl:text>
    </xsl:otherwise>
  </xsl:choose>
</xsl:param>


<!--@@==========================================================================
html.extension
The filename extension for all output files.
@revision[version=1.0 date=2010-05-25 status=final]

This parameter specifies a filename extension for all HTML output files. It
should include the leading dot. By default, `.xhtml` will be used if
{html.xhtml} is true; otherwise, `.html` will be used.
-->
<xsl:param name="html.extension">
  <xsl:choose>
    <xsl:when test="$html.xhtml">
      <xsl:text>.xhtml</xsl:text>
    </xsl:when>
    <xsl:otherwise>
      <xsl:text>.html</xsl:text>
    </xsl:otherwise>
  </xsl:choose>
</xsl:param>


<!--@@==========================================================================
html.grid.size
The width of the page for grid layouts.
@revision[version=40 date=2021-01-09 status=final]

This parameter sets the width of the main page content, including padding, but
excluding any sidebars. These stylesheets frequently use flexible grids for
layouts, and columnds are based on this parameter. This parameter should be a
multiple of 12 for best results. Common grid sizes are 1200, 1080, and 960.
-->
<xsl:param name="html.grid.size" select="1080"/>
<xsl:variable name="html.grid.col1" select="$html.grid.size - 20"/>
<xsl:variable name="html.grid.col2" select="$html.grid.size div 2 - 20"/>
<xsl:variable name="html.grid.col3" select="$html.grid.size div 3 - 20"/>
<xsl:variable name="html.grid.col4" select="$html.grid.size div 4 - 20"/>


<!--@@==========================================================================
html.css.root
The URI root for external CSS files.
@revision[version=1.0 date=2010-12-06 status=final]

This parameter provides a root URI for any external CSS files that are
referenced from the output HTML file. If non-empty, it must end with
a trailing slash character.
-->
<xsl:param name="html.css.root" select="''"/>


<!--@@==========================================================================
html.js.root
The URI root for external JavaScript files.
@revision[version=1.0 date=2010-12-06 status=final]

This parameter provides a root URI for any external JavaScript files that are
referenced from the output HTML file. If non-empty, it must end with
a trailing slash character.
-->
<xsl:param name="html.js.root" select="''"/>


<!--@@==========================================================================
html.syntax.highlight
Whether to include syntax highlighting support for code blocks.
@revision[version=1.0 date=2010-12-06 status=final]

This parameter specifies whether syntax highlighting should be enabled for
code blocks in the output HTML. Syntax highlighting is done at document load
time by JavaScript.
-->
<xsl:param name="html.syntax.highlight" select="true()"/>


<!--@@==========================================================================
html.output.prefix
An optional path prefix for files output with {html.output}.
@revision[version=3.28 date=2017-05-24 status=final]

This parameter allows you to specify an prefix to place before the output path
used by {html.output} when creating files. You can use this to override the
output directory. Make sure you include a trailing slash, unless you want to
prefix the base file name itself.
-->
<xsl:param name="html.output.prefix" select="''"/>


<!--@@==========================================================================
html.sidebar.left
List of components to add to the left sidebar.
@revision[version=3.30 date=2018-06-10 status=candidate]

This parameter takes a space-separated list of tokens that specify which
components to add to the stock left sidebar. These stylesheets recognize
certain tokens, and you can add your own with {html.sidebar.mode}. See
{html.sidebar} for further details.
-->
<xsl:param name="html.sidebar.left" select="''"/>


<!--@@==========================================================================
html.sidebar.right
List of components to add to the right sidebar.
@revision[version=3.30 date=2018-06-10 status=candidate]

This parameter takes a space-separated list of tokens that specify which
components to add to the stock right sidebar. These stylesheets recognize
certain tokens, and you can add your own with {html.sidebar.mode}. See
{html.sidebar} for further details.
-->
<xsl:param name="html.sidebar.right" select="''"/>

<!--@@==========================================================================
html.csp.nonce
An optional CSP nonce string to allow the execution of scripts and styles.
@revision[version=42.2 date=2025-02-22 status=final]

This parameter takes a string value that will be added to the 'nonce' attribute
of all 'style' and 'script' tags in the generated HTML output. This paramter is used
to whitelist script and style tags that are allowed to be executed.
-->
<xsl:param name="html.csp.nonce" select="false()"/>

<!--**==========================================================================
html.output
Create an HTML output file.
@revision[version=1.0 date=2010-05-26 status=final]

[xsl:params]
$node: The node to create an output file for.
$href: The output filename.

This template creates an HTML output file for the source element $node. It
uses `exsl:document` to output the file, and calls {html.page} with the
$node parameter to output the actual HTML contents.

If $href is not provided, this template will attempt to generate a base
filename and append {html.extension} to it. The base filename is generated
as follows:

* If an `xml:id` attribute is present, it is used.
* Otherwise, if an `id` attribute is present, it is used.
* Otherwise, if $node is the root element, {html.basename} is used.
* Otherwise, `generate-id()` is called.

This template prepends {html.output.prefix} to the value of $href when
it calls `exsl:document`, regardless of whether $href was passed in or
generated automatically.

After calling `exsl:document`, this template calls the {html.output.after.mode}
mode on $node. Importing stylesheets that create multiple output files can
use this to process output files without blocking earlier output.
-->
<xsl:template name="html.output">
  <xsl:param name="node" select="."/>
  <xsl:param name="href">
    <xsl:choose>
      <xsl:when test="$node/@xml:id">
        <xsl:value-of select="concat($node/@xml:id, $html.extension)"/>
      </xsl:when>
      <xsl:when test="$node/@id">
        <xsl:value-of select="concat($node/@id, $html.extension)"/>
      </xsl:when>
      <xsl:when test="set:has-same-node($node, /*)">
        <xsl:value-of select="concat($html.basename, $html.extension)"/>
      </xsl:when>
      <xsl:otherwise>
        <xsl:value-of select="concat(generate-id(), $html.extension)"/>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:param>
  <xsl:choose>
    <xsl:when test="$html.xhtml">
      <exsl:document href="{$html.output.prefix}{$href}">
	<xsl:call-template name="html.page">
	  <xsl:with-param name="node" select="$node"/>
	</xsl:call-template>
      </exsl:document>
    </xsl:when>
    <xsl:otherwise>
      <exsl:document href="{$html.output.prefix}{$href}" method="html"
		     doctype-system="about:legacy-compat">
	<xsl:call-template name="html.page">
	  <xsl:with-param name="node" select="$node"/>
	</xsl:call-template>
      </exsl:document>
    </xsl:otherwise>
  </xsl:choose>
  <xsl:apply-templates mode="html.output.after.mode" select="$node"/>
</xsl:template>



<!--%%==========================================================================
html.output.after.mode
Process an element after its content are output.
@revision[version=1.0 date=2010-05-26 status=final]

This mode is called by {html.output} after `exsl:document` has finished. It
can be used to create further output files without blocking the output of
parent elements.
-->
<xsl:template mode="html.output.after.mode" match="*"/>


<!--**==========================================================================
html.page
Create an HTML document.
@revision[version=3.28 date=2017-08-04 status=final]

[xsl:params]
$node: The node to create HTML for.

This template creates the actual HTML output for $node. It outputs top-level
elements and container divs, and calls various templates and modes to output
the inner content. Importing stylesheets should implement at least
{html.title.mode} and {html.body.mode} for any elements that could be passed
as $node to this template. Importing stylesheets should also implement
{html.header.mode} to output link trails and {html.footer.mode} to output
credits and other page information.

This template outputs the HTML `body` element, which takes its attributes
from two sources. First, it calls {html.lang.attrs}, which automatically
outputs correct `lang`, `xml:lang`, and `dir` attributes. It then calls
{html.body.attr.mode} on $node for additional attributes.

This template also calls a number of stub templates that can be overridden
by extension stylesheets.

* Override the {html.head.custom} template to put custom content at the end
  of the HTML `head` element.

* Override the {html.head.top.custom} template to put custom content at the
  beginning of the HTML `head` element.

* Override the {html.top.custom} and {html.bottom.custom} templates to add
  site-specific content at the top and bottom of the page.

* Override the {html.header.custom} and {html.footer.custom} templates to
  provide additional content directoy above and below the main content.

* Use the {html.sidebar.left} and {html.sidebar.right} parameters to create
  stock sidebars, or override {html.sidebar.custom} to create your own.

This template also calls {html.css} and {html.js} to output CSS and JavaScript
elements. See those templates for further extension points.
-->
<xsl:template name="html.page">
  <xsl:param name="node" select="."/>
  <html>
    <head>
      <xsl:call-template name="html.head.top.custom">
        <xsl:with-param name="node" select="$node"/>
      </xsl:call-template>
      <xsl:if test="$html.csp.nonce != ''">
        <meta http-equiv="Content-Security-Policy" content="script-src 'nonce-{$html.csp.nonce}';"/>
      </xsl:if>
      <meta name="viewport"
            content="width=device-width, initial-scale=1.0, user-scalable=yes"/>
      <title>
        <xsl:apply-templates mode="html.title.mode" select="$node"/>
      </title>
      <xsl:call-template name="html.css">
        <xsl:with-param name="node" select="$node"/>
      </xsl:call-template>
      <xsl:call-template name="html.js">
        <xsl:with-param name="node" select="$node"/>
      </xsl:call-template>
      <xsl:call-template name="html.head.custom">
        <xsl:with-param name="node" select="$node"/>
      </xsl:call-template>
    </head>
    <body>
      <xsl:call-template name="html.lang.attrs">
        <xsl:with-param name="node" select="$node"/>
      </xsl:call-template>
      <xsl:apply-templates mode="html.body.attr.mode" select="$node"/>
      <xsl:call-template name="html.top.custom">
        <xsl:with-param name="node" select="$node"/>
      </xsl:call-template>
      <main>
        <xsl:call-template name="html.sidebar">
          <xsl:with-param name="node" select="$node"/>
        </xsl:call-template>
        <xsl:call-template name="html.sidebar.custom">
          <xsl:with-param name="node" select="$node"/>
        </xsl:call-template>
        <div class="page">
          <header>
            <div class="inner pagewide">
              <xsl:call-template name="html.header.custom">
                <xsl:with-param name="node" select="$node"/>
              </xsl:call-template>
              <xsl:apply-templates mode="html.header.mode" select="$node"/>
            </div>
          </header>
          <article>
            <xsl:apply-templates mode="html.body.mode" select="$node"/>
          </article>
          <footer>
            <div class="inner pagewide">
              <xsl:apply-templates mode="html.footer.mode" select="$node"/>
              <xsl:call-template name="html.footer.custom">
                <xsl:with-param name="node" select="$node"/>
              </xsl:call-template>
            </div>
          </footer>
        </div>
      </main>
      <xsl:call-template name="html.bottom.custom">
        <xsl:with-param name="node" select="$node"/>
      </xsl:call-template>
    </body>
  </html>
</xsl:template>


<!--%%==========================================================================
html.title.mode
Output the title of an element.
@revision[version=1.0 date=2010-05-26 status=final]

This mode is called by {html.page} to output the contents of the HTML `title`
element inside the `head` element. Importing stylesheets should implement this
mode for any element that will be passed to {html.page}. Because this is used
in the `head`, the output should be text-only.
-->
<xsl:template mode="html.title.mode" match="*"/>


<!--%%==========================================================================
html.body.attr.mode
Output attributes for the HTML `body` element.
@revision[version=1.0 date=2010-06-08 status=final]

This mode is called by {html.page} to output attributes on the HTML `body`
element. No attributes are output by default. Importing stylesheets may
implement this node to add attributes for styling, data, or other purposes.
-->
<xsl:template mode="html.body.attr.mode" match="*"/>


<!--**==========================================================================
html.top.custom
Stub to output HTML at the top of the page.
@xsl:stub
@revision[version=3.28 date=2017-05-24 status=final]

[xsl:params]
$node: The node a page is being created for.

This template is a stub, called by {html.page}. It is called before the
`main` element. Override this template to provide site-specific HTML
at the top of the page.
-->
<xsl:template name="html.top.custom">
  <xsl:param name="node" select="."/>
</xsl:template>


<!--**==========================================================================
html.bottom.custom
Stub to output HTML at the bottom of the page.
@xsl:stub
@revision[version=3.28 date=2017-05-24 status=final]

[xsl:params]
$node: The node a page is being created for.

This template is a stub, called by {html.page}. It is called after the
`main` element. Override this template to provide site-specific HTML
at the bottom of the page.
-->
<xsl:template name="html.bottom.custom">
  <xsl:param name="node" select="."/>
</xsl:template>


<!--**==========================================================================
html.sidebar
Output stock sidebars.
@revision[version=3.30 date=2018-06-10 status=candidate]

[xsl:params]
$node: The node a sidebar is being created for.

This templates outputs left and right sidebars according to the components
listed in {html.sidebar.left} and {html.sidebar.right}. It only outputs each
sidebar if the corresponding parameters is not empty or the string `none`.

This template is called inside the `main` element, before the `div.page`
element, and before {html.sidebar.custom}. Note that even the right sidebar
is placed before the `div.page` element. It is placed on the right using
flexbox item reordering.

To actually output the sidebar components, this template splits each parameter
on whitespace using the EXSLT `str:split` function. It then applies the mode
{html.sidebar.mode} to each token, passing $node and the sidebar side as
parameters. Extension stylesheets can add their own sidebar components by
implementing that mode and matching a pattern like

[code]
  token[. = 'name-of-token']

You will then be able to use `name-of-token` in {html.sidebar.left} or
{html.sidebar.right}.

This stylesheet recognizes four tokens: `contents` and `sections`, and the
special tokens `none` and `blank`.

* The `contents` token provides a table of contents for the entire document.
  It is handled by the {html.sidebar.contents} template, which uses the
  {html.sidebar.contents.mode} mode to allow different input formats to
  implement it.

* The `sections` token lists sections on the current page. It is handled by the
  html.sidebar.section} template, which uses the {html.sidebar.sections.mode}
  mode to allow different input formats to implement it.

* Use the `none` token on its own, instead of the empty string, to completely
  turn off either sidebar.

* Use the `blank` token to output a sidebar without adding any components to
  it. This is useful, for example, to keep consistent margins. If an empty
  sidebar is output from the `blank` token, it will also have the CSS class
  `sidebar-blank` so you can style it differently.
-->
<xsl:template name="html.sidebar">
  <xsl:param name="node" select="."/>
  <xsl:if test="$html.sidebar.left != '' and $html.sidebar.left != 'none'">
    <xsl:call-template name="_html.sidebar.sidebar">
      <xsl:with-param name="node" select="$node"/>
      <xsl:with-param name="side" select="'left'"/>
      <xsl:with-param name="bars" select="$html.sidebar.left"/>
    </xsl:call-template>
  </xsl:if>
  <xsl:if test="$html.sidebar.right != '' and $html.sidebar.right != 'none'">
    <xsl:call-template name="_html.sidebar.sidebar">
      <xsl:with-param name="node" select="$node"/>
      <xsl:with-param name="side" select="'right'"/>
      <xsl:with-param name="bars" select="$html.sidebar.right"/>
    </xsl:call-template>
  </xsl:if>
</xsl:template>

<xsl:template name="_html.sidebar.sidebar">
  <xsl:param name="node"/>
  <xsl:param name="side"/>
  <xsl:param name="bars"/>
  <xsl:variable name="class">
    <xsl:text>sidebar sidebar-</xsl:text>
    <xsl:value-of select="$side"/>
    <xsl:if test="$bars = 'blank'">
      <xsl:text> sidebar-blank</xsl:text>
    </xsl:if>
  </xsl:variable>
  <aside class="{$class}">
    <xsl:apply-templates mode="html.sidebar.mode" select="str:split($bars)">
      <xsl:with-param name="node" select="$node"/>
      <xsl:with-param name="side" select="$side"/>
    </xsl:apply-templates>
  </aside>
</xsl:template>


<!--%%==========================================================================
html.sidebar.mode
Output a sidebar compenent for a token.
@revision[version=3.30 date=2018-06-10 status=candidate]

[xsl:params]
$node: The node a sidebar is being created for.
$side: Which sidebar, either `left` or `right`.

This mode is called by {html.sidebar} for each sidebar compenent in each of
{html.sidebar.left} and {html.sidebar.right}. See {html.sidebar} for full
details.
-->
<xsl:template mode="html.sidebar.mode" match="token[. = 'blank']"/>
<xsl:template mode="html.sidebar.mode" match="*">
  <xsl:message>
    <xsl:text>Unmatched sidebar: </xsl:text>
    <xsl:value-of select="."/>
  </xsl:message>
</xsl:template>


<!--**==========================================================================
html.sidebar.contents
Output a table of contents for a sidebar.
@revision[version=3.30 date=2018-06-10 status=candidate]

[xsl:params]
$node: The node a sidebar is being created for.
$side: Which sidebar, either `left` or `right`.

This template creates a table of contents for a sidebar. It applies
{html.sidebar.contents.mode} to $node, passing $side as a parameter, to
allow individual input formats to implement tables of contents.

This named template also implements {html.sidebar.mode} on the `contents`
token. See {html.sidebar} for more information on how sidebars are created.
-->
<xsl:template name="html.sidebar.contents"
              mode="html.sidebar.mode" match="token[. = 'contents']">
  <xsl:param name="node"/>
  <xsl:param name="side"/>
  <xsl:apply-templates mode="html.sidebar.contents.mode" select="$node">
    <xsl:with-param name="side" select="$side"/>
  </xsl:apply-templates>
</xsl:template>


<!--%%==========================================================================
html.sidebar.contents.mode
Output a table of contents for a sidebar.
@revision[version=3.30 date=2018-06-10 status=candidate]

[xsl:params]
$side: Which sidebar, either `left` or `right`.

This mode is called by {html.sidebar.contents} to allow different input
formats to implement a table of contents for a sidebar.
-->
<xsl:template mode="html.sidebar.contents.mode" match="*">
  <xsl:param name="side"/>
  <xsl:message>
    <xsl:text>Unmatched contents sidebar: </xsl:text>
    <xsl:value-of select="local-name(.)"/>
  </xsl:message>
</xsl:template>


<!--**==========================================================================
html.sidebar.sections
Output a list of sections for a sidebar.
@revision[version=3.30 date=2018-06-10 status=candidate]

[xsl:params]
$node: The node a sidebar is being created for.
$side: Which sidebar, either `left` or `right`.

This template creates a list of sections on the current page for a sidebar.
It applies {html.sidebar.sections.mode} to $node, passing $side as a
parameter, to allow individual input formats to implement sections lists.

This named template also implements {html.sidebar.mode} on the `sections`
token. See {html.sidebar} for more information on how sidebars are created.
-->
<xsl:template name="html.sidebar.sections"
              mode="html.sidebar.mode" match="token[. = 'sections']">
  <xsl:param name="node"/>
  <xsl:param name="side"/>
  <xsl:apply-templates mode="html.sidebar.sections.mode" select="$node">
    <xsl:with-param name="side" select="$side"/>
  </xsl:apply-templates>
</xsl:template>


<!--%%==========================================================================
html.sidebar.sections.mode
Output a list of sections for a sidebar.
@revision[version=3.30 date=2018-06-10 status=candidate]

[xsl:params]
$side: Which sidebar, either `left` or `right`.

This mode is called by {html.sidebar.sections} to allow different input
formats to implement a sections list for a sidebar.
-->
<xsl:template mode="html.sidebar.sections.mode" match="*">
  <xsl:param name="side"/>
  <xsl:message>
    <xsl:text>Unmatched sections sidebar: </xsl:text>
    <xsl:value-of select="local-name(.)"/>
  </xsl:message>
</xsl:template>


<!--**==========================================================================
html.sidebar.custom
Stub to output custom sidebar content.
@xsl:stub
@revision[version=3.28 date=2017-05-24 status=final]

[xsl:params]
$node: The node a page is being created for.

This template is a stub, called by {html.page}. It is called inside the `main`
element, before the `div.page` element. The `main` element uses a horizontal
flexbox by default. You can override this template to provide sidebar content.
Note that there is only one extension point for sidebar content, and it is
always placed before the main content in document order. To create a sidebar
on the right, output the element here, then adjust the `order` CSS property
for that element to display it after the `main` element.

This template is intended for completely custom sidebars. You can also use
{html.sidebar} to output sidebars with stock components.
-->
<xsl:template name="html.sidebar.custom">
  <xsl:param name="node" select="."/>
</xsl:template>


<!--**==========================================================================
html.header.custom
Stub to output custom header content.
@xsl:stub
@revision[version=3.28 date=2017-05-24 status=final]

[xsl:params]
$node: The node a page is being created for.

This template is a stub, called by {html.page}. It is called inside the
`header` element, before {html.header.mode} is applied to `node`. You can
override this template to provide additional content above the main content.
-->
<xsl:template name="html.header.custom">
  <xsl:param name="node" select="."/>
</xsl:template>


<!--%%==========================================================================
html.header.mode
Output the header content for an element.
@revision[version=3.28 date=2017-05-24 status=final]

This mode is called by {html.page} to output the contents of the `header`
element above the main content. Importing stylesheets may implement this mode
for any element that will be passed to {html.page}. If they do not, the
`header` element will be empty by default.
-->
<xsl:template mode="html.header.mode" match="*"/>


<!--**==========================================================================
html.footer.custom
Stub to output custom footer content.
@xsl:stub
@revision[version=3.28 date=2017-05-24 status=final]

[xsl:params]
$node: The node a page is being created for.

This template is a stub, called by {html.page}. It is called inside the
`footer` element, after {html.footer.mode} is applied to $node. You can
override this template to provide additional content below the main content.
-->
<xsl:template name="html.footer.custom">
  <xsl:param name="node" select="."/>
</xsl:template>


<!--%%==========================================================================
html.footer.mode
Output the footer content for an element.
@revision[version=3.28 date=2017-05-24 status=final]

This mode is called by {html.page} to output the contents of the `footer`
element below the main content. Importing stylesheets may implement this mode
for any element that will be passed to {html.page}. If they do not, the
`footer` element will be empty by default.
-->
<xsl:template mode="html.footer.mode" match="*"/>


<!--%%==========================================================================
html.body.mode
Output the main contents for an element.
@revision[version=1.0 date=2010-05-26 status=final]

This mode is called by {html.page} to output the main contents of an HTML
page, below the header content and above the footer content. Titles, block
content, and sections should be output in this mode.
-->
<xsl:template mode="html.body.mode" match="*"/>


<!--**==========================================================================
html.head.top.custom
Stub to output custom content at the beginning of the HTML `head` element.
@xsl:stub
@revision[version=3.28 date=2017-08-04 status=final]

[xsl:params]
$node: The node a page is being created for.

This template is a stub, called by {html.page}. You can override this template
to provide additional elements at the beginning of the HTML `head` element of
output files. This template is called before all other head content.
-->
<xsl:template name="html.head.top.custom">
  <xsl:param name="node" select="."/>
</xsl:template>


<!--**==========================================================================
html.head.custom
Stub to output custom content at the end of the HTML `head` element.
@xsl:stub
@revision[version=3.28 date=2017-08-04 status=final]

[xsl:params]
$node: The node a page is being created for.

This template is a stub, called by {html.page}. You can override this template
to provide additional elements in the HTML `head` element of output files.
This template is called after all other head content.
-->
<xsl:template name="html.head.custom">
  <xsl:param name="node" select="."/>
</xsl:template>


<!--**==========================================================================
html.linktrails.empty
Stub to output something when no link trails are present.
@xsl:stub
@revision[version=3.28 date=2017-05-24 status=final]

[xsl:params]
$node: The source element a page is bring created for.

This template is a stub. It is called by templates that output link trails when
there are no link trails to output. Some customizations prepend extra site links
to link trails. This template allows them to output those links even when no link
trails would otherwise be present.
-->
<xsl:template name="html.linktrails.empty">
  <xsl:param name="node" select="."/>
</xsl:template>


<!--**==========================================================================
html.linktrails.prefix
Stub to output extra content before a link trail.
@xsl:stub
@revision[version=42 date=2021-10-30 status=final]

[xsl:params]
$page: The source element for which an output page is being made.
$node: A source-specific element providing information about the link trail.

This template is a stub. It is called by templates that output link trails
before the normal links are output. This template is useful for adding extra
site links at the beginning of each link trail.

[note .plain]
The $page parameter was added in version 42.
-->
<xsl:template name="html.linktrails.prefix">
  <xsl:param name="page" select="."/>
  <xsl:param name="node" select="."/>
</xsl:template>


<!--**==========================================================================
html.class.attr
Output a `class` attribute for an HTML element.
@revision[version=3.10 date=2013-07-10 status=final]

[xsl:params]
$node: The source node for which an HTML element is being output.
$class: The value of the `class` attribute provided by the calling template.

This template is called by templates that output an HTML element corresponding
to a source element. This template applies {html.class.attr.mode} to $node
to gather a value from extensions stylesheets. It combines this value with the
value passed in the $class parameter and, if the result is non-empty, outputs
a `class` attribute.
-->
<xsl:template name="html.class.attr">
  <xsl:param name="node" select="."/>
  <xsl:param name="class"/>
  <xsl:variable name="fclass">
    <xsl:value-of select="$class"/>
    <xsl:text> </xsl:text>
    <xsl:apply-templates mode="html.class.attr.mode" select="$node"/>
  </xsl:variable>
  <xsl:variable name="nclass" select="normalize-space($fclass)"/>
  <xsl:if test="$nclass != ''">
    <xsl:attribute name="class">
      <xsl:value-of select="normalize-space($nclass)"/>
    </xsl:attribute>
  </xsl:if>
</xsl:template>


<!--%%==========================================================================
html.class.attr.mode
Output additional values for an HTML `class` attribute.
@revision[version=3.10 date=2013-07-10 status=final]

This mode is called by {html.class.attr} on a source element. This mode is
intended for extensions to have an easy way to add additional HTML class values
for styling.

Note that these stylesheets use CSS classes extensively for styling and for
certain JavaScript functionality. Extensions should be careful to output class
values that do not conflict with those used in these stylesheets.
-->
<xsl:template mode="html.class.attr.mode" match="*"/>


<!--**==========================================================================
html.content.pre
Output content before the content of a page or section.
@revision[version=3.28 date=2016-06-21 status=final]

[xsl:params]
$node: The node a page or section is being created for.
$page: Whether the content is for a page.

This template is called by importing stylesheets before any content of a page
or section, but after the title. It calls {html.content.pre.custom}, then
applies {html.content.pre.mode} to $node. If the $page parameter is true,
then this template is being called on an output page. Otherwise, it is being
called on a section within a page.
-->
<xsl:template name="html.content.pre">
  <xsl:param name="node" select="."/>
  <xsl:param name="page" select="true()"/>
  <xsl:call-template name="html.content.pre.custom">
    <xsl:with-param name="node" select="$node"/>
    <xsl:with-param name="page" select="$page"/>
  </xsl:call-template>
  <xsl:apply-templates mode="html.content.pre.mode" select="$node">
    <xsl:with-param name="page" select="$page"/>
  </xsl:apply-templates>
</xsl:template>


<!--**==========================================================================
html.content.pre.custom
Stub to output content before the content of a page or section.
@xsl:stub
@revision[version=3.28 date=2016-06-21 status=final]

[xsl:params]
$node: The node a page or section is being created for.
$page: Whether the content is for a page.

This template is a stub, called by {html.content.pre.custom}. It is called
before {html.content.pre.mode} is applied. Override this template to provide
site-specific HTML before the content of a page or section. If the $page
parameter is true, then this template is being called on an output page.
Otherwise, it is being called on a section within a page.
-->
<xsl:template name="html.content.pre.custom">
  <xsl:param name="node" select="."/>
  <xsl:param name="page" select="true()"/>
</xsl:template>


<!--%%==========================================================================
html.content.pre.mode
Output content before the content of a page or section.
@revision[version=3.28 date=2016-06-21 status=final]

[xsl:params]
$page: Whether the content is for a page.

This mode is applied by {html.content.pre} after calling
{html.content.pre.custom}. Importing stylesheets can use this to add
additional content for specific types of input elements before the content
of a page or section. If the $page parameter is true, then this template
is being called on an output page. Otherwise, it is being called on a section
within a page.
-->
<xsl:template mode="html.content.pre.mode" match="*">
  <xsl:param name="page" select="true()"/>
</xsl:template>


<!--**==========================================================================
html.content.post
Output content after the content of a page or section, before subsections.
@revision[version=3.28 date=2016-06-21 status=final]

[xsl:params]
$node: The node a page or section is being created for.
$page: Whether the content is for a page.

This template is called by importing stylesheets after any content of a page
or section, but before any subsections. It applies {html.content.post.mode}
to $node, then calls {html.content.post.custom}. If the $page parameter
is true, then this template is being called on an output page. Otherwise, it
is being called on a section within a page.
-->
<xsl:template name="html.content.post">
  <xsl:param name="node" select="."/>
  <xsl:param name="page" select="true()"/>
  <xsl:apply-templates mode="html.content.post.mode" select="$node">
    <xsl:with-param name="page" select="$page"/>
  </xsl:apply-templates>
  <xsl:call-template name="html.content.post.custom">
    <xsl:with-param name="node" select="$node"/>
    <xsl:with-param name="page" select="$page"/>
  </xsl:call-template>
</xsl:template>


<!--**==========================================================================
html.content.post.custom
Stub to output content after the content of a page or section, before subsections.
@xsl:stub
@revision[version=3.28 date=2016-06-21 status=final]

[xsl:params]
$node: The node a page or section is being created for.
$page: Whether the content is for a page.

This template is a stub, called by {html.content.post.custom}. It is called
after {html.content.pre.mode} is applied. Override this template to provide
site-specific HTML after the content of a page or section, but before any
subsections. If the $page parameter is true, then this template is being
called on an output page. Otherwise, it is being called on a section within
a page.
-->
<xsl:template name="html.content.post.custom">
  <xsl:param name="node" select="."/>
  <xsl:param name="page" select="true()"/>
</xsl:template>


<!--%%==========================================================================
html.content.post.mode
Output content after the content of a page or section, before subsections.
@revision[version=3.28 date=2016-06-21 status=final]

[xsl:params]
$page: Whether the content is for a page.

This mode is applied by {html.content.post} before calling
{html.content.post.custom}. Importing stylesheets can use this to add
additional content for specific types of input elements after the content
of a page or section, but before any subsections. If the $page parameter
is true, then this template is being called on an output page. Otherwise,
it is being called on a section within a page.
-->
<xsl:template mode="html.content.post.mode" match="*">
  <xsl:param name="page" select="true()"/>
</xsl:template>


<!--**==========================================================================
html.css
Output all CSS for an HTML output page.
@revision[version=1.0 date=2010-12-23 status=final]

[xsl:params]
$node: The node to create CSS for.
$direction: The directionality of the text, either `ltr` or `rtl`.
$left: The starting alignment, either `left` or `right`.
$right: The ending alignment, either `left` or `right`.

This template creates the CSS for an HTML output page, including the enclosing
HTML `style` element. It calls the templates {html.css.content} to output the
actual CSS contents.

The $direction parameter specifies the directionality of the text for the
language of the document. The $left and $right parameters are based on
$direction, and can be used to set beginning and ending margins or other
dimensions. All parameters can be automatically computed if not provided.
-->
<xsl:template name="html.css">
  <xsl:param name="node" select="."/>
  <xsl:param name="direction">
    <xsl:call-template name="l10n.direction">
      <xsl:with-param name="node" select="$node"/>
    </xsl:call-template>
  </xsl:param>
  <xsl:param name="left">
    <xsl:call-template name="l10n.align.start">
      <xsl:with-param name="direction" select="$direction"/>
    </xsl:call-template>
  </xsl:param>
  <xsl:param name="right">
    <xsl:call-template name="l10n.align.end">
      <xsl:with-param name="direction" select="$direction"/>
    </xsl:call-template>
  </xsl:param>
  <style type="text/css">
    <xsl:if test="$html.csp.nonce">
      <xsl:attribute name="nonce">
        <xsl:value-of select="$html.csp.nonce" />
      </xsl:attribute>
    </xsl:if>
    <xsl:call-template name="html.css.content">
      <xsl:with-param name="node" select="$node"/>
      <xsl:with-param name="direction" select="$direction"/>
      <xsl:with-param name="left" select="$left"/>
      <xsl:with-param name="right" select="$right"/>
    </xsl:call-template>
  </style>
</xsl:template>


<!--**==========================================================================
html.css.content
Output actual CSS content for an HTML output page.
@revision[version=1.0 date=2010-12-23 status=final]

[xsl:params]
$node: The node to create CSS for.
$direction: The directionality of the text, either `ltr` or `rtl`.
$left: The starting alignment, either `left` or `right`.
$right: The ending alignment, either `left` or `right`.

This template creates the CSS content for an HTML output page. It is called by
{html.css}. It calls the templates {html.css.core}, {html.css.elements}, and
{html.css.syntax}. It then calls the mode {html.css.mode} on $node and
calls the template {html.css.custom}.
-->
<xsl:template name="html.css.content">
  <xsl:param name="node" select="."/>
  <xsl:param name="direction">
    <xsl:call-template name="l10n.direction">
      <xsl:with-param name="node" select="$node"/>
    </xsl:call-template>
  </xsl:param>
  <xsl:param name="left">
    <xsl:call-template name="l10n.align.start">
      <xsl:with-param name="direction" select="$direction"/>
    </xsl:call-template>
  </xsl:param>
  <xsl:param name="right">
    <xsl:call-template name="l10n.align.end">
      <xsl:with-param name="direction" select="$direction"/>
    </xsl:call-template>
  </xsl:param>
  <xsl:call-template name="html.css.core">
    <xsl:with-param name="node" select="$node"/>
    <xsl:with-param name="direction" select="$direction"/>
    <xsl:with-param name="left" select="$left"/>
    <xsl:with-param name="right" select="$right"/>
  </xsl:call-template>
  <xsl:call-template name="html.css.elements">
    <xsl:with-param name="node" select="$node"/>
    <xsl:with-param name="direction" select="$direction"/>
    <xsl:with-param name="left" select="$left"/>
    <xsl:with-param name="right" select="$right"/>
  </xsl:call-template>
  <xsl:call-template name="html.css.syntax">
    <xsl:with-param name="node" select="$node"/>
    <xsl:with-param name="direction" select="$direction"/>
    <xsl:with-param name="left" select="$left"/>
    <xsl:with-param name="right" select="$right"/>
  </xsl:call-template>
  <xsl:apply-templates mode="html.css.mode" select="$node">
    <xsl:with-param name="direction" select="$direction"/>
    <xsl:with-param name="left" select="$left"/>
    <xsl:with-param name="right" select="$right"/>
  </xsl:apply-templates>
  <xsl:call-template name="html.css.custom">
    <xsl:with-param name="node" select="$node"/>
    <xsl:with-param name="direction" select="$direction"/>
    <xsl:with-param name="left" select="$left"/>
    <xsl:with-param name="right" select="$right"/>
  </xsl:call-template>
</xsl:template>


<!--%%==========================================================================
html.css.mode
Output CSS specific to the input format.
@revision[version=1.0 date=2010-05-26 status=final]

[xsl:params]
$direction: The directionality of the text, either `ltr` or `rtl`.
$left: The starting alignment, either `left` or `right`.
$right: The ending alignment, either `left` or `right`.

This template is called by {html.css.content} to output CSS specific to the
input format. Importing stylesheets may implement this for any element that
will be passed to {html.page}. If they do not, the output HTML will only have
the common CSS.
-->
<xsl:template mode="html.css.mode" match="*">
  <xsl:param name="direction">
    <xsl:call-template name="l10n.direction"/>
  </xsl:param>
  <xsl:param name="left">
    <xsl:call-template name="l10n.align.start">
      <xsl:with-param name="direction" select="$direction"/>
    </xsl:call-template>
  </xsl:param>
  <xsl:param name="right">
    <xsl:call-template name="l10n.align.end">
      <xsl:with-param name="direction" select="$direction"/>
    </xsl:call-template>
  </xsl:param>
</xsl:template>


<!--**==========================================================================
html.css.core
Output CSS that does not reference source elements.
@revision[version=1.0 date=2010-05-25 status=final]

[xsl:params]
$node: The node to create CSS for.
$direction: The directionality of the text, either `ltr` or `rtl`.
$left: The starting alignment, either `left` or `right`.
$right: The ending alignment, either `left` or `right`.

This template outputs CSS that can be used in any HTML. It does not reference
elements from DocBook, Mallard, or other source languages. It provides the
common spacings for block-level elements like paragraphs and lists, defines
styles for links, and defines four common wrapper divs: `header`, `side`,
`body`, and `footer`.

This template uses text templates to keep the actual CSS content in a
separate file, `css/core.css.tmpl`, and do simple param substitutions.
This makes it easier to update the CSS without working with XSLT.

All parameters can be automatically computed if not provided.
-->
<xsl:template name="html.css.core">
  <xsl:param name="node" select="."/>
  <xsl:param name="direction">
    <xsl:call-template name="l10n.direction">
      <xsl:with-param name="node" select="$node"/>
    </xsl:call-template>
  </xsl:param>
  <xsl:param name="left">
    <xsl:call-template name="l10n.align.start">
      <xsl:with-param name="direction" select="$direction"/>
    </xsl:call-template>
  </xsl:param>
  <xsl:param name="right">
    <xsl:call-template name="l10n.align.end">
      <xsl:with-param name="direction" select="$direction"/>
    </xsl:call-template>
  </xsl:param>
  <xsl:call-template name="tmpl.file">
    <xsl:with-param name="file" select="'css/core.css.tmpl'"/>
    <xsl:with-param name="node" select="$node"/>
    <xsl:with-param name="direction" select="$direction"/>
    <xsl:with-param name="left" select="$left"/>
    <xsl:with-param name="right" select="$right"/>
  </xsl:call-template>
</xsl:template>


<!--**==========================================================================
html.css.elements
Output CSS for common elements from source formats.
@revision[version=1.0 date=2010-05-25 status=final]

[xsl:params]
$node: The node to create CSS for.
$direction: The directionality of the text, either `ltr` or `rtl`.
$left: The starting alignment, either `left` or `right`.
$right: The ending alignment, either `left` or `right`.

This template outputs CSS for elements from source languages like DocBook and
Mallard. It defines them using common class names. The common names are often
the simpler element names from Mallard, although there some class names which
are not taken from Mallard. Stylesheets which convert to HTML should use the
appropriate common classes.

This template uses text templates to keep the actual CSS content in a
separate file, `css/elements.css.tmpl`, and do simple param substitutions.
This makes it easier to update the CSS without working with XSLT.

All parameters can be automatically computed if not provided.
-->
<xsl:template name="html.css.elements">
  <xsl:param name="node" select="."/>
  <xsl:param name="direction">
    <xsl:call-template name="l10n.direction">
      <xsl:with-param name="node" select="$node"/>
    </xsl:call-template>
  </xsl:param>
  <xsl:param name="left">
    <xsl:call-template name="l10n.align.start">
      <xsl:with-param name="direction" select="$direction"/>
    </xsl:call-template>
  </xsl:param>
  <xsl:param name="right">
    <xsl:call-template name="l10n.align.end">
      <xsl:with-param name="direction" select="$direction"/>
    </xsl:call-template>
  </xsl:param>
  <!-- Almost everything is in the text template file, except there's
       these two bits that aren't because XPath alone can't handle
       them. We could precompute and pass params, but I'm hesitant
       to add special-purpose params, which are API. -->
  <xsl:call-template name="tmpl.file">
    <xsl:with-param name="file" select="'css/elements.css.tmpl'"/>
    <xsl:with-param name="node" select="$node"/>
    <xsl:with-param name="direction" select="$direction"/>
    <xsl:with-param name="left" select="$left"/>
    <xsl:with-param name="right" select="$right"/>
  </xsl:call-template>
  <!-- FIXME: I don't like this at all. We use a character as the
       blockquote icon, which requires a whole font, and which random
       internet users might not have. Let's make SVGs and use the same
       icon embedding we use for notes. -->
  <xsl:variable name="quote">
    <xsl:for-each select="$node[1]">
      <xsl:call-template name="l10n.gettext">
        <xsl:with-param name="msgid" select="'quote.format'"/>
        <xsl:with-param name="node" select="$node"/>
      </xsl:call-template>
    </xsl:for-each>
  </xsl:variable>
  <xsl:variable name="quotc" select="substring(concat($quote, '“'), 1, 1)"/>
  <xsl:text>div.quote > div.inner:before { float: </xsl:text>
  <xsl:value-of select="$left"/>
  <xsl:text>content: '</xsl:text>
  <xsl:choose>
    <xsl:when test="contains('«‹', $quotc)">
      <xsl:text>«</xsl:text>
    </xsl:when>
    <xsl:when test="contains('»›', $quotc)">
      <xsl:text>»</xsl:text>
    </xsl:when>
    <xsl:when test="contains('”„’‚', $quotc)">
      <xsl:text>”</xsl:text>
    </xsl:when>
    <xsl:otherwise>
      <xsl:text>“</xsl:text>
    </xsl:otherwise>
  </xsl:choose>
  <xsl:text>';
  font-family: "Century Schoolbook L";
  font-size: {{$icons.size.quote}}px;
  font-weight: bold;
  line-height: </xsl:text>
  <xsl:choose>
    <xsl:when test="contains('«»‹›', $quotc)">
      <xsl:text>0.5</xsl:text>
    </xsl:when>
    <xsl:otherwise>
      <xsl:text>1</xsl:text>
    </xsl:otherwise>
  </xsl:choose><xsl:text>em;
  margin: 0; padding: 0;
  height: {{$icons.size.quote}}px;
  width: {{$icons.size.quote}}px;
  text-align: center;
  color: {{$color.bg.dark}};
}</xsl:text>
  <!-- Surely we should be able to figure out a way to conditionalize
       the rotation direction in the text templates, or handle this a
       different way. -->
  <xsl:text>.ui-expander-e > div.inner > div.title span.title:before, </xsl:text>
  <xsl:text>.ui-expander-e > div.inner > div.hgroup span.title:before {</xsl:text>
  <xsl:choose>
    <xsl:when test="$direction = 'rtl'">
      <xsl:text>transform: translateY(0.2em) rotate(-180deg);</xsl:text>
    </xsl:when>
    <xsl:otherwise>
      <xsl:text>transform: translateY(0.2em) rotate(180deg);</xsl:text>
    </xsl:otherwise>
  </xsl:choose>
  <xsl:text>}</xsl:text>
</xsl:template>


<!--**==========================================================================
html.css.syntax
Output CSS for syntax highlighting.
@revision[version=1.0 date=2010-12-06 status=final]

[xsl:params]
$node: The node to create CSS for.
$direction: The directionality of the text, either `ltr` or `rtl`.
$left: The starting alignment, either `left` or `right`.
$right: The ending alignment, either `left` or `right`.

This template outputs CSS to support syntax highlighting of code blocks. Syntax
highlighting is done at document load time with JavaScript. Text in code blocks
is broken up into chunks and wrapped in HTML elements with particular classes.
This template outputs CSS to match those elements and style them with the
built-in themeable colors from {color}.

This template uses text templates to keep the actual CSS content in a
separate file, `css/syntax.css.tmpl`, and do simple param substitutions.
This makes it easier to update the CSS without working with XSLT.

All parameters can be automatically computed if not provided.
-->
<xsl:template name="html.css.syntax">
  <xsl:param name="node" select="."/>
  <xsl:param name="direction">
    <xsl:call-template name="l10n.direction">
      <xsl:with-param name="node" select="$node"/>
    </xsl:call-template>
  </xsl:param>
  <xsl:param name="left">
    <xsl:call-template name="l10n.align.start">
      <xsl:with-param name="direction" select="$direction"/>
    </xsl:call-template>
  </xsl:param>
  <xsl:param name="right">
    <xsl:call-template name="l10n.align.end">
      <xsl:with-param name="direction" select="$direction"/>
    </xsl:call-template>
  </xsl:param>
  <xsl:if test="$html.syntax.highlight">
    <xsl:call-template name="tmpl.file">
      <xsl:with-param name="file" select="'css/syntax.css.tmpl'"/>
      <xsl:with-param name="node" select="$node"/>
      <xsl:with-param name="direction" select="$direction"/>
      <xsl:with-param name="left" select="$left"/>
      <xsl:with-param name="right" select="$right"/>
    </xsl:call-template>
  </xsl:if>
</xsl:template>


<!--**==========================================================================
html.css.custom
Stub to output custom CSS common to all HTML transformations.
@xsl:stub
@revision[version=1.0 date=2010-05-25 status=final]

[xsl:params]
$node: The node to create CSS for.
$direction: The directionality of the text, either `ltr` or `rtl`.
$left: The starting alignment, either `left` or `right`.
$right: The ending alignment, either `left` or `right`.

This template is a stub, called by {html.css.content}. You can override this
template to provide additional CSS that will be used by all HTML output.
-->
<xsl:template name="html.css.custom">
  <xsl:param name="node" select="."/>
  <xsl:param name="direction">
    <xsl:call-template name="l10n.direction">
      <xsl:with-param name="node" select="$node"/>
    </xsl:call-template>
  </xsl:param>
  <xsl:param name="left">
    <xsl:call-template name="l10n.align.start">
      <xsl:with-param name="direction" select="$direction"/>
    </xsl:call-template>
  </xsl:param>
  <xsl:param name="right">
    <xsl:call-template name="l10n.align.end">
      <xsl:with-param name="direction" select="$direction"/>
    </xsl:call-template>
  </xsl:param>
</xsl:template>


<!--**==========================================================================
html.js
Output all JavaScript for an HTML output page.
@revision[version=3.28 date=2017-07-05 status=final]

[xsl:params]
$node: The node to create JavaScript for.

This template creates the JavaScript for an HTML output page. It calls the
templates {html.js.syntax} and {html.js.mathjax} to output references to
external libraries. It then calls {html.js.custom} to output references to
custom JavaScript files. Finally, it calls {html.js.script} to output local
JavaScript created by {html.js.content}.
-->
<xsl:template name="html.js">
  <xsl:param name="node" select="."/>
  <xsl:call-template name="html.js.syntax">
    <xsl:with-param name="node" select="$node"/>
  </xsl:call-template>
  <xsl:call-template name="html.js.mathjax">
    <xsl:with-param name="node" select="$node"/>
  </xsl:call-template>
  <xsl:call-template name="html.js.custom">
    <xsl:with-param name="node" select="$node"/>
  </xsl:call-template>
  <xsl:call-template name="html.js.script">
    <xsl:with-param name="node" select="$node"/>
  </xsl:call-template>
</xsl:template>


<!--**==========================================================================
html.js.mathjax
Output a `script` element to include MathJax.
@revision[version=1.0 date=2012-11-13 status=final]

[xsl:params]
$node: The node to create JavaScript for.

This template outputs an HTML `script` tag to reference MathJax. It only
outputs a `script` element if $node has MathML descendent content. By
default, this template uses `cdn.mathjax.org`. If you wish to use a local
copy, override this template and provide the necessary files.
-->
<xsl:template name="html.js.mathjax">
  <xsl:param name="node" select="."/>
  <xsl:if test="$node//mml:*[1]">
    <script type="text/javascript">
      <xsl:if test="$html.csp.nonce">
        <xsl:attribute name="nonce">
          <xsl:value-of select="$html.csp.nonce" />
        </xsl:attribute>
      </xsl:if>
      <xsl:attribute name="src">
        <xsl:text>http://cdn.mathjax.org/mathjax/latest/MathJax.js?config=MML_HTMLorMML</xsl:text>
      </xsl:attribute>
    </script>
  </xsl:if>
</xsl:template>


<!--**==========================================================================
html.js.script
Output a JavaScript `script` tag containing local content.
@revision[version=3.28 date=2017-05-24 status=final]

[xsl:params]
$node: The node to create JavaScript for.

This template is called by {html.js} to output JavaScript content. It outputs
a `script` tag and calls {html.js.content} to output the contents. To force
all JavaScript into external files, override this template to output a `script`
tag referencing an external file with the `src` attribute, then output the
result of {html.js.content} to that file.
-->
<xsl:template name="html.js.script">
  <xsl:param name="node" select="."/>
  <script type="text/javascript">
    <xsl:if test="$html.csp.nonce">
      <xsl:attribute name="nonce">
        <xsl:value-of select="$html.csp.nonce" />
      </xsl:attribute>
    </xsl:if>
    <xsl:call-template name="html.js.content">
      <xsl:with-param name="node" select="$node"/>
    </xsl:call-template>
  </script>
</xsl:template>


<!--**==========================================================================
html.js.content
Output JavaScript content for an HTML output page.
@revision[version=3.28 date=2017-07-05 status=final]

[xsl:params]
$node: The node to create JavaScript for.

This template is called by {html.js.script} to output JavaScript content. It
does not output an HTML `script` tag. This template calls the templates
{html.js.core}, {html.js.ui}, and {html.js.media}. It then calls the mode
{html.js.mode} on $node and calls the template {html.js.content.custom}.
-->
<xsl:template name="html.js.content">
  <xsl:param name="node" select="."/>
  <xsl:call-template name="html.js.core">
    <xsl:with-param name="node" select="$node"/>
  </xsl:call-template>
  <xsl:call-template name="html.js.ui">
    <xsl:with-param name="node" select="$node"/>
  </xsl:call-template>
  <xsl:call-template name="html.js.media">
    <xsl:with-param name="node" select="$node"/>
  </xsl:call-template>
  <xsl:apply-templates mode="html.js.mode" select="$node"/>
  <xsl:call-template name="html.js.content.custom">
    <xsl:with-param name="node" select="$node"/>
  </xsl:call-template>
</xsl:template>


<!--**==========================================================================
html.js.core
Output JavaScript for core features.
@revision[version=3.4 date=2011-11-04 status=final]

[xsl:params]
$node: The node to create JavaScript for.

This template outputs JavaScript to support basic features used by all documents.
Currently, it outputs code to highlight a section when `location.hash` is set.
-->
<xsl:template name="html.js.core">
  <xsl:param name="node" select="."/>
<xsl:text>
document.addEventListener('DOMContentLoaded', function() {
  var yelp_hash_highlight = function () {
    if (location.hash != '') {
      var sect = document.querySelector(location.hash);
      if (sect != null) {
        sect.classList.add('yelp-hash-highlight');
        window.setTimeout(function () {
          sect.classList.remove('yelp-hash-highlight');
        }, 500);
      }
    }
  }
  window.addEventListener('hashchange', yelp_hash_highlight, false);
  yelp_hash_highlight();
}, false);
</xsl:text>
</xsl:template>


<!--**==========================================================================
html.js.ui
Output JavaScript for UI extensions.
@revision[version=1.0 date=2011-06-17 status=final]

[xsl:params]
$node: The node to create JavaScript for.

This template outputs JavaScript that implements certain common UI extensions,
such as expandable blocks and sections.
-->
<xsl:template name="html.js.ui">
  <xsl:param name="node" select="."/>
<xsl:text><![CDATA[
var __yelp_generate_id_counter__ = 0;
function yelp_generate_id () {
  var ret = 'yelp--' + (++__yelp_generate_id_counter__).toString();
  if (document.getElementById(ret) != null)
    return yelp_generate_id();
  else
    return ret;
};
function yelp_ui_expander_init (expander) {
  var yelpdata = null;
  var innerdiv = null;
  var region = null;
  var contents = null;
  var title = null;
  var title_e = null;
  var title_c = null;
  var titlespan = null;
  var issect = false;
  for (var i = 0; i < expander.children.length; i++) {
    var child = expander.children[i];
    if (child.classList.contains('yelp-data-ui-expander')) {
      yelpdata = child;
    }
    else if (child.classList.contains('inner')) {
      innerdiv = child;
    }
  }
  if (innerdiv == null) {
    return;
  }
  for (var i = 0; i < innerdiv.children.length; i++) {
    var child = innerdiv.children[i];
    if (child.classList.contains('region')) {
      region = child;
    }
    else if (child.classList.contains('title')) {
      title = child;
    }
    else if (child.classList.contains('hgroup')) {
      title = child;
      issect = true;
    }
  }
  if (region == null || title == null) {
    return;
  }
  if (!region.hasAttribute('id')) {
    region.setAttribute('id', yelp_generate_id());
  }
  title.setAttribute('aria-controls', region.getAttribute('id'));

  if (yelpdata != null) {
    for (var i = 0; i < yelpdata.children.length; i++) {
      var child = yelpdata.children[i];
      if (child.classList.contains('yelp-title-expanded')) {
        title_e = child;
      }
      else if (child.classList.contains('yelp-title-collapsed')) {
        title_c = child;
      }
    }
  }
  titlespan = title.querySelector('span.title');
  if (titlespan == null) {
    return;
  }
  if (title_e == null) {
    var node = document.createElement('div');
    node.className = 'yelp-title-expanded';
    node.innerHTML = titlespan.innerHTML;
    yelpdata.appendChild(node);
    title_e = node;
  }
  if (title_c == null) {
    var node = document.createElement('div');
    node.className = 'yelp-title-collapsed';
    node.innerHTML = titlespan.innerHTML;
    yelpdata.appendChild(node);
    title_c = node;
  }

  var ui_expander_zoom_region = function (event) {
    if (yelpdata.getAttribute('data-yelp-expanded') != 'false') {
      ui_expander_toggle();
      event.preventDefault();
    }
  }
  if (expander.nodeName == 'section' || expander.nodeName == 'SECTION') {
    for (var i = 0; i < region.children.length; i++) {
      var child = region.children[i];
      if (child.classList.contains('contents')) {
        contents = child;
        break;
      }
    }
    contents.addEventListener('click', ui_expander_zoom_region, true);
  }
  else {
    region.addEventListener('click', ui_expander_zoom_region, true);
  }

  var ui_expander_toggle = function () {
    if (yelpdata.getAttribute('data-yelp-expanded') == 'false') {
      yelpdata.setAttribute('data-yelp-expanded', 'true');
      expander.classList.remove('ui-expander-e');
      expander.classList.add('ui-expander-c');
      region.setAttribute('aria-expanded', 'false');
      if (title_c != null)
        titlespan.innerHTML = title_c.innerHTML;
    }
    else {
      yelpdata.setAttribute('data-yelp-expanded', 'false');
      expander.classList.remove('ui-expander-c');
      expander.classList.add('ui-expander-e');
      region.setAttribute('aria-expanded', 'true');
      if (title_e != null)
        titlespan.innerHTML = title_e.innerHTML;
    }
  };
  expander.yelp_ui_expander_toggle = ui_expander_toggle;
  title.addEventListener('click', ui_expander_toggle, false);
  ui_expander_toggle();
}
document.addEventListener('DOMContentLoaded', function() {
  var matches = document.querySelectorAll('.ui-expander');
  for (var i = 0; i < matches.length; i++) {
    yelp_ui_expander_init(matches[i]);
  }
  var yelp_hash_ui_expand = function () {
    if (location.hash != '') {
      var sect = document.querySelector(location.hash);
      if (sect != null) {
        for (var cur = sect; cur instanceof Element; cur = cur.parentNode) {
          if (cur.classList.contains('ui-expander')) {
            if (cur.classList.contains('ui-expander-c')) {
              cur.yelp_ui_expander_toggle();
            }
          }
        }
        sect.scrollIntoView();
      }
    }
  };
  window.addEventListener('hashchange', yelp_hash_ui_expand, false);
  yelp_hash_ui_expand();
}, false);
]]></xsl:text>
</xsl:template>


<!--**==========================================================================
html.js.media
Output JavaScript to control media elements.
@revision[version=1.0 date=2010-01-01 status=final]

[xsl:params]
$node: The node to create JavaScript for.

This template outputs JavaScript that controls media elements. It provides
control for audio and video elements as well as support for captions.
-->
<xsl:template name="html.js.media">
  <xsl:param name="node" select="."/>
<xsl:text><![CDATA[
yelp_color_text_light = ']]></xsl:text>
<xsl:value-of select="$color.fg.dark"/><xsl:text><![CDATA[';
yelp_color_gray_background = ']]></xsl:text>
<xsl:value-of select="$color.bg.gray"/><xsl:text><![CDATA[';
yelp_color_gray_border = ']]></xsl:text>
<xsl:value-of select="$color.gray"/><xsl:text><![CDATA[';
function yelp_figure_init (figure) {
  var zoom = figure.querySelector('a.figure-zoom');

  var figure_resize = function () {
    var zoomed = zoom.classList.contains('figure-zoomed');
    var imgs = figure.querySelectorAll('img');
    for (var i = 0; i < imgs.length; i++) {
      var img = imgs[i];
      var mediaDiv = null;
      for (var cur = img; cur instanceof Element; cur = cur.parentNode) {
        if ((cur.nodeName == 'div' || cur.nodeName == 'DIV') &&
            cur.classList.contains('media')) {
          mediaDiv = cur;
          break;
        }
      }
      if (mediaDiv == null)
        continue;
      if (!img.hasAttribute('data-yelp-original-width')) {
        var iwidth = null;
        if (img.hasAttribute('width'))
          iwidth = parseInt(img.getAttribute('width'));
        else
          iwidth = img.width;
        img.setAttribute('data-yelp-original-width', iwidth);
        var iheight = null;
        if (img.hasAttribute('height'))
          iheight = parseInt(img.getAttribute('height'));
        else
          iheight = img.height * (iwidth / img.width);
        img.setAttribute('data-yelp-original-height', iheight);
      }
      var owidth = img.width;
      var oheight = img.height;
      img.width = parseInt(img.getAttribute('data-yelp-original-width'));
      img.height = parseInt(img.getAttribute('data-yelp-original-height'));
      var mediaw = mediaDiv.offsetWidth;
      img.width = owidth;
      img.height = oheight;
      if (parseInt(img.getAttribute('data-yelp-original-width')) <= mediaw) {
        img.width = parseInt(img.getAttribute('data-yelp-original-width'));
        img.height = parseInt(img.getAttribute('data-yelp-original-height'));
        zoom.style.display = 'none';
      }
      else if (zoomed) {
        img.width = parseInt(img.getAttribute('data-yelp-original-width'));
        img.height = parseInt(img.getAttribute('data-yelp-original-height'));
        zoom.style.display = 'block';
      }
      else {
        img.width = mediaw;
        img.height = (parseInt(img.getAttribute('data-yelp-original-height')) *
                      img.width /
                      parseInt(img.getAttribute('data-yelp-original-width')));
        zoom.style.display = 'block';
      }
    }
  }
  figure.yelp_figure_resize = figure_resize;
  figure.yelp_figure_resize();

  zoom.onclick = function (e) {
    var zoomed = zoom.classList.contains('figure-zoomed');
    if (zoomed)
      zoom.classList.remove('figure-zoomed');
    else
      zoom.classList.add('figure-zoomed');
    figure.yelp_figure_resize();
    return false;
  };
}
window.addEventListener('load', function() {
  var figures = document.querySelectorAll('div.figure');
  for (var i = 0; i < figures.length; i++) {
    if (figures[i].querySelector('img') != null)
      yelp_figure_init(figures[i]);
  }
  var timeout = null;
  var yelp_figures_resize = function () {
    if (timeout != null)
      return;
    timeout = window.setTimeout(function () {
      for (var i = 0; i < figures.length; i++) {
        if (figures[i].querySelector('img') != null)
          figures[i].yelp_figure_resize();
      }
      window.clearTimeout(timeout);
      timeout = null;
    }, 100);
  };
  window.addEventListener('resize', yelp_figures_resize, false);
}, false);
function yelp_media_init (media) {
  media.removeAttribute('controls');
  if (media.parentNode.classList.contains('links-tile-img')) {
    return;
  }

  media.addEventListener('click', function () {
    if (media.paused)
      media.play();
    else
      media.pause();
  }, false);

  var controls = null;
  for (var cur = media.nextSibling; cur instanceof Element; cur = cur.nextSibling) {
    if (cur.classList.contains('media-controls')) {
      controls = cur;
      break;
    }
  }
  if (controls == null) {
    media.setAttribute('controls', 'controls');
    return;
  }
  var playbutton = controls.querySelector('button.media-play');
  playbutton.addEventListener('click', function () {
    if (media.paused || media.ended)
      media.play();
    else
      media.pause();
  }, false);

  var mediachange = function () {
    if (media.ended)
      media.pause()
    if (media.paused) {
      playbutton.setAttribute('value', playbutton.getAttribute('data-play-label'));
      playbutton.classList.remove('media-play-playing');
    }
    else {
      playbutton.setAttribute('value', playbutton.getAttribute('data-pause-label'));
      playbutton.classList.add('media-play-playing');
    }
  }
  media.addEventListener('play', mediachange, false);
  media.addEventListener('pause', mediachange, false);
  media.addEventListener('ended', mediachange, false);

  var mediarange = controls.querySelector('input.media-range');
  mediarange.addEventListener('input', function () {
    var pct = this.value;
    if (pct < 0)
      pct = 0;
    if (pct > 100)
      pct = 100;
    media.currentTime = (pct / 100.0) * media.duration;
  }, false);
  var curspan = controls.querySelector('span.media-current');
  var durspan = controls.querySelector('span.media-duration');
  var durationUpdate = function () {
    if (!isNaN(media.duration)) {
      mins = parseInt(media.duration / 60);
      secs = parseInt(media.duration - (60 * mins));
      durspan.textContent = (mins + (secs < 10 ? ':0' : ':') + secs);
    }
  };
  media.addEventListener('durationchange', durationUpdate, false);

  var ttmlDiv = null;
  var ttmlNodes = null;
  for (var i = 0; i < media.parentNode.children.length; i++) {
    var child = media.parentNode.children[i];
    if (child.classList.contains('media-ttml'))
      ttmlDiv = child;
  }
  if (ttmlDiv != null) {
    ttmlNodes = ttmlDiv.querySelectorAll('.media-ttml-node');
  }

  var timeUpdate = function () {
    var pct = (media.currentTime / media.duration) * 100;
    mediarange.value = pct;
    var mins = parseInt(media.currentTime / 60);
    var secs = parseInt(media.currentTime - (60 * mins))
    curspan.textContent = (mins + (secs < 10 ? ':0' : ':') + secs);
    if (ttmlNodes != null) {
      for (var i = 0; i < ttmlNodes.length; i++) {
        var ttml = ttmlNodes[i];
        if (media.currentTime >= parseFloat(ttml.getAttribute('data-ttml-begin')) &&
            (!ttml.hasAttribute('data-ttml-end') ||
             media.currentTime < parseFloat(ttml.getAttribute('data-ttml-end')) )) {
          if (ttml.tagName == 'span' || ttml.tagName == 'SPAN')
            ttml.style.display = 'inline';
          else
            ttml.style.display = 'block';
        }
        else {
          ttml.style.display = 'none';
        }
      }
    }
  };
  media.addEventListener('timeupdate', timeUpdate, false);
};
document.addEventListener('DOMContentLoaded', function() {
  var matches = document.querySelectorAll('video, audio');
  for (var i = 0; i < matches.length; i++) {
    yelp_media_init(matches[i]);
  }
}, false);
]]></xsl:text>
</xsl:template>


<!--**==========================================================================
html.js.syntax
Output `script` elements for syntax highlighting.
@revision[version=3.28 date=2016-01-03 status=final]

[xsl:params]
$node: The node to create JavaScript for.

This template outputs HTML `script` elements to enable syntax highlighting.
It only outputs if {html.syntax.highlight} is `true`. It outputs one `script`
element to load in `highlight.js`, and another to initialize `highlight.js`
on all `code` elements with `"syntax"` in the class value.
-->
<xsl:template name="html.js.syntax">
  <xsl:param name="node" select="."/>
  <xsl:if test="$html.syntax.highlight">
    <script type="text/javascript" src="{$html.js.root}highlight.pack.js">
      <xsl:if test="$html.csp.nonce">
        <xsl:attribute name="nonce">
          <xsl:value-of select="$html.csp.nonce" />
        </xsl:attribute>
      </xsl:if>
    </script>
    <script>
    <xsl:if test="$html.csp.nonce">
      <xsl:attribute name="nonce">
        <xsl:value-of select="$html.csp.nonce" />
      </xsl:attribute>
    </xsl:if><![CDATA[
document.addEventListener('DOMContentLoaded', function() {
  var matches = document.querySelectorAll('code.syntax')
  for (var i = 0; i < matches.length; i++) {
    hljs.highlightBlock(matches[i]);
  }
}, false);]]></script>
  </xsl:if>
</xsl:template>


<!--%%==========================================================================
html.js.mode
Output JavaScript specific to the input format.
@revision[version=1.0 date=2010-01-01 status=final]

This mode is called by {html.js.content} to output JavaScript specific to
the input format. Importing stylesheets may implement this for any element that
will be passed to {html.page}. If they do not, the output HTML will only have
the common JavaScript.
-->
<xsl:template mode="html.js.mode" match="*">
</xsl:template>


<!--**==========================================================================
html.js.custom
Stub to reference custom JavaScript common to all HTML transformations.
@xsl:stub
@revision[version=1.0 date=2010-04-16 status=final]

[xsl:params]
$node: The node to create JavaScript for.

This template is a stub, called by {html.js}. You can override this template
to reference additional external JavaScript files. If you want to include
JavaScript into the main `script` tag instead, use {html.js.content.custom}.
-->
<xsl:template name="html.js.custom">
  <xsl:param name="node" select="."/>
</xsl:template>


<!--**==========================================================================
html.js.content.custom
Stub to output custom JavaScript common to all HTML transformations.
@xsl:stub
@revision[version=1.0 date=2010-04-16 status=final]

[xsl:params]
$node: The node to create JavaScript for.

This template is a stub, called by {html.js.content}. You can override this
template to provide additional JavaScript that will be used by all HTML output.
This template is called inside a `script` tag, and is intended to include
JavaScript code in the output page. See {html.js.custom} to include a custom
reference to an external JavaScript file.
-->
<xsl:template name="html.js.content.custom">
  <xsl:param name="node" select="."/>
</xsl:template>


<!--**==========================================================================
html.lang.attrs
Output `lang` and `dir` attributes.
@revision[version=1.0 date=2010-06-10 status=final]

[xsl:params]
$node: The current element in the input document.
$parent: A parent node to take $lang and $dir from.
$lang: The language for $node.
$dir: The text directionality for $node.

This template outputs `lang`, `xml:lang`, or `dir` attributes if necessary.
If $lang is not set, it will be taken from the `xml:lang` or `lang`
attribute of $node. If $dir is not set, it will be taken from the `its:dir`
attribute of $node or computed based on $lang.

The $parent parameter defaults to an empty node set. If it is set to a
non-empty node set, this template will attempt to get $lang and $dir from
$parent if they are not set on $node. This is occasionally useful when a
wrapper element in a source language doesn't directly create any output
elements.

This template outputs either an `xml:lang` or a `lang` attribute, depending
on whether {html.xhtml} is `true`. It only outputs an `xml:lang` or `lang`
attribute if $lang is non-empty. This template also outputs a `dir` attribute
if $dir is non-empty.
-->
<xsl:template name="html.lang.attrs">
  <xsl:param name="node" select="."/>
  <xsl:param name="parent" select="/false"/>
  <xsl:param name="lang">
    <xsl:choose>
      <xsl:when test="$node/@xml:lang">
        <xsl:value-of select="$node/@xml:lang"/>
      </xsl:when>
      <xsl:when test="$node/@lang">
        <xsl:value-of select="$node/@lang"/>
      </xsl:when>
      <xsl:when test="$parent/@xml:lang">
        <xsl:value-of select="$parent/@xml:lang"/>
      </xsl:when>
      <xsl:when test="$parent/@lang">
        <xsl:value-of select="$parent/@lang"/>
      </xsl:when>
    </xsl:choose>
  </xsl:param>
  <xsl:param name="dir">
    <xsl:choose>
      <xsl:when test="$node/@its:dir">
        <xsl:value-of select="$node/@its:dir"/>
      </xsl:when>
      <xsl:when test="($node/@xml:lang or $node/@lang) and (string($lang) != '')">
        <xsl:call-template name="l10n.direction">
          <xsl:with-param name="lang" select="$lang"/>
        </xsl:call-template>
      </xsl:when>
      <xsl:when test="$parent/@its:dir">
        <xsl:value-of select="$node/@its:dir"/>
      </xsl:when>
      <xsl:when test="string($lang) != ''">
        <xsl:call-template name="l10n.direction">
          <xsl:with-param name="lang" select="$lang"/>
        </xsl:call-template>
      </xsl:when>
    </xsl:choose>
  </xsl:param>
  <xsl:if test="string($lang) != ''">
    <xsl:choose>
      <xsl:when test="$html.xhtml">
        <xsl:attribute name="xml:lang">
          <xsl:value-of select="$lang"/>
        </xsl:attribute>
      </xsl:when>
      <xsl:otherwise>
        <xsl:attribute name="lang">
          <xsl:value-of select="$lang"/>
        </xsl:attribute>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:if>
  <xsl:if test="string($dir) != ''">
    <xsl:attribute name="dir">
      <xsl:value-of select="$dir"/>
    </xsl:attribute>
  </xsl:if>
</xsl:template>


<!--**==========================================================================
html.syntax.class
Output HTML class values for syntax highlighting.
@revision[version=3.28 date=2016-01-03 status=final]

[xsl:params]
$node: The source element whose content will be syntax highlighted.

This template calls {html.syntax.class.mode} on $node. If the result of that
mode is a suitable language identifier, it outputs appropriate CSS class names
to enable syntax highlighting. The output should be placed in the `class`
attribute of a `pre` or similar output element by the calling template.

Importing stylesheets should implement {html.syntax.class.mode} for any source
elements that may be syntax highlighted, then call this template when building
the `class` attribute for output elements.
-->
<xsl:template name="html.syntax.class">
  <xsl:param name="node" select="."/>
  <xsl:variable name="class">
    <xsl:apply-templates mode="html.syntax.class.mode" select="$node"/>
  </xsl:variable>
  <xsl:if test="normalize-space($class) != ''">
    <xsl:text>syntax language-</xsl:text>
    <xsl:value-of select="$class"/>
  </xsl:if>
</xsl:template>


<!--%%==========================================================================
html.syntax.class.mode
Get the syntax highlighting language for a source-specific element.
@revision[version=3.28 date=2016-01-03 status=final]

This mode is called by {html.syntax.class} on source elements that may have
syntax highlighted. This template should be implemented by importing stylesheets.
It should return a simple language identifier.
-->
<xsl:template mode="html.syntax.class.mode" match="*"/>


<!--**==========================================================================
html.media.controls
Output media controls for a video or audio object.
@revision[version=3.38 date=2020-04-30 status=final]

[xsl:params]
$type: The type of media element, either 'video' or 'audio'.
$ttml: Whether there are TTML subtitles for this media element.

This template outputs HTML containing controls for a media play for audio or
video HTML elements. To work with the built-in JavaScript binding code, it
should be placed immediately after the `audio` or `video` element.
-->
<xsl:template name="html.media.controls">
  <xsl:param name="type" select="'video'"/>
  <xsl:param name="ttml" select="false()"/>
  <div>
    <xsl:attribute name="class">
      <xsl:text>media-controls media-controls-</xsl:text>
      <xsl:value-of select="$type"/>
      <xsl:if test="$ttml">
        <xsl:text> media-controls-ttml</xsl:text>
      </xsl:if>
    </xsl:attribute>
    <button class="media-play">
      <xsl:attribute name="data-play-label">
        <xsl:call-template name="l10n.gettext">
          <xsl:with-param name="msgid" select="'Play'"/>
        </xsl:call-template>
      </xsl:attribute>
      <xsl:attribute name="data-pause-label">
        <xsl:call-template name="l10n.gettext">
          <xsl:with-param name="msgid" select="'Pause'"/>
        </xsl:call-template>
      </xsl:attribute>
      <xsl:attribute name="value">
        <xsl:call-template name="l10n.gettext">
          <xsl:with-param name="msgid" select="'Play'"/>
        </xsl:call-template>
      </xsl:attribute>
      <xsl:call-template name="icons.svg.media.play"/>
      <xsl:call-template name="icons.svg.media.pause"/>
    </button>
    <input type="range" class="media-range" value="0"/>
    <span class="media-time">
      <span class="media-current">0:00</span>
      <span class="media-duration">-:--</span>
    </span>
  </div>
</xsl:template>

</xsl:stylesheet>
