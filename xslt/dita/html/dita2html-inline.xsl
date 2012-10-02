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


<!-- == Matched Templates == -->

<!-- = codeph = -->
<xsl:template mode="dita2html.topic.mode" match="&topic_codeph;">
  <span class="code">
    <xsl:call-template name="html.lang.attrs"/>
    <xsl:apply-templates mode="dita2html.topic.mode"/>
  </span>
</xsl:template>

<!-- = cmdname = -->
<xsl:template mode="dita2html.topic.mode" match="&topic_cmdname;">
  <span class="cmd">
    <xsl:call-template name="html.lang.attrs"/>
    <xsl:apply-templates mode="dita2html.topic.mode"/>
  </span>
</xsl:template>

<!-- = filepath = -->
<xsl:template mode="dita2html.topic.mode" match="&topic_filepath;">
  <span class="file">
    <xsl:call-template name="html.lang.attrs"/>
    <xsl:apply-templates mode="dita2html.topic.mode"/>
  </span>
</xsl:template>

<!-- = systemoutput = -->
<xsl:template mode="dita2html.topic.mode" match="&topic_systemoutput;">
  <span class="output">
    <xsl:call-template name="html.lang.attrs"/>
    <xsl:apply-templates mode="dita2html.topic.mode"/>
  </span>
</xsl:template>

<!-- = uicontrol = -->
<xsl:template mode="dita2html.topic.mode" match="&topic_uicontrol;">
  <span class="gui">
    <xsl:call-template name="html.lang.attrs"/>
    <xsl:apply-templates mode="dita2html.topic.mode"/>
  </span>
</xsl:template>

<!-- = userinput = -->
<xsl:template mode="dita2html.topic.mode" match="&topic_userinput;">
  <span class="input">
    <xsl:call-template name="html.lang.attrs"/>
    <xsl:apply-templates mode="dita2html.topic.mode"/>
  </span>
</xsl:template>

<!-- = varname = -->
<xsl:template mode="dita2html.topic.mode" match="&topic_varname;">
  <span class="var">
    <xsl:call-template name="html.lang.attrs"/>
    <xsl:apply-templates mode="dita2html.topic.mode"/>
  </span>
</xsl:template>

</xsl:stylesheet>
