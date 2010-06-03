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
                xmlns:mal="http://projectmallard.org/1.0/"
                xmlns:exsl="http://exslt.org/common"
                xmlns="http://www.w3.org/1999/xhtml"
                exclude-result-prefixes="mal"
                extension-element-prefixes="exsl"
                version="1.0">

<!--!!==========================================================================
Mallard to HTML - CSS
-->

<xsl:template mode="html.css.mode" match="mal:page">
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
div.floatleft {
  float: left;
  margin-top: 0;
  margin-right: 1em;
}
div.floatright {
  float: right;
  margin-top: 0;
  margin-left: 1em;
}

div.navbar {
  margin: 0;
  float: right;
}
a.navbar-prev::before {
  content: '</xsl:text><xsl:choose>
  <xsl:when test="$left = 'left'"><xsl:text>&#x25C0;&#x00A0;&#x00A0;</xsl:text></xsl:when>
  <xsl:otherwise><xsl:text>&#x25B6;&#x00A0;&#x00A0;</xsl:text></xsl:otherwise>
  </xsl:choose><xsl:text>';
  color: </xsl:text><xsl:value-of select="$color.text_light"/><xsl:text>;
}
a.navbar-next::after {
  content: '</xsl:text><xsl:choose>
  <xsl:when test="$left = 'left'"><xsl:text>&#x00A0;&#x00A0;&#x25B6;</xsl:text></xsl:when>
  <xsl:otherwise><xsl:text>&#x00A0;&#x00A0;&#x25C0;</xsl:text></xsl:otherwise>
  </xsl:choose><xsl:text>';
  color: </xsl:text><xsl:value-of select="$color.text_light"/><xsl:text>;
}
div.copyrights {
  text-align: center;
  color: </xsl:text>
    <xsl:value-of select="$color.text_light"/><xsl:text>;
}

div.autolinks ul { margin: 0; padding: 0; }
div.autolinks div.title { margin: 1em 0 0 1em; }
div.autolinks div.title span {
  border-bottom: solid 1px </xsl:text>
    <xsl:value-of select="$color.gray_border"/><xsl:text>;
}
li.autolink { margin: 0.5em 0 0 0; padding: 0 0 0 1em; list-style-type: none; }

table.twocolumn { width: 100%; }
td.twocolumnleft { width: 48%; vertical-align: top; padding: 0; margin: 0; }
td.twocolumnright {
  width: 52%; vertical-align: top;
  margin: 0; padding: 0;
  padding-</xsl:text><xsl:value-of select="$left"/><xsl:text>: 1em;
}

div.linkdiv div.title {
  font-size: 1em;
  color: inherit;
}
div.linkdiv div.desc {
  color: </xsl:text><xsl:value-of select="$color.text_light"/><xsl:text>;
}
div.linkdiv {
  margin: 0;
  padding: 0.5em;
  -moz-border-radius: 6px;
  border: solid 1px </xsl:text>
    <xsl:value-of select="$color.background"/><xsl:text>;
}
a:hover div.linkdiv {
  text-decoration: none;
  border-color: </xsl:text>
    <xsl:value-of select="$color.blue_border"/><xsl:text>;
  background-color: </xsl:text>
    <xsl:value-of select="$color.blue_background"/><xsl:text>;
}

div.example {
  border-</xsl:text><xsl:value-of select="$left"/><xsl:text>: solid 4px </xsl:text>
    <xsl:value-of select="$color.gray_border"/><xsl:text>;
  padding-</xsl:text><xsl:value-of select="$left"/><xsl:text>: 1em;
}

div.cite-comment {
  margin-top: 0.5em;
  color: </xsl:text><xsl:value-of select="$color.text_light"/><xsl:text>;
}


ul.tree {
  margin: 0; padding: 0;
  list-style-type: none;
}
li.tree { margin: 0; padding: 0; }
li.tree div { margin: 0; padding: 0; }
ul.tree ul.tree { margin-</xsl:text><xsl:value-of select="$left"/><xsl:text>: 1.44em; }
div.tree-lines ul.tree { margin-left: 0; }

span.hi {
  background-color: </xsl:text>
    <xsl:value-of select="$color.yellow_background"/><xsl:text>;
}
</xsl:text>
<xsl:if test="$mal2html.editor_mode">
<xsl:text>
div.version {
  position: absolute;
  </xsl:text><xsl:value-of select="$right"/><xsl:text>: 12px;
  opacity: 0.2;
  margin-top: -1em;
  padding: 0.5em 1em 0.5em 1em;
  max-width: 24em;
  -moz-border-radius: 6px;
  border: solid 1px </xsl:text>
    <xsl:value-of select="$color.gray_border"/><xsl:text>;
  background-color: </xsl:text>
    <xsl:value-of select="$color.yellow_background"/><xsl:text>;
}
div.version:hover { opacity: 0.8; }
div.version p.version { margin-top: 0.2em; }
div.linkdiv div.title span.status {
  font-size: 0.83em;
  font-weight: normal;
  padding-left: 0.2em;
  padding-right: 0.2em;
  color: </xsl:text>
    <xsl:value-of select="$color.text_light"/><xsl:text>;
  border: solid 1px </xsl:text>
    <xsl:value-of select="$color.red_border"/><xsl:text>;
}
div.linkdiv div.title span.status-stub { background-color: </xsl:text>
  <xsl:value-of select="$color.red_background"/><xsl:text>; }
div.linkdiv div.title span.status-draft { background-color: </xsl:text>
  <xsl:value-of select="$color.red_background"/><xsl:text>; }
div.linkdiv div.title span.status-incomplete { background-color: </xsl:text>
  <xsl:value-of select="$color.red_background"/><xsl:text>; }
div.linkdiv div.title span.status-review { background-color: </xsl:text>
  <xsl:value-of select="$color.yellow_background"/><xsl:text>; }
div.linkdiv div.desc {
  margin-top: 0.2em;
  color: </xsl:text>
    <xsl:value-of select="$color.text_light"/><xsl:text>;
}
div.comment {
  padding: 0.5em;
  border: solid 2px </xsl:text>
    <xsl:value-of select="$color.red_border"/><xsl:text>;
  background-color: </xsl:text>
    <xsl:value-of select="$color.red_background"/><xsl:text>;
}
div.comment div.comment {
  margin: 1em 1em 0 1em;
}
div.comment div.cite {
  margin: 0 0 0.5em 0;
  font-style: italic;
}
</xsl:text>
</xsl:if>
</xsl:template>

</xsl:stylesheet>
