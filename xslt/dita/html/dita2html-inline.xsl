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
along with this program; see the file COPYING.LGPL.  If not, see <http://www.gnu.org/licenses/>.
-->
<!DOCTYPE xsl:stylesheet [
<!ENTITY % selectors SYSTEM "../common/dita-selectors.mod">
%selectors;
]>

<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
                xmlns:yelp="http://projects.gnome.org/yelp/"
                xmlns="http://www.w3.org/1999/xhtml"
                exclude-result-prefixes="yelp"
                version="1.0">

<!--!!==========================================================================
DITA to HTML - Inlines

REMARK: Describe this module
-->


<xsl:template mode="dita.ref.content.mode" match="*">
  <xsl:apply-templates mode="dita2html.topic.mode" select="."/>
</xsl:template>


<!--**==========================================================================
dita2html.span
Output an HTML `span` element.
@revision[version=3.8 date=2012-10-04 status=incomplete]

[xsl:params]
$node: The source element to output a `span` for.
$class: The value of the HTML `class` attribute.

FIXME
-->
<xsl:template name="dita2html.span">
  <xsl:param name="node" select="."/>
  <xsl:param name="class" select="local-name($node)"/>
  <span>
    <xsl:call-template name="dita.id">
      <xsl:with-param name="node" select="$node"/>
    </xsl:call-template>
    <xsl:call-template name="html.lang.attrs">
      <xsl:with-param name="node" select="$node"/>
    </xsl:call-template>
    <xsl:call-template name="html.class.attr">
      <xsl:with-param name="node" select="$node"/>
      <xsl:with-param name="class" select="$class"/>
    </xsl:call-template>
    <xsl:apply-templates mode="dita2html.inline.content.mode" select="$node"/>
  </span>
</xsl:template>

<xsl:template mode="dita2html.inline.content.mode" match="*">
  <xsl:variable name="conref" select="yelp:dita.ref.conref(.)"/>
  <xsl:apply-templates mode="dita2html.topic.mode" select="$conref/node()"/>
</xsl:template>


<!-- == Matched Templates == -->

<!-- = b = -->
<xsl:template mode="dita2html.topic.mode" match="&topic_b;">
  <xsl:call-template name="dita2html.span"/>
</xsl:template>

<!-- = codeph = -->
<xsl:template mode="dita2html.topic.mode" match="&topic_codeph;">
  <xsl:call-template name="dita2html.span">
    <xsl:with-param name="class" select="'code'"/>
  </xsl:call-template>
</xsl:template>

<!-- = cmdname = -->
<xsl:template mode="dita2html.topic.mode" match="&topic_cmdname;">
  <xsl:call-template name="dita2html.span">
    <xsl:with-param name="class" select="'cmd'"/>
  </xsl:call-template>
</xsl:template>

<!-- = filepath = -->
<xsl:template mode="dita2html.topic.mode" match="&topic_filepath;">
  <xsl:call-template name="dita2html.span">
    <xsl:with-param name="class" select="'file'"/>
  </xsl:call-template>
</xsl:template>

<!-- = i = -->
<xsl:template mode="dita2html.topic.mode" match="&topic_i;">
  <xsl:call-template name="dita2html.span"/>
</xsl:template>

<!-- = menucascade = -->
<xsl:template mode="dita2html.topic.mode" match="&topic_menucascade;">
  <xsl:call-template name="dita2html.span">
    <xsl:with-param name="class" select="'guiseq'"/>
  </xsl:call-template>
</xsl:template>

<!-- = menucascade % dita2html.inline.content.mode = -->
<xsl:template mode="dita2html.inline.content.mode" match="&topic_menucascade;">
  <xsl:variable name="conref" select="yelp:dita.ref.conref(.)"/>
  <xsl:for-each select="$conref">
    <xsl:variable name="arrow">
      <xsl:variable name="dir">
        <xsl:call-template name="l10n.direction"/>
      </xsl:variable>
      <xsl:choose>
        <xsl:when test="$dir = 'rtl'">
          <xsl:text>&#x00A0;&#x25C2; </xsl:text>
        </xsl:when>
        <xsl:otherwise>
          <xsl:text>&#x00A0;&#x25B8; </xsl:text>
        </xsl:otherwise>
      </xsl:choose>
    </xsl:variable>
    <xsl:for-each select="&topic_uicontrol;">
      <xsl:if test="position() != 1">
        <xsl:value-of select="$arrow"/>
      </xsl:if>
      <xsl:apply-templates mode="dita2html.topic.mode" select="."/>
    </xsl:for-each>
  </xsl:for-each>
</xsl:template>

<!-- = shortcut = -->
<xsl:template mode="dita2html.topic.mode" match="&topic_shortcut;">
  <xsl:call-template name="dita2html.span">
    <xsl:with-param name="class" select="'shortcut'"/>
  </xsl:call-template>
</xsl:template>

<!-- = systemoutput = -->
<xsl:template mode="dita2html.topic.mode" match="&topic_systemoutput;">
  <xsl:call-template name="dita2html.span">
    <xsl:with-param name="class" select="'output'"/>
  </xsl:call-template>
</xsl:template>

<!-- = text = -->
<xsl:template mode="dita2html.topic.mode" match="&topic_text;">
  <xsl:call-template name="dita2html.span"/>
</xsl:template>

<!-- = tt = -->
<xsl:template mode="dita2html.topic.mode" match="&topic_tt;">
  <xsl:call-template name="dita2html.span">
    <xsl:with-param name="class" select="'sys'"/>
  </xsl:call-template>
</xsl:template>

<!-- = u = -->
<xsl:template mode="dita2html.topic.mode" match="&topic_u;">
  <xsl:call-template name="dita2html.span"/>
</xsl:template>

<!-- = uicontrol = -->
<xsl:template mode="dita2html.topic.mode" match="&topic_uicontrol;">
  <xsl:call-template name="dita2html.span">
    <xsl:with-param name="class" select="'gui'"/>
  </xsl:call-template>
</xsl:template>

<!-- = userinput = -->
<xsl:template mode="dita2html.topic.mode" match="&topic_userinput;">
  <xsl:call-template name="dita2html.span">
    <xsl:with-param name="class" select="'input'"/>
  </xsl:call-template>
</xsl:template>

<!-- = varname = -->
<xsl:template mode="dita2html.topic.mode" match="&topic_varname;">
  <xsl:call-template name="dita2html.span">
    <xsl:with-param name="class" select="'var'"/>
  </xsl:call-template>
</xsl:template>

<!-- = wintitle = -->
<xsl:template mode="dita2html.topic.mode" match="&topic_wintitle;">
  <xsl:call-template name="dita2html.span">
    <xsl:with-param name="class" select="'gui'"/>
  </xsl:call-template>
</xsl:template>

<!-- = xref = -->
<xsl:template mode="dita2html.topic.mode" match="&topic_xref;">
  <xsl:variable name="conref" select="yelp:dita.ref.conref(.)"/>
  <a>
    <xsl:call-template name="html.class.attr"/>
    <xsl:call-template name="html.lang.attrs"/>
    <xsl:attribute name="href">
      <xsl:call-template name="dita.ref.href.target">
        <xsl:with-param name="node" select="."/>
        <xsl:with-param name="conref" select="$conref"/>
      </xsl:call-template>
    </xsl:attribute>
    <xsl:call-template name="dita.ref.href.content">
      <xsl:with-param name="node" select="."/>
      <xsl:with-param name="conref" select="$conref"/>
    </xsl:call-template>
  </a>
</xsl:template>

</xsl:stylesheet>
