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
    <xsl:variable name="calls_templates">
      <xsl:for-each select="set:distinct(.//xsl:call-template[
                            not(@name = $xslt_node//xsl:template/@name) and
                            not($page/processing-instruction('xslt-private')[string(.) = @name])
                            ])">
        <xsl:variable name="name" select="string(@name)"/>
        <xsl:if test="not($page/processing-instruction('xslt-private')[string(.) = $name])">
          <link xref="{$name}"/>
        </xsl:if>
      </xsl:for-each>
    </xsl:variable>
    <xsl:variable name="calls_templates_nodes" select="exsl:node-set($calls_templates)/*"/>
    <xsl:if test="count($calls_templates_nodes) > 0">
      <list style="compact">
        <title>Calls Templates</title>
        <xsl:for-each select="$calls_templates_nodes">
          <xsl:sort select="."/>
          <item><p><xsl:copy-of select="."/></p></item>
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
            <link xref="{$mode}"/>
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
        <xsl:sort select="@xref"/>
        <item><p><xsl:copy-of select="."/></p></item>
      </xsl:for-each>
    </list>
  </xsl:if>
</xsl:template>

<xsl:template name="calls_keys">
  <xsl:param name="node" select="."/>
  <xsl:param name="page"/>
  <xsl:param name="xslt_node"/>
  <xsl:variable name="calls_keys">
    <xsl:for-each select="$xslt_node//xsl:variable/@select   |
                          $xslt_node//xsl:param/@select      |
                          $xslt_node//xsl:with-param/@select |
                          $xslt_node//xsl:for-each/@select   |
                          $xslt_node//xsl:sort/@select       |
                          $xslt_node//xsl:value-of/@select   |
                          $xslt_node//xsl:if/@test           | 
                          $xslt_node//xsl:when/@test         ">
      <xsl:variable name="xpath_node" select="."/>
      <xsl:if test="contains($xpath_node, 'key(')">
        <!-- libxslt doesn't str:split when the string starts with the split arg -->
        <xsl:for-each select="str:split(concat(' ', $xpath_node), 'key(')[position() > 1]">
          <xsl:for-each select="str:tokenize(., concat('&quot;', &quot;&apos;&quot;))[1]">
            <key><xsl:value-of select="."/></key>
          </xsl:for-each>
        </xsl:for-each>
      </xsl:if>
    </xsl:for-each>
  </xsl:variable>
  <xsl:variable name="calls_keys_nodes" select="exsl:node-set($calls_keys)/*"/>
  <xsl:if test="count($calls_keys_nodes) > 0">
    <list style="compact">
      <title>Calls Keys</title>
      <xsl:for-each select="set:distinct($calls_keys_nodes)">
        <xsl:sort select="."/>
        <item><p><link xref="{.}"/></p></item>
      </xsl:for-each>
    </list>
  </xsl:if>
</xsl:template>

<xsl:template name="calls_params">
  <xsl:param name="node" select="."/>
  <xsl:param name="page"/>
  <xsl:param name="xslt_node"/>
  <xsl:variable name="calls_params">
    <xsl:for-each select="$xslt_node//xsl:variable/@select   |
                          $xslt_node//xsl:param/@select      |
                          $xslt_node//xsl:with-param/@select |
                          $xslt_node//xsl:for-each/@select   |
                          $xslt_node//xsl:sort/@select       |
                          $xslt_node//xsl:value-of/@select   |
                          $xslt_node//xsl:if/@test           | 
                          $xslt_node//xsl:when/@test         ">
      <xsl:variable name="xpath_node" select="."/>
      <xsl:if test="contains($xpath_node, '$')">
        <!-- libxslt doesn't str:split when the string starts with the split arg -->
        <xsl:for-each select="str:split(concat(' ', $xpath_node), '$')[position() > 1]">
          <xsl:variable name="paramname">
            <xsl:call-template name="read_chars">
              <xsl:with-param name="string" select="."/>
            </xsl:call-template>
          </xsl:variable>
          <xsl:if test="not($xpath_node/../ancestor-or-self::*/preceding-sibling::xsl:param
                              [not(parent::xsl:stylesheet)][@name = $paramname]
                         or $xpath_node/../ancestor-or-self::*/preceding-sibling::xsl:variable
                              [@name = $paramname]
                         or $xpath_node/ancestor::xsl:stylesheet/xsl:variable
                              [@name = $paramname]
                        )">
            <param><xsl:value-of select="$paramname"/></param>
          </xsl:if>
        </xsl:for-each>
      </xsl:if>
    </xsl:for-each>
  </xsl:variable>
  <xsl:variable name="calls_params_nodes" select="exsl:node-set($calls_params)/*"/>
  <xsl:if test="count($calls_params_nodes) > 0">
    <list style="compact">
      <title>Calls Parameters</title>
      <xsl:for-each select="set:distinct($calls_params_nodes)">
        <xsl:sort select="."/>
        <item><p><link xref="{concat('P.', .)}"/></p></item>
      </xsl:for-each>
    </list>
  </xsl:if>
</xsl:template>

<xsl:template name="read_chars">
  <xsl:param name="string" select="''"/>
  <xsl:if test="$string != ''">
    <xsl:variable name="char" select="substring($string, 1, 1)"/>
    <xsl:if test="contains('abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ01234567890.-_', $char)">
      <xsl:value-of select="$char"/>
      <xsl:call-template name="read_chars">
        <xsl:with-param name="string" select="substring($string, 2)"/>
      </xsl:call-template>
    </xsl:if>
  </xsl:if>
</xsl:template>

<xsl:template match="mal:page">
  <xsl:variable name="page" select="."/>
  <page id="{$xsldoc.id}" type="guide" style="xslt-stylesheet">
    <xsl:copy-of select="processing-instruction()"/>
    <xsl:variable name="prefix" select="str:tokenize($xsldoc.id, '.-_')[1]"/>
    <info>
      <link type="guide" xref="stylesheets" group="{$prefix}"/>
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
              <xsl:variable name="subbase" select="substring-before(str:split(@href, '/')[last()], '.xsl')"/>
              <xsl:if test="not(/xsl:stylesheet/comment()[normalize-space(.) = concat('#! ', $subbase)])">
                <link type="topic" xref="{$subbase}" group="stylesheets"/>
              </xsl:if>
            </xsl:for-each>
          </xsl:when>
          <xsl:otherwise>
            <link type="topic" xref="{$base}" group="stylesheets"/>
          </xsl:otherwise>
        </xsl:choose>
      </xsl:for-each>
      <!-- xslt-defines-template -->
      <xsl:for-each select="$xslt_file/xsl:template/@name">
        <xsl:variable name="name" select="string(.)"/>
        <xsl:if test="not($page/processing-instruction('xslt-private')[string(.) = $name])">
          <link type="xslt-defines-template" xref="{$name}"/>
        </xsl:if>
      </xsl:for-each>
      <!-- xslt-implements-mode -->
      <xsl:for-each select="set:distinct($xslt_file//xsl:template/@mode)">
        <xsl:variable name="mode" select="string(.)"/>
        <xsl:if test="not($page/processing-instruction('xslt-private')[string(.) = $mode])">
          <link type="xslt-implements-mode" xref="{$mode}"/>
        </xsl:if>
      </xsl:for-each>
      <!-- xslt-defines-param -->
      <xsl:for-each select="$xslt_file/xsl:param/@name">
        <xsl:variable name="name" select="string(.)"/>
        <xsl:if test="not($page/processing-instruction('xslt-private')[string(.) = $name])">
          <link type="xslt-defines-param" xref="{concat('P.', $name)}"/>
        </xsl:if>
      </xsl:for-each>
    </info>
    <xsl:copy-of select="mal:title"/>
    <xsl:if test="string(mal:info/mal:desc) != ''">
      <p>
        <xsl:copy-of select="mal:info/mal:desc/node()"/>
      </p>
    </xsl:if>
    <xsl:apply-templates/>
    <links type="topic" groups="stylesheets" style="linklist">
      <title>Stylesheets</title>
    </links>
    <links type="topic" groups="parameters" style="linklist">
      <title>Parameters</title>
    </links>
    <links type="topic" groups="modes" style="linklist">
      <title>Modes</title>
    </links>
    <links type="topic" groups="templates" style="linklist">
      <title>Templates</title>
    </links>
    <links type="topic" groups="keys" style="linklist">
      <title>Keys</title>
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
    <xsl:call-template name="calls_keys">
      <xsl:with-param name="page" select="$page"/>
      <xsl:with-param name="xslt_node" select="$xslt_file"/>
    </xsl:call-template>
    <xsl:call-template name="calls_params">
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
        <xsl:text>templates</xsl:text>
      </xsl:when>
      <xsl:when test="@style = 'xslt-key'">
        <xsl:text>keys</xsl:text>
      </xsl:when>
      <xsl:when test="@style = 'xslt-mode'">
        <xsl:text>modes</xsl:text>
      </xsl:when>
      <xsl:when test="@style = 'xslt-param'">
        <xsl:text>parameters</xsl:text>
      </xsl:when>
    </xsl:choose>
  </xsl:variable>
  <xsl:variable name="id">
    <xsl:if test="$type = 'parameters'">
      <xsl:text>P.</xsl:text>
    </xsl:if>
    <xsl:value-of select="mal:title"/>
  </xsl:variable>
  <exsl:document href="{$id}.page">
    <page id="{$id}" type="topic" style="{@style}">
      <xsl:variable name="prefix" select="str:tokenize(mal:title, '.-_')[1]"/>
      <info>
        <link type="guide" xref="{$xsldoc.id}" group="{$type}"/>
        <link type="guide" xref="{$type}" group="{$prefix}"/>
        <xsl:if test="count(mal:info/xsldoc:stub) > 0">
          <link type="guide" xref="stubs" group="{$prefix}"/>
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
      <xsl:if test="$type = 'templates'">
        <xsl:if test="count(mal:info/xsldoc:stub) > 0">
          <note>
            <p>This template is a stub. Customizations may override it for
            additional functionality.</p>
          </note>
        </xsl:if>
      </xsl:if>
      <xsl:apply-templates/>
      <xsl:if test="$type = 'templates'">
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
        <xsl:call-template name="calls_keys">
          <xsl:with-param name="node" select="."/>
          <xsl:with-param name="page" select="ancestor::mal:page"/>
          <xsl:with-param name="xslt_node" select="$xslt_node"/>
        </xsl:call-template>
        <xsl:call-template name="calls_params">
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

</xsl:stylesheet>
