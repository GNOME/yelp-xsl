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
DITA to HTML - Lists

REMARK: Describe this module
-->


<!-- == Matched Templates == -->

<!-- = li = -->
<xsl:template mode="dita2html.topic.mode" match="&topic_li;">
  <li class="list">
    <xsl:call-template name="html.lang.attrs"/>
    <xsl:apply-templates mode="dita2html.topic.mode"/>
  </li>
</xsl:template>

<!-- = ul = -->
<xsl:template mode="dita2html.topic.mode" match="&topic_ol;">
  <div class="list">
    <xsl:call-template name="html.lang.attrs"/>
    <div class="inner">
      <ol class="list">
        <xsl:apply-templates mode="dita2html.topic.mode"/>
      </ol>
    </div>
  </div>
</xsl:template>

<!-- = step = -->
<xsl:template mode="dita2html.topic.mode" match="&topic_step;">
  <xsl:variable name="pre" select="preceding-sibling::&topic_step;"/>
  <li class="steps" value="{count($pre) + 1}">
    <xsl:call-template name="html.lang.attrs"/>
    <xsl:apply-templates mode="dita2html.topic.mode"/>
  </li>
</xsl:template>

<!-- = steps = -->
<xsl:template mode="dita2html.topic.mode" match="&topic_steps;">
  <div class="steps">
    <xsl:call-template name="html.lang.attrs"/>
    <div class="inner">
      <div class="region">
        <ol class="steps">
          <xsl:apply-templates mode="dita2html.topic.mode"/>
        </ol>
      </div>
    </div>
  </div>
</xsl:template>

<!-- = steps-unordered = -->
<xsl:template mode="dita2html.topic.mode" match="&topic_steps-unordered;">
  <div class="steps">
    <xsl:call-template name="html.lang.attrs"/>
    <div class="inner">
      <div class="region">
        <ul class="steps">
          <xsl:apply-templates mode="dita2html.topic.mode"/>
        </ul>
      </div>
    </div>
  </div>
</xsl:template>

<!-- = stepsection = -->
<xsl:template mode="dita2html.topic.mode" match="&topic_stepsection;">
  <li class="stepsection">
    <xsl:call-template name="html.lang.attrs"/>
    <xsl:apply-templates mode="dita2html.topic.mode"/>
  </li>
</xsl:template>

<!-- = substep = -->
<xsl:template mode="dita2html.topic.mode" match="&topic_substep;">
  <li class="steps substeps">
    <xsl:call-template name="html.lang.attrs"/>
    <xsl:apply-templates mode="dita2html.topic.mode"/>
  </li>
</xsl:template>

<!-- = substeps = -->
<xsl:template mode="dita2html.topic.mode" match="&topic_substeps;">
  <div class="substeps">
    <xsl:call-template name="html.lang.attrs"/>
    <ol class="substeps">
      <xsl:apply-templates mode="dita2html.topic.mode"/>
    </ol>
  </div>
</xsl:template>

<!-- = ul = -->
<xsl:template mode="dita2html.topic.mode" match="&topic_ul;">
  <div class="list">
    <xsl:call-template name="html.lang.attrs"/>
    <div class="inner">
      <ul class="list">
        <xsl:apply-templates mode="dita2html.topic.mode"/>
      </ul>
    </div>
  </div>
</xsl:template>

</xsl:stylesheet>
