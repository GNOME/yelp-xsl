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
DITA to HTML - Lists

REMARK: Describe this module
-->


<!-- == Matched Templates == -->

<!-- = li = -->
<xsl:template mode="dita2html.topic.mode" match="&topic_li;">
  <xsl:variable name="conref" select="yelp:dita.ref.conref(.)"/>
  <li class="list">
    <xsl:copy-of select="@id"/>
    <xsl:call-template name="html.lang.attrs"/>
    <xsl:apply-templates mode="dita2html.topic.mode" select="$conref/node()"/>
  </li>
</xsl:template>

<!-- = ol = -->
<xsl:template mode="dita2html.topic.mode" match="&topic_ol;">
  <xsl:variable name="conref" select="yelp:dita.ref.conref(.)"/>
  <xsl:variable name="compact">
    <xsl:call-template name="dita.ref.conref.attr">
      <xsl:with-param name="attr" select="'compact'"/>
      <xsl:with-param name="node" select="."/>
      <xsl:with-param name="conref" select="$conref"/>
    </xsl:call-template>
  </xsl:variable>
  <div class="list">
    <xsl:copy-of select="@id"/>
    <xsl:call-template name="html.lang.attrs"/>
    <div class="inner">
      <ol>
        <xsl:attribute name="class">
          <xsl:text>list</xsl:text>
          <xsl:if test="$compact = 'yes'">
            <xsl:text> compact</xsl:text>
          </xsl:if>
        </xsl:attribute>
        <xsl:apply-templates mode="dita2html.topic.mode" select="$conref/node()"/>
      </ol>
    </div>
  </div>
</xsl:template>

<!-- = sl = -->
<xsl:template mode="dita2html.topic.mode" match="&topic_sl;">
  <xsl:variable name="conref" select="yelp:dita.ref.conref(.)"/>
  <xsl:variable name="compact">
    <xsl:call-template name="dita.ref.conref.attr">
      <xsl:with-param name="attr" select="'compact'"/>
      <xsl:with-param name="node" select="."/>
      <xsl:with-param name="conref" select="$conref"/>
    </xsl:call-template>
  </xsl:variable>
  <div class="list">
    <xsl:copy-of select="@id"/>
    <xsl:call-template name="html.lang.attrs"/>
    <div class="inner">
      <ul>
        <xsl:attribute name="class">
          <xsl:text>list list-sli</xsl:text>
          <!-- Non-compact sl is compact other lists. Compact sl is compacter. -->
          <xsl:choose>
            <xsl:when test="$compact = 'yes'">
              <xsl:text> compact-sli</xsl:text>
            </xsl:when>
            <xsl:otherwise>
              <xsl:text> compact</xsl:text>
            </xsl:otherwise>
          </xsl:choose>
        </xsl:attribute>
        <xsl:apply-templates mode="dita2html.topic.mode" select="$conref/node()"/>
      </ul>
    </div>
  </div>
</xsl:template>

<!-- = sli = -->
<xsl:template mode="dita2html.topic.mode" match="&topic_sli;">
  <xsl:variable name="conref" select="yelp:dita.ref.conref(.)"/>
  <li class="list">
    <xsl:copy-of select="@id"/>
    <xsl:call-template name="html.lang.attrs"/>
    <xsl:apply-templates mode="dita2html.topic.mode" select="$conref/node()"/>
  </li>
</xsl:template>

<!-- = step = -->
<xsl:template mode="dita2html.topic.mode" match="&topic_step;">
  <xsl:variable name="conref" select="yelp:dita.ref.conref(.)"/>
  <xsl:variable name="pre" select="preceding-sibling::&topic_step;"/>
  <li class="steps" value="{count($pre) + 1}">
    <xsl:copy-of select="@id"/>
    <xsl:call-template name="html.lang.attrs"/>
    <xsl:apply-templates mode="dita2html.topic.mode" select="$conref/node()"/>
  </li>
</xsl:template>

<!-- = steps = -->
<xsl:template mode="dita2html.topic.mode" match="&topic_steps;">
  <xsl:variable name="conref" select="yelp:dita.ref.conref(.)"/>
  <div class="steps">
    <xsl:copy-of select="@id"/>
    <xsl:call-template name="html.lang.attrs"/>
    <div class="inner">
      <div class="region">
        <ol class="steps">
          <xsl:apply-templates mode="dita2html.topic.mode" select="$conref/node()"/>
        </ol>
      </div>
    </div>
  </div>
</xsl:template>

<!-- = steps-unordered = -->
<xsl:template mode="dita2html.topic.mode" match="&topic_steps-unordered;">
  <xsl:variable name="conref" select="yelp:dita.ref.conref(.)"/>
  <div class="steps">
    <xsl:copy-of select="@id"/>
    <xsl:call-template name="html.lang.attrs"/>
    <div class="inner">
      <div class="region">
        <ul class="steps">
          <xsl:apply-templates mode="dita2html.topic.mode" select="$conref/node()"/>
        </ul>
      </div>
    </div>
  </div>
</xsl:template>

<!-- = stepsection = -->
<xsl:template mode="dita2html.topic.mode" match="&topic_stepsection;">
  <xsl:variable name="conref" select="yelp:dita.ref.conref(.)"/>
  <li class="stepsection">
    <xsl:copy-of select="@id"/>
    <xsl:call-template name="html.lang.attrs"/>
    <xsl:apply-templates mode="dita2html.topic.mode" select="$conref/node()"/>
  </li>
</xsl:template>

<!-- = substep = -->
<xsl:template mode="dita2html.topic.mode" match="&topic_substep;">
  <xsl:variable name="conref" select="yelp:dita.ref.conref(.)"/>
  <li class="steps substeps">
    <xsl:copy-of select="@id"/>
    <xsl:call-template name="html.lang.attrs"/>
    <xsl:apply-templates mode="dita2html.topic.mode" select="$conref/node()"/>
  </li>
</xsl:template>

<!-- = substeps = -->
<xsl:template mode="dita2html.topic.mode" match="&topic_substeps;">
  <xsl:variable name="conref" select="yelp:dita.ref.conref(.)"/>
  <div class="substeps">
    <xsl:copy-of select="@id"/>
    <xsl:call-template name="html.lang.attrs"/>
    <ol class="substeps">
      <xsl:apply-templates mode="dita2html.topic.mode" select="$conref/node()"/>
    </ol>
  </div>
</xsl:template>

<!-- = ul = -->
<xsl:template mode="dita2html.topic.mode" match="&topic_ul;">
  <xsl:variable name="conref" select="yelp:dita.ref.conref(.)"/>
  <xsl:variable name="compact">
    <xsl:call-template name="dita.ref.conref.attr">
      <xsl:with-param name="attr" select="'compact'"/>
      <xsl:with-param name="node" select="."/>
      <xsl:with-param name="conref" select="$conref"/>
    </xsl:call-template>
  </xsl:variable>
  <div class="list">
    <xsl:copy-of select="@id"/>
    <xsl:call-template name="html.lang.attrs"/>
    <div class="inner">
      <ul>
        <xsl:attribute name="class">
          <xsl:text>list</xsl:text>
          <xsl:if test="$compact = 'yes'">
            <xsl:text> compact</xsl:text>
          </xsl:if>
        </xsl:attribute>
        <xsl:apply-templates mode="dita2html.topic.mode" select="$conref/node()"/>
      </ul>
    </div>
  </div>
</xsl:template>

</xsl:stylesheet>
