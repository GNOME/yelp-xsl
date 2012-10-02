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
<!ENTITY % selectors SYSTEM "selectors.mod">
%selectors;
]>

<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
                xmlns="http://www.w3.org/1999/xhtml"
                version="1.0">

<!--!!==========================================================================
DITA to HTML - Inlines

REMARK: Describe this module
-->

<!--**==========================================================================
dita2html.span
Output an HTML #{span} element.
:Revision:version="1.0" date="2010-06-03" status="final"
$node: The source element to output a #{span} for.
$class: The value of the HTML #{class} attribute.

FIXME
-->
<xsl:template name="dita2html.span">
  <xsl:param name="node" select="."/>
  <xsl:param name="class" select="local-name($node)"/>
  <span class="{$class}">
    <xsl:call-template name="html.lang.attrs">
      <xsl:with-param name="node" select="$node"/>
    </xsl:call-template>
    <xsl:apply-templates mode="dita2html.inline.content.mode" select="$node"/>
  </span>
</xsl:template>

<xsl:template mode="dita2html.inline.content.mode" match="*">
  <xsl:apply-templates mode="dita2html.topic.mode"/>
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

<!-- = systemoutput = -->
<xsl:template mode="dita2html.topic.mode" match="&topic_systemoutput;">
  <xsl:call-template name="dita2html.span">
    <xsl:with-param name="class" select="'output'"/>
  </xsl:call-template>
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

</xsl:stylesheet>
