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
along with this program; see the file COPYING.LGPL.  If not, write to the
Free Software Foundation, Inc., 59 Temple Place - Suite 330, Boston, MA
02111-1307, USA.
-->

<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
                version="1.0">

<!--!!==========================================================================
Common HTML Styling
Output CSS for transformations to HTML.
:Revision: version="1.0" date="2010-03-10"
:Requires: gettext theme-colors theme-icons

This stylesheet provides common CSS for all transformations to HTML.
Stylesheets which generate HTML should use the common elements and
classes references by the CSS rules in this stylesheet.
-->


<!--**==========================================================================
theme.html.css
Output CSS for transformations to HTML.
:Revision: version="1.0" date="2010-03-10"
$direction: The directionality of the text, either #{ltr} or #{rtl}.
$left: The starting alignment, either #{left} or #{right}.
$right: The ending alignment, either #{left} or #{right}.

This template outputs the common CSS for HTML transformations.  It is a wrapper
template that calls *{theme.html.css.core}, *{theme.html.css.elements}, and
*{theme.html.css.custom}.

All parameters can be automatically computed if not provided.
-->
<xsl:template name="theme.html.css">
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
  <xsl:call-template name="theme.html.css.core">
    <xsl:with-param name="direction" select="$direction"/>
    <xsl:with-param name="left" select="$left"/>
    <xsl:with-param name="right" select="$right"/>
  </xsl:call-template>
  <xsl:call-template name="theme.html.css.elements">
    <xsl:with-param name="direction" select="$direction"/>
    <xsl:with-param name="left" select="$left"/>
    <xsl:with-param name="right" select="$right"/>
  </xsl:call-template>
  <xsl:call-template name="theme.html.css.custom">
    <xsl:with-param name="direction" select="$direction"/>
    <xsl:with-param name="left" select="$left"/>
    <xsl:with-param name="right" select="$right"/>
  </xsl:call-template>
</xsl:template>


<!--**==========================================================================
theme.html.css.core
Output CSS that does not reference source elements.
:Revision: version="1.0" date="2010-03-10"
$direction: The directionality of the text, either #{ltr} or #{rtl}.
$left: The starting alignment, either #{left} or #{right}.
$right: The ending alignment, either #{left} or #{right}.

This template outputs CSS that can be used in any HTML.  It does not reference
elements from DocBook, Mallard, or other source languages.  It provides the
common spacings for block-level elements lik paragraphs and lists, defines
styles for links, and defines four common wrapper divs: #{head}, #{side},
#{body}, and #{foot}.

All parameters can be automatically computed if not provided.
-->
<xsl:template name="theme.html.css.core">
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
  <xsl:text>
html { height: 100%; }
body {
  margin: 0;
  padding-top: 1em;
  padding-</xsl:text><xsl:value-of select="$left"/><xsl:text>: 1em;
  background-color: </xsl:text>
    <xsl:value-of select="$theme.color.gray_background"/><xsl:text>;
  color: </xsl:text>
    <xsl:value-of select="$theme.color.text"/><xsl:text>;
  direction: </xsl:text><xsl:value-of select="$direction"/><xsl:text>;
  max-width: 73em;
  position: relative;
}
div.body {
  margin: 0;
  padding: 1em;
  max-width: 60em;
  min-height: 20em;
  background-color: </xsl:text>
    <xsl:value-of select="$theme.color.background"/><xsl:text>;
  border: solid 1px </xsl:text>
    <xsl:value-of select="$theme.color.gray_border"/><xsl:text>;
}
div.side {
  margin: 0; padding: 0;
  position: absolute;
  </xsl:text><xsl:value-of select="$right"/><xsl:text>: 0;
  width: 12em;
}
div.head {
  max-width: 60em;
}
div.foot {
  max-width: 60em;
}
div.side + div.body {
  margin-</xsl:text><xsl:value-of select="$right"/><xsl:text>: 13em;
}
div.side + div.body + div.foot {
  margin-</xsl:text><xsl:value-of select="$right"/><xsl:text>: 13em;
}
div.sect { margin-top: 1.72em; clear: both; }
div.sect div.sect {
  margin-top: 1.44em;
  margin-</xsl:text><xsl:value-of select="$left"/><xsl:text>: 1.72em;
}
div.trails { margin: 0; }
div.trail {
  font-size: 0.83em;
  margin: 0 1px 0.2em 1px;
  padding-</xsl:text><xsl:value-of select="$left"/><xsl:text>: 1.2em;
  color: </xsl:text>
    <xsl:value-of select="$theme.color.text_light"/><xsl:text>;
}
div.header {
  margin: 0;
  color: </xsl:text>
    <xsl:value-of select="$theme.color.text_light"/><xsl:text>;
  border-bottom: solid 1px </xsl:text>
    <xsl:value-of select="$theme.color.gray_border"/><xsl:text>;
}
h1, h2, h3, h4, h5, h6, h7 {
  margin: 0; padding: 0;
  color: </xsl:text><xsl:value-of select="$theme.color.text_light"/><xsl:text>;
  font-weight: bold;
}
h1 { font-size: 1.44em; }
h2 { font-size: 1.2em; }
h3.title, h4.title, h5.title, h6.title, h7.title { font-size: 1.2em; }
h3, h4, h5, h6, h7 { font-size: 1em; } 

p { line-height: 1.72em; }
div, pre, p { margin: 1em 0 0 0; padding: 0; }
div:first-child, pre:first-child, p:first-child { margin-top: 0; }
div.inner, div.contents, pre.contents { margin-top: 0; }
p img { vertical-align: middle; }

table {
  border-collapse: collapse;
  border-color: </xsl:text><xsl:value-of select="$theme.color.text_light"/><xsl:text>;
  border-width: 1px;
}
td, th {
  padding: 0.1em 0.5em 0.1em 0.5em;
  vertical-align: top;
  border-color: </xsl:text><xsl:value-of select="$theme.color.text_light"/><xsl:text>;
  border-width: 1px;
}

ul, ol, dl { margin: 0; padding: 0; }
li {
  margin: 1em 0 0 0;
  margin-</xsl:text><xsl:value-of select="$left"/><xsl:text>: 2.4em;
  padding: 0;
}
li:first-child { margin-top: 0; }
dt { margin-top: 1em; }
dt:first-child { margin-top: 0; }
dt + dt { margin-top: 0; }
dd {
  margin: 0.2em 0 0 0;
  margin-</xsl:text><xsl:value-of select="$left"/><xsl:text>: 1.44em;
}
ol.compact li { margin-top: 0.2em; }
ul.compact li { margin-top: 0.2em; }
ol.compact li:first-child { margin-top: 0; }
ul.compact li:first-child { margin-top: 0; }
dl.compact dt { margin-top: 0.2em; }
dl.compact dt:first-child { margin-top: 0; }
dl.compact dt + dt { margin-top: 0; }

a {
  text-decoration: none;
  color: </xsl:text><xsl:value-of select="$theme.color.link"/><xsl:text>;
}
a:visited { color: </xsl:text>
  <xsl:value-of select="$theme.color.link_visited"/><xsl:text>; }
a:hover { text-decoration: underline; }
a img { border: none; }
</xsl:text>
</xsl:template>


<!--**==========================================================================
theme.html.css.elements
Output CSS for common elements from source formats.
:Revision: version="1.0" date="2010-03-10"
$direction: The directionality of the text, either #{ltr} or #{rtl}.
$left: The starting alignment, either #{left} or #{right}.
$right: The ending alignment, either #{left} or #{right}.

This template outputs CSS for elements from source languages like DocBook and
Mallard.  It defines them using common class names.  The common names are often
the simpler element names from Mallard, although there some class names which
are not taken from Mallard.  Stylesheets which convert to HTML should use the
appropriate common classes.

All parameters can be automatically computed if not provided.
-->
<xsl:template name="theme.html.css.elements">
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
  <xsl:text>
div.title {
  margin: 0 0 0.2em 0;
  font-weight: bold;
  color: </xsl:text><xsl:value-of select="$theme.color.text_light"/><xsl:text>;
}
div.desc { margin: 0 0 0.2em 0; }
div.contents + div.desc { margin: 0.2em 0 0 0; }
pre.contents {
  padding: 0.5em 1em 0.5em 1em;
}
pre.linenumbering {
  margin: 0;
  padding: 0.5em;
  float: </xsl:text><xsl:value-of select="$left"/><xsl:text>;
  margin-</xsl:text><xsl:value-of select="$right"/><xsl:text>: 0.5em;
  text-align: </xsl:text><xsl:value-of select="$right"/><xsl:text>;
  color: </xsl:text><xsl:value-of select="$theme.color.text_light"/><xsl:text>;
  background-color: </xsl:text>
    <xsl:value-of select="$theme.color.yellow_background"/><xsl:text>;
}
div.code {
  background: url('</xsl:text>
    <xsl:value-of select="$theme.icons.code"/><xsl:text>') no-repeat top </xsl:text>
    <xsl:value-of select="$right"/><xsl:text>;
  border: solid 1px </xsl:text>
    <xsl:value-of select="$theme.color.gray_border"/><xsl:text>;
}
div.figure {
  margin-</xsl:text><xsl:value-of select="$left"/><xsl:text>: 1.72em;
  padding: 4px;
  color: </xsl:text>
    <xsl:value-of select="$theme.color.text_light"/><xsl:text>;
  border: solid 1px </xsl:text>
    <xsl:value-of select="$theme.color.gray_border"/><xsl:text>;
  background-color: </xsl:text>
    <xsl:value-of select="$theme.color.gray_background"/><xsl:text>;
}
div.figure > div.inner > div.contents {
  margin: 0;
  padding: 0.5em 1em 0.5em 1em;
  text-align: center;
  color: </xsl:text>
    <xsl:value-of select="$theme.color.text"/><xsl:text>;
  border: solid 1px </xsl:text>
    <xsl:value-of select="$theme.color.gray_border"/><xsl:text>;
  background-color: </xsl:text>
    <xsl:value-of select="$theme.color.background"/><xsl:text>;
}
div.list > div.title { margin-bottom: 0.5em; }
div.listing > div.inner { margin: 0; padding: 0; }
div.listing > div.inner > div.desc { font-style: italic; }
div.note {
  padding: 6px;
  border-top: solid 1px </xsl:text>
    <xsl:value-of select="$theme.color.red_border"/><xsl:text>;
  border-bottom: solid 1px </xsl:text>
    <xsl:value-of select="$theme.color.red_border"/><xsl:text>;
  background-color: </xsl:text>
    <xsl:value-of select="$theme.color.yellow_background"/><xsl:text>;
}
div.note > div.inner > div.title {
  margin-</xsl:text><xsl:value-of select="$left"/><xsl:text>: </xsl:text>
    <xsl:value-of select="$theme.icons.size.note + 6"/><xsl:text>px;
}
div.note > div.inner > div.contents {
  margin: 0; padding: 0;
  margin-</xsl:text><xsl:value-of select="$left"/><xsl:text>: </xsl:text>
    <xsl:value-of select="$theme.icons.size.note + 6"/><xsl:text>px;
}
div.note > div.inner {
  margin: 0; padding: 0;
  background-image: url("</xsl:text>
    <xsl:value-of select="$theme.icons.note"/><xsl:text>");
  background-position: </xsl:text><xsl:value-of select="$left"/><xsl:text> top;
  background-repeat: no-repeat;
  min-height: </xsl:text><xsl:value-of select="$theme.icons.size.note"/><xsl:text>px;
}
div.note-advanced div.inner { <!-- background-image: url("</xsl:text>
  <xsl:value-of select="$theme.icons.note.advanced"/><xsl:text>"); --> }
div.note-bug div.inner { background-image: url("</xsl:text>
  <xsl:value-of select="$theme.icons.note.bug"/><xsl:text>"); }
div.note-important div.inner { background-image: url("</xsl:text>
  <xsl:value-of select="$theme.icons.note.important"/><xsl:text>"); }
div.note-tip div.inner { background-image: url("</xsl:text>
  <xsl:value-of select="$theme.icons.note.tip"/><xsl:text>"); }
div.note-warning div.inner { background-image: url("</xsl:text>
  <xsl:value-of select="$theme.icons.note.warning"/><xsl:text>"); }
div.quote {
  padding: 0;
  background-image: url('</xsl:text>
    <xsl:value-of select="$theme.icons.quote"/><xsl:text>');
  background-repeat: no-repeat;
  background-position: top </xsl:text><xsl:value-of select="$left"/><xsl:text>;
  min-height: </xsl:text>
    <xsl:value-of select="$theme.icons.size.quote"/><xsl:text>px;
}
div.quote > div.inner > div.title {
  margin: 0 0 0.5em 0;
  margin-</xsl:text><xsl:value-of select="$left"/><xsl:text>: </xsl:text>
    <xsl:value-of select="$theme.icons.size.quote"/><xsl:text>px;
}
blockquote {
  margin: 0; padding: 0;
  margin-</xsl:text><xsl:value-of select="$left"/><xsl:text>: </xsl:text>
    <xsl:value-of select="$theme.icons.size.quote"/><xsl:text>px;
}
div.quote > div.inner > div.cite {
  margin-top: 0.5em;
  margin-</xsl:text><xsl:value-of select="$left"/><xsl:text>: </xsl:text>
    <xsl:value-of select="$theme.icons.size.quote"/><xsl:text>px;
  color: </xsl:text><xsl:value-of select="$theme.color.text_light"/><xsl:text>;
}
div.quote > div.inner > div.cite::before {
  <!-- FIXME: i18n -->
  content: '&#x2015; ';
}
div.screen {
  background-color: </xsl:text>
    <xsl:value-of select="$theme.color.gray_background"/><xsl:text>;
  border: solid 1px </xsl:text>
    <xsl:value-of select="$theme.color.gray_border"/><xsl:text>;
}
ol.steps, ul.steps {
  margin: 0;
  padding: 0.5em 1em 0.5em 1em;
  border-top: solid 1px;
  border-bottom: solid 1px;
  border-color: </xsl:text>
    <xsl:value-of select="$theme.color.blue_border"/><xsl:text>;
  background-color: </xsl:text>
    <xsl:value-of select="$theme.color.yellow_background"/><xsl:text>;
}
ol.steps .steps {
  padding: 0;
  border: none;
  background-color: none;
}
li.steps { margin-</xsl:text><xsl:value-of select="$left"/><xsl:text>: 1.44em; }
li.steps li.steps { margin-</xsl:text><xsl:value-of select="$left"/><xsl:text>: 2.4em; }
div.synopsis > div.inner > div.contents, div.synopsis > pre.contents {
  padding: 0.5em 1em 0.5em 1em;
  border-top: solid 1px;
  border-bottom: solid 1px;
  border-color: </xsl:text>
    <xsl:value-of select="$theme.color.blue_border"/><xsl:text>;
  background-color: </xsl:text>
    <xsl:value-of select="$theme.color.gray_background"/><xsl:text>;
}
div.synopsis > div.inner > div.desc { font-style: italic; }
div.synopsis div.code {
  background: none;
  border: none;
  padding: 0;
}
div.synopsis div.code > pre.contents { margin: 0; padding: 0; }
.table {}
tr.shade {
  background-color: </xsl:text><xsl:value-of select="$theme.color.gray_background"/><xsl:text>;
}
td.shade {
  background-color: </xsl:text><xsl:value-of select="$theme.color.gray_background"/><xsl:text>;
}
tr.shade td.shade {
  background-color: </xsl:text><xsl:value-of select="$theme.color.dark_background"/><xsl:text>;
}

span.app { font-style: italic; }
span.cmd {
  font-family: monospace;
  background-color: </xsl:text>
    <xsl:value-of select="$theme.color.gray_background"/><xsl:text>;
  padding: 0 0.2em 0 0.2em;
}
span.cmd span.cmd { background-color: none; padding: 0; }
pre span.cmd { background-color: none; padding: 0; }
span.code {
  font-family: monospace;
  border-bottom: solid 1px </xsl:text><xsl:value-of select="$theme.color.dark_background"/><xsl:text>;
}
span.code span.code { border: none; }
pre span.code { border: none; }
span.em { font-style: italic; }
span.em-bold {
  font-style: normal; font-weight: bold;
  color: </xsl:text><xsl:value-of select="$theme.color.text_light"/><xsl:text>;
}
pre span.error {
  color: </xsl:text><xsl:value-of select="$theme.color.text_error"/><xsl:text>;
}
span.file { font-family: monospace; }
span.gui, span.guiseq { color: </xsl:text>
  <xsl:value-of select="$theme.color.text_light"/><xsl:text>; }
span.input { font-family: monospace; }
pre span.input {
  font-weight: bold;
  color: </xsl:text><xsl:value-of select="$theme.color.text_light"/><xsl:text>;
}
span.key {
  color: </xsl:text>
    <xsl:value-of select="$theme.color.text_light"/><xsl:text>;
  border: solid 1px </xsl:text>
    <xsl:value-of select="$theme.color.yellow_border"/><xsl:text>;
  padding: 0 0.2em 0 0.2em;
}
span.keyseq {
  color: </xsl:text>
    <xsl:value-of select="$theme.color.text_light"/><xsl:text>;
}
span.output { font-family: monospace; }
pre span.output {
  color: </xsl:text><xsl:value-of select="$theme.color.text"/><xsl:text>;
}
pre span.prompt {
  color: </xsl:text><xsl:value-of select="$theme.color.text_light"/><xsl:text>;
}
span.sys { font-family: monospace; }
span.var { font-style: italic; }
</xsl:text>
</xsl:template>


<!--**==========================================================================
theme.html.css.custom
Stub to output custom CSS common to all HTML transformations.
:Revision: version="1.0" date="2010-03-10"
:Stub: true
$direction: The directionality of the text, either #{ltr} or #{rtl}.
$left: The starting alignment, either #{left} or #{right}.
$right: The ending alignment, either #{left} or #{right}.

This template is a stub, called by *{theme.html.css}.  You can override this
template to provide additional CSS that will be used by all HTML output.
-->
<xsl:template name="theme.html.css.custom">
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

</xsl:stylesheet>
