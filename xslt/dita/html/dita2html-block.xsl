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
DITA to HTML - Blocks

REMARK: Describe this module
-->


<!-- == Matched Templates == -->

<!-- = cmd = -->
<xsl:template mode="dita2html.topic.mode" match="&topic_cmd;">
  <p>
    <xsl:copy-of select="@id"/>
    <xsl:call-template name="html.lang.attrs"/>
    <xsl:apply-templates mode="dita2html.topic.mode"/>
  </p>
</xsl:template>

<!-- = codeblock = -->
<xsl:template mode="dita2html.topic.mode" match="&topic_codeblock;">
  <div class="code">
    <xsl:copy-of select="@id"/>
    <xsl:call-template name="html.lang.attrs"/>
    <pre class="contents">
      <xsl:apply-templates mode="dita2html.topic.mode"/>
    </pre>
  </div>
</xsl:template>

<!-- = context = -->
<xsl:template mode="dita2html.topic.mode" match="&topic_context;">
  <div class="context">
    <xsl:copy-of select="@id"/>
    <xsl:call-template name="html.lang.attrs"/>
    <xsl:apply-templates mode="dita2html.topic.mode"/>
  </div>
</xsl:template>

<!-- = desc = -->
<xsl:template mode="dita2html.topic.mode" match="&topic_desc;">
  <div class="desc">
    <xsl:copy-of select="@id"/>
    <xsl:call-template name="html.lang.attrs"/>
    <xsl:apply-templates mode="dita2html.topic.mode"/>
  </div>
</xsl:template>

<!-- = info = -->
<xsl:template mode="dita2html.topic.mode" match="&topic_info;">
  <p>
    <xsl:copy-of select="@id"/>
    <xsl:call-template name="html.lang.attrs"/>
    <xsl:apply-templates mode="dita2html.topic.mode"/>
  </p>
</xsl:template>

<!-- = note = -->
<xsl:template mode="dita2html.topic.mode" match="&topic_note;">
  <xsl:variable name="notetype">
    <xsl:choose>
      <xsl:when test="@type = 'attention' or @type = 'important' or
                      @type = 'remember' or @type = 'restriction'">
        <xsl:text>important</xsl:text>
      </xsl:when>
      <xsl:when test="@type = 'caution' or @type = 'danger' or
                      @type = 'notice' or @type = 'warning'">
        <xsl:text>warning</xsl:text>
      </xsl:when>
      <xsl:when test="@type = 'fastpath' or @type = 'tip'">
        <xsl:text>tip</xsl:text>
      </xsl:when>
    </xsl:choose>
  </xsl:variable>
  <div>
    <xsl:copy-of select="@id"/>
    <xsl:call-template name="html.lang.attrs"/>
    <xsl:attribute name="class">
      <xsl:text>note</xsl:text>
      <xsl:if test="$notetype != ''">
        <xsl:text> note-</xsl:text>
        <xsl:value-of select="$notetype"/>
      </xsl:if>
    </xsl:attribute>
    <div class="inner">
      <div class="region">
        <div class="contents">
          <xsl:apply-templates mode="dita2html.topic.mode"/>
        </div>
      </div>
    </div>
  </div>
</xsl:template>

<!-- = p = -->
<xsl:template mode="dita2html.topic.mode" match="&topic_p;">
  <p>
    <xsl:copy-of select="@id"/>
    <xsl:call-template name="html.lang.attrs"/>
    <xsl:apply-templates mode="dita2html.topic.mode"/>
  </p>
</xsl:template>

<!-- = postreq = -->
<xsl:template mode="dita2html.topic.mode" match="&topic_postreq;">
  <div class="postreq">
    <xsl:copy-of select="@id"/>
    <xsl:call-template name="html.lang.attrs"/>
    <xsl:apply-templates mode="dita2html.topic.mode"/>
  </div>
</xsl:template>

<!-- = prereq = -->
<xsl:template mode="dita2html.topic.mode" match="&topic_prereq;">
  <div class="prereq">
    <xsl:copy-of select="@id"/>
    <xsl:call-template name="html.lang.attrs"/>
    <xsl:apply-templates mode="dita2html.topic.mode"/>
  </div>
</xsl:template>

<!-- = result = -->
<xsl:template mode="dita2html.topic.mode" match="&topic_result;">
  <div class="result">
    <xsl:copy-of select="@id"/>
    <xsl:call-template name="html.lang.attrs"/>
    <xsl:apply-templates mode="dita2html.topic.mode"/>
  </div>
</xsl:template>

<!-- = section = -->
<xsl:template mode="dita2html.topic.mode" match="&topic_section;">
  <div class="section">
    <xsl:copy-of select="@id"/>
    <xsl:call-template name="html.lang.attrs"/>
    <xsl:apply-templates mode="dita2html.topic.mode"/>
  </div>
</xsl:template>

<!-- = shortdesc = -->
<xsl:template mode="dita2html.topic.mode" match="&topic_shortdesc;">
  <p class="shortdesc">
    <xsl:copy-of select="@id"/>
    <xsl:call-template name="html.lang.attrs"/>
    <xsl:apply-templates mode="dita2html.topic.mode"/>
  </p>
</xsl:template>

<!-- = stepresult = -->
<xsl:template mode="dita2html.topic.mode" match="&topic_stepresult;">
  <p>
    <xsl:copy-of select="@id"/>
    <xsl:call-template name="html.lang.attrs"/>
    <xsl:apply-templates mode="dita2html.topic.mode"/>
  </p>
</xsl:template>

<!-- = stepxmp = -->
<xsl:template mode="dita2html.topic.mode" match="&topic_stepxmp;">
  <div class="example">
    <xsl:copy-of select="@id"/>
    <xsl:call-template name="html.lang.attrs"/>
    <xsl:apply-templates mode="dita2html.topic.mode"/>
  </div>
</xsl:template>

<!-- = title = -->
<xsl:template mode="dita2html.topic.mode" match="&topic_title;">
  <xsl:variable name="depth" select="count(ancestor::&topic_topic_all;) + 1"/>
  <xsl:variable name="depth_">
    <xsl:choose>
      <xsl:when test="$depth &lt; 6">
        <xsl:value-of select="$depth"/>
      </xsl:when>
      <xsl:otherwise>
        <xsl:value-of select="6"/>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:variable>
  <div class="title">
    <xsl:copy-of select="@id"/>
    <xsl:call-template name="html.lang.attrs"/>
    <xsl:element name="{concat('h', $depth_)}" namespace="{$html.namespace}">
      <xsl:apply-templates mode="dita2html.topic.mode"/>
    </xsl:element>
  </div>
</xsl:template>

<!-- = tutorialinfo = -->
<xsl:template mode="dita2html.topic.mode" match="&topic_tutorialinfo;">
  <p>
    <xsl:copy-of select="@id"/>
    <xsl:call-template name="html.lang.attrs"/>
    <xsl:apply-templates mode="dita2html.topic.mode"/>
  </p>
</xsl:template>

</xsl:stylesheet>
