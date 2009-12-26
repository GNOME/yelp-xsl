<?xml version='1.0' encoding='UTF-8'?><!-- -*- indent-tabs-mode: nil -*- -->
<!--
xsldoc-scan.xsl - Put more information in the output from xsldoc-scan.awk
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
with this program; if not, write to the Free Software Foundation, Inc.,
59 Temple Place - Suite 330, Boston, MA 02111-1307, USA.
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
                xmlns:exsl="http://exslt.org/common"
                xmlns:set="http://exslt.org/sets"
                xmlns="http://projectmallard.org/1.0/"
                extension-element-prefixes="exsl"
                exclude-result-prefixes="mal set"
                version="1.0">

<xsl:param name="xsldoc.id"/>
<xsl:param name="xsldoc.xslt_file"/>
<xsl:variable name="xslt_file" select="document($xsldoc.xslt_file)/xsl:stylesheet"/>

<xsl:template match="mal:page">
  <page id="{$xsldoc.id}" type="guide" style="xslt-stylesheet">
    <xsl:copy-of select="processing-instruction()"/>
    <info>
      <link type="guide" xref="index__S"/>
      <xsl:if test="string(mal:desc) != ''">
        <xsl:copy-of select="mal:desc"/>
      </xsl:if>
      <xsl:copy-of select="mal:info/*[not(self::mal:desc)]"/>
      <xsl:for-each select="set:distinct($xslt_file//xsl:call-template/@name)">
        <xsl:variable name="id" select="concat('T__', translate(., '.', '_'))"/>
        <link type="xslt-calls-template" xref="{$id}"/>
      </xsl:for-each>
      <xsl:for-each select="set:distinct($xslt_file//xsl:apply-templates/@mode)">
        <xsl:variable name="id" select="concat('M__', translate(., '.', '_'))"/>
        <link type="xslt-calls-mode" xref="{$id}"/>
      </xsl:for-each>
      <xsl:for-each select="set:distinct($xslt_file//xsl:template/@mode)">
        <xsl:variable name="id" select="concat('M__', translate(., '.', '_'))"/>
        <link type="xslt-uses-mode" xref="{$id}"/>
      </xsl:for-each>
      <xsl:for-each select="set:distinct($xslt_file//xsl:value-of
                            [starts-with(@select, '$') and contains(@select, '.')]/@select)">
        <xsl:variable name="id"
                      select="concat('M__', translate(substring-after(., '$'), '.', '_'))"/>
        <link type="xslt-uses-param" xref="{$id}"/>
      </xsl:for-each>
    </info>
    <xsl:copy-of select="mal:title"/>
    <xsl:if test="string(mal:info/mal:desc) != ''">
      <p>
        <xsl:copy-of select="mal:info/mal:desc/node()"/>
      </p>
    </xsl:if>
    <xsl:apply-templates/>
    <xsl:if test="mal:section[@style = 'xslt-param']">
      <section id="P">
        <title>Templates</title>
      </section>
    </xsl:if>
    <xsl:if test="mal:section[@style = 'xslt-template']">
      <section id="T">
        <title>Templates</title>
      </section>
    </xsl:if>
    <xsl:if test="mal:section[@style = 'xslt-mode']">
      <section id="M">
        <title>Templates</title>
      </section>
    </xsl:if>
  </page>
</xsl:template>

<xsl:template match="mal:info"/>

<xsl:template match="mal:title"/>

<xsl:template match="mal:section">
  <xsl:variable name="type">
    <xsl:choose>
      <xsl:when test="@style = 'xslt-template'">
        <xsl:text>T</xsl:text>
      </xsl:when>
      <xsl:when test="@style = 'xslt-mode'">
        <xsl:text>M</xsl:text>
      </xsl:when>
      <xsl:when test="@style = 'xslt-param'">
        <xsl:text>P</xsl:text>
      </xsl:when>
    </xsl:choose>
  </xsl:variable>
  <xsl:variable name="id">
    <xsl:value-of select="concat($type, '__', translate(mal:title, '.', '_'))"/>
  </xsl:variable>
  <exsl:document href="{$id}.page">
    <page id="{$id}" type="topic" style="{@style}">
      <info>
        <link type="guide" xref="{$xsldoc.id}#{$type}"/>
        <link type="guide" xref="index__{$type}"/>
        <xsl:copy-of select="mal:info/*"/>
      </info>
      <xsl:copy-of select="mal:title"/>
      <xsl:if test="string(mal:info/mal:desc) != ''">
        <p>
          <xsl:copy-of select="mal:info/mal:desc/node()"/>
        </p>
      </xsl:if>
      <xsl:apply-templates/>
    </page>
  </exsl:document>
</xsl:template>

<xsl:template match="processing-instruction()"/>

<xsl:template match="*">
  <xsl:copy-of select="."/>
</xsl:template>

</xsl:stylesheet>
