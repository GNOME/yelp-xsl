<?xml version='1.0' encoding='UTF-8'?><!-- -*- indent-tabs-mode: nil -*- -->
<!--
xsldoc-check.xsl - Check the data in the xsldoc file
Copyright (C) 2006 Shaun McCance <shaunm@gnome.org>

This program is free software; you can redistribute it and/or modify it
under the terms of the GNU General Public License as published by the
Free Software Foundation; either version 2 of the License, or (at your
option) any later version.

This program is distributed in the hope that it will be useful, but
WITHOUT ANY WARRANTY; without even the implied warranty of MERCHANTABILITY
or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU General Public License
for more details.

You should have received a copy of the GNU General Public License along
with this program; if not, see <http://www.gnu.org/licenses/>.
-->
<!--
This program is free software, but that doesn't mean you should use it.
It's a hackish bit of awk and XSLT to do inline XSLT documentation with
a simple syntax in comments.  I had originally tried to make a public
inline documentation system for XSLT using embedded XML, but it just got
very cumbersome.  XSLT should have been designed from the ground up with
an inline documentation format.

None of the existing inline documentation tools (gtk-doc, doxygen, etc.)
really work well for XSLT, so I rolled my own simple comment-based tool.
This tool is sufficient for producing the documentation I need, but I
just don't have the time or inclination to make a robust system suitable
for public use.

You are, of course, free to use any of this.  If you do proliferate this
hack, it is requested (though not required, that would be non-free) that
you atone for your actions.  A good atonement would be contributing to
free software.
-->

<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
                xmlns:mal="http://projectmallard.org/1.0/"
                xmlns:cache="http://projectmallard.org/cache/1.0/"
                version="1.0">

<xsl:output method="text"/>

<xsl:param name="xsldoc.cache.file"/>
<xsl:param name="xsldoc.cache" select="document($xsldoc.cache.file)/cache:cache"/>
<xsl:key name="xsldoc.cache.key" match="mal:page | mal:section" use="@id"/>

<xsl:template match="/mal:page">
  <xsl:variable name="page" select="."/>
  <xsl:for-each select="//mal:*[@xref]">
    <xsl:variable name="linkid">
      <xsl:if test="starts-with(@xref, '#')">
        <xsl:value-of select="ancestor::mal:page/@id"/>
      </xsl:if>
      <xsl:value-of select="@xref"/>
    </xsl:variable>
    <xsl:for-each select="$xsldoc.cache">
      <xsl:if test="count(key('xsldoc.cache.key', $linkid)) = 0">
        <xsl:message terminate="yes">
          <xsl:text>The page </xsl:text>
          <xsl:value-of select="$page/@id"/>
          <xsl:text> links to an undefined </xsl:text>
          <xsl:choose>
            <xsl:when test="contains($linkid, '#')">
              <xsl:text>section </xsl:text>
            </xsl:when>
            <xsl:otherwise>
              <xsl:text>page </xsl:text>
            </xsl:otherwise>
          </xsl:choose>
          <xsl:value-of select="$linkid"/>
        </xsl:message>
      </xsl:if>
    </xsl:for-each>
  </xsl:for-each>
</xsl:template>

<xsl:template match="section">
  <xsl:variable name="section" select="."/>

  <!-- Check if all called templates exist -->
  <xsl:for-each select="metas/meta[name = 'calls-names']/desc">
    <xsl:variable name="name" select="string(.)"/>
    <xsl:choose>
      <xsl:when test="$section/template[name = $name][1]"/>
      <xsl:otherwise>
        <xsl:variable name="template" select="/xsldoc/section/template[name = $name][1]"/>
        <xsl:choose>
          <xsl:when test="$template and
                          $section/metas/meta[name = 'Requires']/desc[. = string($template/../@id)]"/>
          <xsl:otherwise>
            <xsl:message terminate="yes">
              <xsl:text>The stylesheet </xsl:text>
              <xsl:value-of select="$section/@id"/>
              <xsl:text> calls an undefined template </xsl:text>
              <xsl:value-of select="$name"/>
            </xsl:message>
          </xsl:otherwise>
        </xsl:choose>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:for-each>

  <!-- Check if all called modes exist -->
  <xsl:for-each select="metas/meta[name = 'calls-modes']/desc">
    <xsl:variable name="name" select="string(.)"/>
    <xsl:choose>
      <xsl:when test="$section/mode[name = $name][1]"/>
      <xsl:otherwise>
        <xsl:variable name="mode" select="/xsldoc/section/mode[name = $name][1]"/>
        <xsl:choose>
          <xsl:when test="$mode and
                          $section/metas/meta[name = 'Requires']/desc[. = string($mode/../@id)]"/>
          <xsl:otherwise>
            <xsl:message terminate="yes">
              <xsl:text>The stylesheet </xsl:text>
              <xsl:value-of select="$section/@id"/>
              <xsl:text> calls an undefined mode </xsl:text>
              <xsl:value-of select="$name"/>
            </xsl:message>
          </xsl:otherwise>
        </xsl:choose>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:for-each>

  <!-- Check if all used modes exist -->
  <xsl:for-each select="metas/meta[name = 'uses-modes']/desc">
    <xsl:variable name="name" select="string(.)"/>
    <xsl:choose>
      <xsl:when test="$section/mode[name = $name][1]"/>
      <xsl:otherwise>
        <xsl:variable name="mode" select="/xsldoc/section/mode[name = $name][1]"/>
        <xsl:choose>
          <xsl:when test="$mode and
                          $section/metas/meta[name = 'Requires']/desc[. = string($mode/../@id)]"/>
          <xsl:otherwise>
            <xsl:message terminate="yes">
              <xsl:text>The stylesheet </xsl:text>
              <xsl:value-of select="$section/@id"/>
              <xsl:text> implements an undefined mode </xsl:text>
              <xsl:value-of select="$name"/>
            </xsl:message>
          </xsl:otherwise>
        </xsl:choose>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:for-each>

  <!-- Check if all requires are required -->
  <xsl:for-each select="metas/meta[name = 'Requires']/desc">
    <xsl:variable name="name" select="string(.)"/>
    <xsl:variable name="names" select="$section/metas/meta[name = 'calls-names']/desc"/>
    <xsl:variable name="modes" select="$section/metas/meta[name = 'calls-modes']/desc |
                                       $section/metas/meta[name = 'uses-modes']/desc  "/>
    <xsl:variable name="params" select="$section/metas/meta[name = 'uses-params']/desc"/>
    <xsl:choose>
      <xsl:when test="$name = /xsldoc/section[template[string(name) = $names]]/@id"/>
      <xsl:when test="$name = /xsldoc/section[mode[string(name) = $modes]]/@id"/>
      <xsl:when test="$name = /xsldoc/section[param[string(name) = $params]]/@id"/>
      <xsl:otherwise>
        <xsl:message terminate="yes">
          <xsl:text>The stylesheet </xsl:text>
          <xsl:value-of select="$section/@id"/>
          <xsl:text> does not require the stylesheet </xsl:text>
          <xsl:value-of select="$name"/>
        </xsl:message>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:for-each>

</xsl:template>

</xsl:stylesheet>
