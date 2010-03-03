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
                xmlns="http://www.w3.org/1999/xhtml"
                exclude-result-prefixes="mal"
                version="1.0">

<!--!!==========================================================================
Mallard to HTML - Block Elements

REMARK: Describe this module
-->


<!--**==========================================================================
mal2html.pre

FIXME
-->
<xsl:template name="mal2html.pre">
  <xsl:param name="node" select="."/>
  <xsl:variable name="first" select="$node/node()[1]/self::text()"/>
  <xsl:variable name="last" select="$node/node()[last()]/self::text()"/>
  <div>
    <xsl:attribute name="class">
      <xsl:value-of select="local-name($node)"/>
    </xsl:attribute>
    <pre class="contents">
      <xsl:if test="$first">
        <xsl:call-template name="utils.strip_newlines">
          <xsl:with-param name="string" select="$first"/>
          <xsl:with-param name="leading" select="true()"/>
          <xsl:with-param name="trailing" select="count(node()) = 1"/>
        </xsl:call-template>
      </xsl:if>
      <xsl:apply-templates mode="mal2html.inline.mode"
                           select="node()[not(self::text() and (position() = 1 or position() = last()))]"/>
      <xsl:if test="$last and (count(node()) != 1)">
        <xsl:call-template name="utils.strip_newlines">
          <xsl:with-param name="string" select="$last"/>
          <xsl:with-param name="leading" select="false()"/>
          <xsl:with-param name="trailing" select="true()"/>
        </xsl:call-template>
      </xsl:if>
    </pre>
  </div>
</xsl:template>


<!-- == Matched Templates == -->

<!--%%==========================================================================
mal2html.block.mode
FIXME

FIXME
-->

<!-- = desc = -->
<xsl:template mode="mal2html.block.mode" match="mal:desc">
  <div class="desc desc-{local-name(..)}">
    <xsl:apply-templates mode="mal2html.inline.mode"/>
  </div>
</xsl:template>

<!-- = code = -->
<xsl:template mode="mal2html.block.mode" match="mal:code">
  <xsl:call-template name="mal2html.pre"/>
</xsl:template>

<!-- = comment = -->
<xsl:template mode="mal2html.block.mode" match="mal:comment">
  <xsl:if test="$mal2html.editor_mode
                or processing-instruction('mal2html.show_comment')">
    <div class="comment">
      <div class="inner">
        <xsl:apply-templates mode="mal2html.block.mode" select="mal:title"/>
        <xsl:apply-templates mode="mal2html.block.mode" select="mal:cite"/>
        <div class="contents">
          <xsl:for-each select="*[not(self::mal:title or self::mal:cite)]">
            <xsl:apply-templates mode="mal2html.block.mode" select="."/>
          </xsl:for-each>
        </div>
      </div>
    </div>
  </xsl:if>
</xsl:template>

<!-- = comment/cite = -->
<xsl:template mode="mal2html.block.mode" match="mal:comment/mal:cite">
  <div class="cite cite-comment">
    <!-- FIXME: i18n -->
    <xsl:text>from </xsl:text>
    <xsl:choose>
      <xsl:when test="@href">
        <a href="{@href}">
          <xsl:apply-templates mode="mal2html.inline.mode"/>
        </a>
      </xsl:when>
      <xsl:otherwise>
        <xsl:apply-templates mode="mal2html.inline.mode"/>
      </xsl:otherwise>
    </xsl:choose>
    <xsl:if test="@date">
      <xsl:text> on </xsl:text>
      <xsl:value-of select="@date"/>
    </xsl:if>
  </div>
</xsl:template>

<!-- = example = -->
<xsl:template mode="mal2html.block.mode" match="mal:example">
  <div class="example">
    <xsl:apply-templates mode="mal2html.block.mode"/>
  </div>
</xsl:template>

<!-- = figure = -->
<xsl:template mode="mal2html.block.mode" match="mal:figure">
  <div class="figure">
    <div class="inner">
      <xsl:apply-templates mode="mal2html.block.mode" select="mal:title"/>
      <div class="contents">
        <xsl:for-each select="*[not(self::mal:title or self::mal:desc)]">
          <xsl:apply-templates mode="mal2html.block.mode" select="."/>
        </xsl:for-each>
      </div>
      <xsl:apply-templates mode="mal2html.block.mode" select="mal:desc"/>
    </div>
  </div>
</xsl:template>

<!-- = listing = -->
<xsl:template mode="mal2html.block.mode" match="mal:listing">
  <div class="listing">
    <div class="inner">
      <xsl:apply-templates mode="mal2html.block.mode" select="mal:title"/>
      <xsl:apply-templates mode="mal2html.block.mode" select="mal:desc"/>
      <div class="contents">
        <xsl:for-each select="*[not(self::mal:title or self::mal:desc)]">
          <xsl:apply-templates mode="mal2html.block.mode" select="."/>
        </xsl:for-each>
      </div>
    </div>
  </div>
</xsl:template>

<!-- = note = -->
<xsl:template mode="mal2html.block.mode" match="mal:note">
  <xsl:variable name="notestyle">
    <xsl:choose>
      <xsl:when test="contains(concat(' ', @style, ' '), ' advanced ')">
        <xsl:text>advanced</xsl:text>
      </xsl:when>
      <xsl:when test="contains(concat(' ', @style, ' '), ' bug ')">
        <xsl:text>bug</xsl:text>
      </xsl:when>
      <xsl:when test="contains(concat(' ', @style, ' '), ' important ')">
        <xsl:text>important</xsl:text>
      </xsl:when>
      <xsl:when test="contains(concat(' ', @style, ' '), ' tip ')">
        <xsl:text>tip</xsl:text>
      </xsl:when>
      <xsl:when test="contains(concat(' ', @style, ' '), ' warning ')">
        <xsl:text>warning</xsl:text>
      </xsl:when>
    </xsl:choose>
  </xsl:variable>
  <div>
    <xsl:attribute name="class">
      <xsl:text>note</xsl:text>
      <xsl:if test="normalize-space($notestyle) != ''">
        <xsl:value-of select="concat(' note-', $notestyle)"/>
      </xsl:if>
    </xsl:attribute>
    <div class="inner">
      <xsl:apply-templates mode="mal2html.block.mode" select="mal:title"/>
      <div class="contents">
        <xsl:apply-templates mode="mal2html.block.mode" select="*[not(self::mal:title)]"/>
      </div>
    </div>
  </div>
</xsl:template>

<!-- = info = -->
<xsl:template mode="mal2html.block.mode" match="mal:info"/>

<!-- = p = -->
<xsl:template mode="mal2html.block.mode" match="mal:p">
  <p class="p">
    <xsl:apply-templates mode="mal2html.inline.mode"/>
  </p>
</xsl:template>

<!-- = quote = -->
<xsl:template mode="mal2html.block.mode" match="mal:quote">
  <div class="quote">
    <div class="inner">
      <xsl:apply-templates mode="mal2html.block.mode" select="mal:title"/>
      <blockquote class="contents">
        <xsl:for-each select="*[not(self::mal:title or self::mal:cite)]">
          <xsl:apply-templates mode="mal2html.block.mode" select="."/>
        </xsl:for-each>
      </blockquote>
      <xsl:apply-templates mode="mal2html.block.mode" select="mal:cite"/>
    </div>
  </div>
</xsl:template>

<!-- = quote/cite = -->
<xsl:template mode="mal2html.block.mode" match="mal:quote/mal:cite">
  <div class="cite cite-quote">
    <xsl:choose>
      <xsl:when test="@href">
        <a href="{@href}">
          <xsl:apply-templates mode="mal2html.inline.mode"/>
        </a>
      </xsl:when>
      <xsl:otherwise>
        <xsl:apply-templates mode="mal2html.inline.mode"/>
      </xsl:otherwise>
    </xsl:choose>
    <!-- FIXME: i18n -->
    <xsl:if test="@date">
      <xsl:text> (</xsl:text>
      <xsl:value-of select="@date"/>
      <xsl:text>)</xsl:text>
    </xsl:if>
  </div>
</xsl:template>

<!-- = screen = -->
<xsl:template mode="mal2html.block.mode" match="mal:screen">
  <xsl:call-template name="mal2html.pre"/>
</xsl:template>

<!-- = synopsis = -->
<xsl:template mode="mal2html.block.mode" match="mal:synopsis">
  <div class="synopsis">
    <div class="inner">
      <xsl:apply-templates mode="mal2html.block.mode" select="mal:title"/>
      <xsl:apply-templates mode="mal2html.block.mode" select="mal:desc"/>
      <div class="contents">
        <xsl:for-each select="*[not(self::mal:title or self::mal:desc)]">
          <xsl:apply-templates mode="mal2html.block.mode" select="."/>
        </xsl:for-each>
      </div>
    </div>
  </div>
</xsl:template>

<!-- = title = -->
<xsl:template mode="mal2html.block.mode" match="mal:title">
  <div class="title title-{local-name(..)}">
    <xsl:apply-templates mode="mal2html.inline.mode"/>
  </div>
</xsl:template>

<xsl:template mode="mal2html.block.mode" match="text()"/>

<xsl:template mode="mal2html.block.mode" match="*">
  <xsl:param name="restricted" select="false()"/>
  <xsl:if test="not($restricted)">
    <xsl:message>
      <xsl:text>Unmatched block element: </xsl:text>
      <xsl:value-of select="local-name(.)"/>
    </xsl:message>
    <xsl:apply-templates mode="mal2html.block.mode">
      <xsl:with-param name="restricted" select="true()"/>
    </xsl:apply-templates>
  </xsl:if>
</xsl:template>

</xsl:stylesheet>
