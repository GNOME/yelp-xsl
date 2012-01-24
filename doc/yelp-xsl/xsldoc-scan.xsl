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
                xmlns:str="http://exslt.org/strings"
                xmlns:xsldoc="http://projects.gnome.org/yelp/xsldoc/"
                xmlns="http://projectmallard.org/1.0/"
                extension-element-prefixes="exsl"
                exclude-result-prefixes="mal set xsldoc"
                version="1.0">

<xsl:param name="xsldoc.id"/>
<xsl:param name="xsldoc.xslt_file"/>
<xsl:variable name="xslt_file" select="document($xsldoc.xslt_file)/xsl:stylesheet"/>

<xsl:template name="revision">
  <xsl:param name="info" select="mal:info"/>
  <xsl:choose>
    <xsl:when test="$info/mal:revision">
      <xsl:for-each select="$info/mal:revision">
        <xsl:copy>
          <xsl:if test="not(@status)">
            <xsl:attribute name="status">
              <xsl:text>incomplete</xsl:text>
            </xsl:attribute>
          </xsl:if>
          <xsl:copy-of select="@*"/>
        </xsl:copy>
      </xsl:for-each>
    </xsl:when>
    <xsl:otherwise>
      <revision version="0.0" date="1970-01-01" status="stub"/>
    </xsl:otherwise>
  </xsl:choose>
</xsl:template>

<xsl:template name="calls_templates">
  <xsl:param name="node" select="."/>
  <xsl:param name="page"/>
  <xsl:param name="xslt_node"/>
  <xsl:for-each select="$xslt_node">
    <xsl:variable name="calls_templates" select="set:distinct(.//xsl:call-template[
                                                 not(@name = $xslt_node//xsl:template/@name) and
                                                 not($page/processing-instruction('xslt-private')[string(.) = @name])
                                                 ]/@name)"/>
    <xsl:if test="count($calls_templates) > 0">
      <list style="compact">
        <title>Calls Templates</title>
        <xsl:for-each select="$calls_templates">
          <xsl:variable name="name" select="string(.)"/>
          <xsl:if test="not($page/processing-instruction('xslt-private')[string(.) = $name])">
            <xsl:variable name="id" select="concat('T__', translate($name, '.', '_'))"/>
            <item><p><link xref="{$id}"/></p></item>
          </xsl:if>
        </xsl:for-each>
      </list>
    </xsl:if>
  </xsl:for-each>
</xsl:template>

<xsl:template name="calls_modes">
  <xsl:param name="node" select="."/>
  <xsl:param name="page"/>
  <xsl:param name="xslt_node"/>
  <xsl:variable name="calls_modes">
    <xsl:for-each select="$xslt_node">
      <xsl:for-each select="set:distinct(.//xsl:apply-templates/@mode)">
        <xsl:variable name="mode" select="string(.)"/>
        <xsl:if test="not($page/processing-instruction('xslt-private')[string(.) = $mode])">
          <xsl:if test="not($node//mal:section[@style = 'xslt-mode' and mal:title = $mode])">
            <xsl:variable name="id" select="concat('M__', translate($mode, '.', '_'))"/>
            <link xref="{$id}"/>
          </xsl:if>
        </xsl:if>
      </xsl:for-each>
    </xsl:for-each>
  </xsl:variable>
  <xsl:variable name="calls_modes_nodes" select="exsl:node-set($calls_modes)/*"/>
  <xsl:if test="count($calls_modes_nodes) > 0">
    <list style="compact">
      <title>Calls Modes</title>
      <xsl:for-each select="$calls_modes_nodes">
        <item><p><xsl:copy-of select="."/></p></item>
      </xsl:for-each>
    </list>
  </xsl:if>
</xsl:template>

<xsl:template match="mal:page">
  <xsl:variable name="page" select="."/>
  <page id="{$xsldoc.id}" type="guide" style="xslt-stylesheet">
    <xsl:copy-of select="processing-instruction()"/>
    <info>
      <link type="guide" xref="index__S"/>
      <xsl:if test="string(mal:desc) != ''">
        <xsl:copy-of select="mal:desc"/>
      </xsl:if>
      <xsl:call-template name="revision"/>
      <xsl:copy-of select="mal:info/*[not(self::mal:desc) and not(self::mal:revision)]"/>
      <!-- xslt-includes -->
      <xsl:for-each select="$xslt_file//xsl:include">
        <xsl:variable name="base" select="substring-before(str:split(@href, '/')[last()], '.xsl')"/>
        <xsl:choose>
          <xsl:when test="$page/processing-instruction('xslt-private')[string(.) = $base]"/>
          <xsl:when test="processing-instruction('pass')">
            <xsl:for-each select="document(@href, /)//xsl:include">
              <xsl:variable name="subpage" select="/mal:page"/>
              <xsl:variable name="subbase" select="substring-before(str:split(@href, '/')[last()], '.xsl')"/>
              <xsl:if test="not($subpage/processing-instruction('xslt-private')[string(.) = $subbase])">
                <xsl:variable name="id" select="translate($subbase, '.', '_')"/>
                <link type="topic" xref="{$id}" group="S"/>
              </xsl:if>
            </xsl:for-each>
          </xsl:when>
          <xsl:otherwise>
            <xsl:variable name="id" select="translate($base, '.', '_')"/>
            <link type="topic" xref="{$id}" group="S"/>
          </xsl:otherwise>
        </xsl:choose>
      </xsl:for-each>
      <!-- xslt-defines-template -->
      <xsl:for-each select="$xslt_file/xsl:template/@name">
        <xsl:variable name="name" select="string(.)"/>
        <xsl:if test="not($page/processing-instruction('xslt-private')[string(.) = $name])">
          <xsl:variable name="id" select="concat('T__', translate($name, '.', '_'))"/>
          <link type="xslt-defines-template" xref="{$id}"/>
        </xsl:if>
      </xsl:for-each>
      <!-- xslt-implements-mode -->
      <xsl:for-each select="set:distinct($xslt_file//xsl:template/@mode)">
        <xsl:variable name="mode" select="string(.)"/>
        <xsl:if test="not($page/processing-instruction('xslt-private')[string(.) = $mode])">
          <xsl:variable name="id" select="concat('M__', translate($mode, '.', '_'))"/>
          <link type="xslt-implements-mode" xref="{$id}"/>
        </xsl:if>
      </xsl:for-each>
      <!-- xslt-defines-param -->
      <xsl:for-each select="$xslt_file/xsl:param/@name">
        <xsl:variable name="name" select="string(.)"/>
        <xsl:if test="not($page/processing-instruction('xslt-private')[string(.) = $name])">
          <xsl:variable name="id" select="concat('P__', translate($name, '.', '_'))"/>
          <link type="xslt-defines-param" xref="{$id}"/>
        </xsl:if>
      </xsl:for-each>
      <!-- xslt-uses-param -->
      <xsl:variable name="uses-params">
        <!-- FIXME
        -->
        <xsl:for-each select="$xslt_file//xsl:value-of/@select |
                              $xslt_file//xsl:if/@test         | 
                              $xslt_file//xsl:when/@test       ">
          <xsl:variable name="xpath_node" select="."/>
          <xsl:variable name="params">
            <xsl:call-template name="extract-params">
              <xsl:with-param name="string" select="string(.)"/>
            </xsl:call-template>
          </xsl:variable>
          <xsl:for-each select="str:split($params)">
            <xsl:variable name="paramname" select="string(.)"/>
            <xsl:if test="
              not($xpath_node/../ancestor-or-self::*/preceding-sibling::xsl:param[@name = $paramname]
               or $xpath_node/../ancestor-or-self::*/preceding-sibling::xsl:variable[@name = $paramname])">
              <param>
                <xsl:value-of select="$paramname"/>
              </param>
            </xsl:if>
          </xsl:for-each>
        </xsl:for-each>
      </xsl:variable>
      <xsl:for-each select="set:distinct(exsl:node-set($uses-params)/mal:param)">
        <xsl:variable name="id" select="concat('P__', translate(string(.), '.', '_'))"/>
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
    <links type="topic" groups="S" style="linklist">
      <title>Stylesheets</title>
    </links>
    <links type="topic" groups="P" style="linklist">
      <title>Parameters</title>
    </links>
    <links type="topic" groups="M" style="linklist">
      <title>Modes</title>
    </links>
    <links type="topic" groups="T" style="linklist">
      <title>Templates</title>
    </links>
    <xsl:variable name="requires" select="$page/mal:info/mal:link[@type = 'xslt-requires']"/>
    <xsl:if test="count($requires) > 0">
      <list style="compact">
        <title>Requires Stylesheets</title>
        <xsl:for-each select="$requires">
          <xsl:sort select="@xref"/>
          <item><p><link xref="{@xref}"/></p></item>
        </xsl:for-each>
      </list>
    </xsl:if>
    <xsl:call-template name="calls_templates">
      <xsl:with-param name="page" select="$page"/>
      <xsl:with-param name="xslt_node" select="$xslt_file"/>
    </xsl:call-template>
    <xsl:call-template name="calls_modes">
      <xsl:with-param name="page" select="$page"/>
      <xsl:with-param name="xslt_node" select="$xslt_file"/>
    </xsl:call-template>
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
        <link type="guide" xref="{$xsldoc.id}" group="{$type}"/>
        <link type="guide" xref="index__{$type}"/>
        <xsl:if test="count(mal:info/xsldoc:stub) > 0">
          <link type="guide" xref="stubs"/>
        </xsl:if>
        <xsl:call-template name="revision"/>
        <xsl:copy-of select="mal:info/*[not(self::mal:revision)]"/>
      </info>
      <xsl:copy-of select="mal:title"/>
      <xsl:if test="string(mal:info/mal:desc) != ''">
        <p>
          <xsl:copy-of select="mal:info/mal:desc/node()"/>
        </p>
      </xsl:if>
      <xsl:if test="$type = 'T'">
        <xsl:if test="count(mal:info/xsldoc:stub) > 0">
          <note>
            <p>This template is a stub. Customizations may override it for
            additional functionality.</p>
          </note>
        </xsl:if>
      </xsl:if>
      <xsl:apply-templates/>
      <xsl:if test="$type = 'T'">
        <xsl:variable name="title" select="mal:title"/>
        <xsl:variable name="xslt_node" select="$xslt_file//xsl:template[@name = $title]"/>
        <xsl:call-template name="calls_templates">
          <xsl:with-param name="node" select="."/>
          <xsl:with-param name="page" select="ancestor::mal:page"/>
          <xsl:with-param name="xslt_node" select="$xslt_node"/>
        </xsl:call-template>
        <xsl:call-template name="calls_modes">
          <xsl:with-param name="node" select="."/>
          <xsl:with-param name="page" select="ancestor::mal:page"/>
          <xsl:with-param name="xslt_node" select="$xslt_node"/>
        </xsl:call-template>
      </xsl:if>
    </page>
  </exsl:document>
</xsl:template>

<xsl:template match="processing-instruction()"/>

<xsl:template match="*">
  <xsl:copy-of select="."/>
</xsl:template>

<xsl:template name="extract-params">
  <xsl:param name="string" select="''"/>
  <xsl:param name="position" select="1"/>
  <xsl:param name="in_param" select="false()"/>
  <xsl:if test="$position &lt;= string-length($string)">
    <xsl:variable name="char" select="substring($string, $position, 1)"/>
    <xsl:choose>
      <xsl:when test="$in_param">
        <xsl:choose>
          <xsl:when test="contains(
                          'abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ01234567890.-_',
                          $char)">
            <xsl:value-of select="$char"/>
            <xsl:call-template name="extract-params">
              <xsl:with-param name="string" select="$string"/>
              <xsl:with-param name="position" select="$position + 1"/>
              <xsl:with-param name="in_param" select="true()"/>
            </xsl:call-template>
          </xsl:when>
          <xsl:otherwise>
            <xsl:text> </xsl:text>
            <xsl:call-template name="extract-params">
              <xsl:with-param name="string" select="$string"/>
              <xsl:with-param name="position" select="$position + 1"/>
              <xsl:with-param name="in_param" select="false()"/>
            </xsl:call-template>
          </xsl:otherwise>
        </xsl:choose>
      </xsl:when>
      <xsl:when test="$char = '$'">
        <xsl:call-template name="extract-params">
          <xsl:with-param name="string" select="$string"/>
          <xsl:with-param name="position" select="$position + 1"/>
          <xsl:with-param name="in_param" select="true()"/>
        </xsl:call-template>
      </xsl:when>
      <xsl:otherwise>
        <xsl:call-template name="extract-params">
          <xsl:with-param name="string" select="$string"/>
          <xsl:with-param name="position" select="$position + 1"/>
          <xsl:with-param name="in_param" select="false()"/>
        </xsl:call-template>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:if>
</xsl:template>

</xsl:stylesheet>
