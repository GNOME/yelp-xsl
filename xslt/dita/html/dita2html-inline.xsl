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

<!--**==========================================================================
dita2html.span
Output an HTML #{span} element.
:Revision:version="3.8" date="2012-10-04" status="incomplete"
$node: The source element to output a #{span} for.
$class: The value of the HTML #{class} attribute.

FIXME
-->
<xsl:template name="dita2html.span">
  <xsl:param name="node" select="."/>
  <xsl:param name="class" select="local-name($node)"/>
  <span class="{$class}">
    <xsl:call-template name="dita.id">
      <xsl:with-param name="node" select="$node"/>
    </xsl:call-template>
    <xsl:call-template name="html.lang.attrs">
      <xsl:with-param name="node" select="$node"/>
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
  <xsl:variable name="format">
    <xsl:call-template name="dita.ref.conref.attr">
      <xsl:with-param name="attr" select="'format'"/>
      <xsl:with-param name="node" select="."/>
      <xsl:with-param name="conref" select="$conref"/>
    </xsl:call-template>
  </xsl:variable>
  <xsl:variable name="scope">
    <xsl:call-template name="dita.ref.conref.attr">
      <xsl:with-param name="attr" select="'scope'"/>
      <xsl:with-param name="node" select="."/>
      <xsl:with-param name="conref" select="$conref"/>
    </xsl:call-template>
  </xsl:variable>
  <xsl:variable name="type">
    <xsl:call-template name="dita.ref.conref.attr">
      <xsl:with-param name="attr" select="'type'"/>
      <xsl:with-param name="node" select="."/>
      <xsl:with-param name="conref" select="$conref"/>
    </xsl:call-template>
  </xsl:variable>
  <a>
    <xsl:attribute name="href">
      <xsl:call-template name="dita.ref.href.target"/>
    </xsl:attribute>
    <xsl:choose>
      <xsl:when test="$conref/node()[not(self::&topic_desc;)]">
        <xsl:apply-templates mode="dita2html.topic.mode"
                             select="$conref/node()[not(self::&topic_desc;)]"/>
      </xsl:when>
      <xsl:when test="$scope = 'external' or ($format != '' and $format != 'dita')">
        <xsl:value-of select="@href"/>
      </xsl:when>
      <xsl:otherwise>
        <xsl:variable name="href" select="@href"/>
        <xsl:variable name="uri">
          <xsl:choose>
            <xsl:when test="contains($href, '#')">
              <xsl:value-of select="substring-before($href, '#')"/>
            </xsl:when>
            <xsl:otherwise>
              <xsl:value-of select="$href"/>
            </xsl:otherwise>
          </xsl:choose>
        </xsl:variable>
        <xsl:for-each name="target" select="document($uri, .)">
          <xsl:variable name="frag">
            <xsl:choose>
              <xsl:when test="contains($href, '#')">
                <xsl:value-of select="substring-after($href, '#')"/>
              </xsl:when>
              <xsl:otherwise>
                <xsl:value-of select="/*/@id"/>
              </xsl:otherwise>
            </xsl:choose>
          </xsl:variable>
          <xsl:variable name="tnode" select="key('dita.id.key', $frag)"/>
          <xsl:apply-templates mode="dita2html.topic.mode" select="$tnode/&topic_title;/node()"/>
        </xsl:for-each>
      </xsl:otherwise>
    </xsl:choose>
  </a>
</xsl:template>

</xsl:stylesheet>
