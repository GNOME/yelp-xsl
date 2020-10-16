<?xml version='1.0' encoding='UTF-8'?><!-- -*- indent-tabs-mode: nil -*- -->
<!--
Copyright (C) 2006-2018 Shaun McCance <shaunm@gnome.org>

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

<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
                xmlns:exsl="http://exslt.org/common"
                xmlns:set="http://exslt.org/sets"
                xmlns:str="http://exslt.org/strings"
                extension-element-prefixes="exsl"
                exclude-result-prefixes="set str"
                version="1.0">

<xsl:output method="text"/>

<xsl:param name="xsldoc.id"/>

<xsl:variable name="xsldoc.id.prefix">
  <xsl:choose>
    <xsl:when test="contains($xsldoc.id, '-')">
      <xsl:value-of select="substring-before($xsldoc.id, '-')"/>
    </xsl:when>
    <xsl:otherwise>
      <xsl:value-of select="$xsldoc.id"/>
    </xsl:otherwise>
  </xsl:choose>
</xsl:variable>

<xsl:template match="/xsl:stylesheet">
  <xsl:for-each select="comment()">
    <xsl:variable name="type">
      <xsl:choose>
        <xsl:when test="starts-with(., '!!')">
          <xsl:text>stylesheet</xsl:text>
        </xsl:when>
        <xsl:when test="starts-with(., '**')">
          <xsl:text>template</xsl:text>
        </xsl:when>
        <xsl:when test="starts-with(., '@@')">
          <xsl:text>param</xsl:text>
        </xsl:when>
        <xsl:when test="starts-with(., '%%')">
          <xsl:text>mode</xsl:text>
        </xsl:when>
        <xsl:when test="starts-with(., '++')">
          <xsl:text>key</xsl:text>
        </xsl:when>
      </xsl:choose>
    </xsl:variable>
    <xsl:if test="$type != ''">
      <xsl:variable name="name">
        <xsl:choose>
          <xsl:when test="$type = 'stylesheet'">
            <xsl:value-of select="$xsldoc.id"/>
          </xsl:when>
          <xsl:otherwise>
            <xsl:value-of select="substring-before(substring-after(., '&#x0A;'), '&#x0A;')"/>
          </xsl:otherwise>
        </xsl:choose>
      </xsl:variable>
      <exsl:document href="{$name}.duck" method="text">
        <xsl:call-template name="xsldoc.body">
          <xsl:with-param name="mode" select="'title'"/>
          <xsl:with-param name="type" select="$type"/>
          <xsl:with-param name="lines" select="substring-after(., '&#x0A;')"/>
        </xsl:call-template>
        <xsl:if test="$type = 'stylesheet'">
          <xsl:text>&#x0A;[links topic groups=imports .linklist]&#x0A;. Imports Stylesheets&#x0A;</xsl:text>
          <xsl:text>&#x0A;[links topic groups=includes .linklist]&#x0A;. Includes Stylesheets&#x0A;</xsl:text>
          <xsl:text>&#x0A;[links topic groups=params .linklist]&#x0A;. Defines Parameters&#x0A;</xsl:text>
          <xsl:text>&#x0A;[links topic groups=keys .linklist]&#x0A;. Defines Keys&#x0A;</xsl:text>
          <xsl:text>&#x0A;[links topic groups=templates .linklist]&#x0A;. Defines Templates&#x0A;</xsl:text>
          <xsl:text>&#x0A;[links topic groups=modes .linklist]&#x0A;. Defines Modes&#x0A;</xsl:text>
          <!-- FIXME: list params set here but not defined here for importing stylesheets -->
          <xsl:call-template name="xsldoc.calls.params">
            <xsl:with-param name="node" select="/xsl:stylesheet"/>
          </xsl:call-template>
          <xsl:call-template name="xsldoc.calls.keys">
            <xsl:with-param name="node" select="/xsl:stylesheet"/>
          </xsl:call-template>
          <xsl:call-template name="xsldoc.calls.templates">
            <xsl:with-param name="node" select="/xsl:stylesheet"/>
          </xsl:call-template>
          <xsl:call-template name="xsldoc.calls.modes">
            <xsl:with-param name="node" select="/xsl:stylesheet"/>
          </xsl:call-template>
          <xsl:call-template name="xsldoc.implements.templates">
            <xsl:with-param name="node" select="/xsl:stylesheet"/>
          </xsl:call-template>
        </xsl:if>
        <xsl:if test="$type = 'template'">
          <xsl:variable name="template" select="/xsl:stylesheet/xsl:template[@name = $name]"/>
          <xsl:if test="count($template) = 0">
            <xsl:message>
              <xsl:text>Missing template: </xsl:text>
              <xsl:value-of select="$name"/>
            </xsl:message>
          </xsl:if>
          <xsl:call-template name="xsldoc.calls.params">
            <xsl:with-param name="node" select="$template[1]"/>
          </xsl:call-template>
          <xsl:call-template name="xsldoc.calls.keys">
            <xsl:with-param name="node" select="$template[1]"/>
          </xsl:call-template>
          <xsl:call-template name="xsldoc.calls.templates">
            <xsl:with-param name="node" select="$template[1]"/>
          </xsl:call-template>
          <xsl:call-template name="xsldoc.calls.modes">
            <xsl:with-param name="node" select="$template[1]"/>
          </xsl:call-template>
        </xsl:if>
        <xsl:if test="$type = 'param'">
          <xsl:variable name="param" select="/xsl:stylesheet/xsl:param[@name = $name]"/>
          <xsl:if test="count($param) = 0">
            <xsl:message>
              <xsl:text>Missing param: </xsl:text>
              <xsl:value-of select="$name"/>
            </xsl:message>
          </xsl:if>
          <xsl:if test="$param/@select">
            <xsl:text>&#x0A;[synopsis]&#x0A;</xsl:text>
            <xsl:text>[terms]&#x0A;</xsl:text>
            <xsl:text>- $code(</xsl:text>
            <xsl:value-of select="$name"/>
            <xsl:text>)&#x0A;</xsl:text>
            <xsl:text>* $code(</xsl:text>
            <xsl:value-of select="$param/@select"/>
            <xsl:text>)&#x0A;</xsl:text>
          </xsl:if>
        </xsl:if>
      </exsl:document>
    </xsl:if>
  </xsl:for-each>
</xsl:template>

<xsl:template name="xsldoc.body">
  <xsl:param name="mode"/>
  <xsl:param name="type"/>
  <xsl:param name="lines"/>
  <xsl:variable name="blank" select="normalize-space(exsl:node-set(str:split($lines, '&#x0A;'))[1]) = ''
                                     or starts-with($lines, '&#x0A;')"/>
  <xsl:choose>
    <xsl:when test="$lines = ''"/>
    <xsl:when test="$mode = 'title'">
      <xsl:text>@ducktype/1.0&#x0A;&#x0A;</xsl:text>
      <xsl:text>= </xsl:text>
      <xsl:value-of select="substring-before($lines, '&#x0A;')"/>
      <xsl:choose>
        <xsl:when test="$type = 'stylesheet'">
          <xsl:text>&#x0A;  [guide .xslt-stylesheet]&#x0A;</xsl:text>
          <xsl:text>@link[guide >stylesheets group=</xsl:text>
          <xsl:value-of select="$xsldoc.id.prefix"/>
          <xsl:text>]&#x0A;</xsl:text>
          <xsl:call-template name="xsldoc.imports.includes.stylesheets"/>
        </xsl:when>
        <xsl:otherwise>
          <xsl:text>&#x0A;  [.xslt-</xsl:text>
          <xsl:value-of select="$type"/>
          <xsl:text>]&#x0A;</xsl:text>
          <xsl:text>@link[guide ></xsl:text>
          <xsl:value-of select="$xsldoc.id"/>
          <xsl:text> group=</xsl:text>
          <xsl:value-of select="$type"/>
          <xsl:text>s]&#x0A;</xsl:text>
          <xsl:text>@link[guide ></xsl:text>
          <xsl:value-of select="$type"/>
          <xsl:text>s group=</xsl:text>
          <xsl:value-of select="$xsldoc.id.prefix"/>
          <xsl:text>]&#x0A;</xsl:text>
        </xsl:otherwise>
      </xsl:choose>
      <xsl:call-template name="xsldoc.body">
        <xsl:with-param name="mode" select="'desc'"/>
        <xsl:with-param name="type" select="$type"/>
        <xsl:with-param name="lines" select="substring-after($lines, '&#x0A;')"/>
      </xsl:call-template>
    </xsl:when>
    <xsl:when test="$mode = 'desc'">
      <xsl:choose>
        <xsl:when test="$blank or starts-with($lines, '@')">
          <xsl:call-template name="xsldoc.body">
            <xsl:with-param name="mode" select="'info'"/>
            <xsl:with-param name="type" select="$type"/>
            <xsl:with-param name="lines" select="$lines"/>
          </xsl:call-template>
        </xsl:when>
        <xsl:otherwise>
          <xsl:text>@desc </xsl:text>
          <xsl:call-template name="xsldoc.inline">
            <xsl:with-param name="line" select="substring-before($lines, '&#x0A;')"/>
          </xsl:call-template>
          <xsl:text>&#x0A;</xsl:text>
          <xsl:call-template name="xsldoc.body">
            <xsl:with-param name="mode" select="'info'"/>
            <xsl:with-param name="type" select="$type"/>
            <xsl:with-param name="lines" select="substring-after($lines, '&#x0A;')"/>
          </xsl:call-template>
        </xsl:otherwise>
      </xsl:choose>
    </xsl:when>
    <xsl:when test="$mode = 'info'">
      <xsl:choose>
        <xsl:when test="starts-with($lines, '@xsl:stub')">
          <xsl:text>@link[guide >stubs group=</xsl:text>
          <xsl:value-of select="$xsldoc.id.prefix"/>
          <xsl:text>]&#x0A;</xsl:text>
          <xsl:call-template name="xsldoc.body">
            <xsl:with-param name="mode" select="'body'"/>
            <xsl:with-param name="type" select="$type"/>
            <xsl:with-param name="lines" select="substring-after($lines, '&#x0A;')"/>
          </xsl:call-template>
        </xsl:when>
        <xsl:when test="starts-with($lines, '@')">
          <xsl:value-of select="substring-before($lines, '&#x0A;')"/>
          <xsl:text>&#x0A;</xsl:text>
          <xsl:call-template name="xsldoc.body">
            <xsl:with-param name="mode" select="'body'"/>
            <xsl:with-param name="type" select="$type"/>
            <xsl:with-param name="lines" select="substring-after($lines, '&#x0A;')"/>
          </xsl:call-template>
        </xsl:when>
        <xsl:otherwise>
          <xsl:call-template name="xsldoc.body">
            <xsl:with-param name="mode" select="'body'"/>
            <xsl:with-param name="type" select="$type"/>
            <xsl:with-param name="lines" select="$lines"/>
          </xsl:call-template>
        </xsl:otherwise>
      </xsl:choose>
    </xsl:when>
    <xsl:when test="$mode = 'params'">
      <xsl:choose>
        <!-- FIXME: defaults would be nice -->
        <xsl:when test="starts-with($lines, '$')">
          <xsl:variable name="line" select="substring-before($lines, '&#x0A;')"/>
          <xsl:text>- $code(</xsl:text>
          <xsl:value-of select="normalize-space(substring-before($line, ':'))"/>
          <xsl:text>)&#x0A;</xsl:text>
          <xsl:text>* </xsl:text>
          <xsl:call-template name="xsldoc.inline">
            <xsl:with-param name="line" select="normalize-space(substring-after($line, ':'))"/>
          </xsl:call-template>
          <xsl:text>&#x0A;</xsl:text>
          <xsl:call-template name="xsldoc.body">
            <xsl:with-param name="mode" select="'params'"/>
            <xsl:with-param name="type" select="$type"/>
            <xsl:with-param name="lines" select="substring-after($lines, '&#x0A;')"/>
          </xsl:call-template>
        </xsl:when>
        <xsl:otherwise>
          <xsl:call-template name="xsldoc.body">
            <xsl:with-param name="mode" select="'body'"/>
            <xsl:with-param name="type" select="$type"/>
            <xsl:with-param name="lines" select="$lines"/>
          </xsl:call-template>
        </xsl:otherwise>
      </xsl:choose>
    </xsl:when>
    <xsl:otherwise>
      <xsl:choose>
        <xsl:when test="starts-with($lines, '[xsl:params]')">
          <xsl:text>[synopsis]&#x0A;. Parameters&#x0A;[terms]&#x0A;</xsl:text>
          <xsl:call-template name="xsldoc.body">
            <xsl:with-param name="mode" select="'params'"/>
            <xsl:with-param name="type" select="$type"/>
            <xsl:with-param name="lines" select="substring-after($lines, '&#x0A;')"/>
          </xsl:call-template>
        </xsl:when>
        <xsl:otherwise>
          <xsl:call-template name="xsldoc.inline">
            <xsl:with-param name="line" select="substring-before($lines, '&#x0A;')"/>
          </xsl:call-template>
          <xsl:text>&#x0A;</xsl:text>
          <xsl:call-template name="xsldoc.body">
            <xsl:with-param name="mode" select="'body'"/>
            <xsl:with-param name="type" select="$type"/>
            <xsl:with-param name="lines" select="substring-after($lines, '&#x0A;')"/>
          </xsl:call-template>
        </xsl:otherwise>
      </xsl:choose>
    </xsl:otherwise>
  </xsl:choose>
</xsl:template>

<xsl:template name="xsldoc.inline">
  <xsl:param name="line" select="''"/>
  <xsl:variable name="char" select="substring($line, 1, 1)"/>
  <xsl:variable name="rest" select="substring($line, 2)"/>
  <xsl:choose>
    <xsl:when test="$line = ''"/>
    <xsl:when test="$char = '{'">
      <xsl:variable name="var" select="substring-before($rest, '}')"/>
      <xsl:variable name="aft" select="substring-after($rest, '}')"/>
      <xsl:text>$code[></xsl:text>
      <xsl:value-of select="$var"/>
      <xsl:text>](</xsl:text>
      <xsl:value-of select="$var"/>
      <xsl:text>)</xsl:text>
      <xsl:call-template name="xsldoc.inline">
        <xsl:with-param name="line" select="$aft"/>
      </xsl:call-template>
    </xsl:when>
    <xsl:when test="$char = '`'">
      <xsl:variable name="sys" select="substring-before($rest, '`')"/>
      <xsl:variable name="aft" select="substring-after($rest, '`')"/>
      <xsl:text>$sys(</xsl:text>
      <xsl:value-of select="$sys"/>
      <xsl:text>)</xsl:text>
      <xsl:call-template name="xsldoc.inline">
        <xsl:with-param name="line" select="$aft"/>
      </xsl:call-template>
    </xsl:when>
    <xsl:when test="$char = '$'">
      <xsl:variable name="param">
        <xsl:call-template name="xsldoc.getword">
          <xsl:with-param name="string" select="$rest"/>
        </xsl:call-template>
      </xsl:variable>
      <xsl:choose>
        <xsl:when test="string-length($param) = 0">
          <xsl:text>$</xsl:text>
          <xsl:call-template name="xsldoc.inline">
            <xsl:with-param name="line" select="$rest"/>
          </xsl:call-template>
        </xsl:when>
        <xsl:otherwise>
          <xsl:variable name="param_">
            <xsl:choose>
              <xsl:when test="substring($param, string-length($param)) = '.'">
                <xsl:value-of select="substring($param, 1, string-length($param) - 1)"/>
              </xsl:when>
              <xsl:otherwise>
                <xsl:value-of select="$param"/>
              </xsl:otherwise>
            </xsl:choose>
          </xsl:variable>
          <xsl:text>$code($</xsl:text>
          <xsl:value-of select="$param_"/>
          <xsl:text>)</xsl:text>
          <xsl:call-template name="xsldoc.inline">
            <xsl:with-param name="line" select="substring($rest, string-length($param_) + 1)"/>
          </xsl:call-template>
        </xsl:otherwise>
      </xsl:choose>
    </xsl:when>
    <xsl:otherwise>
      <xsl:value-of select="$char"/>
      <xsl:call-template name="xsldoc.inline">
        <xsl:with-param name="line" select="$rest"/>
      </xsl:call-template>
    </xsl:otherwise>
  </xsl:choose>
</xsl:template>

<xsl:template name="xsldoc.imports.includes.stylesheets">
  <!-- FIXME: split this in two, follow import for each -->
  <xsl:param name="node" select="/*"/>
  <xsl:for-each select="$node//xsl:import">
    <xsl:variable name="base" select="substring-before(str:split(@href, '/')[last()], '.xsl')"/>
    <xsl:choose>
      <xsl:when test="processing-instruction('xsldoc.passthrough')">
        <xsl:call-template name="xsldoc.imports.includes.stylesheets">
          <xsl:with-param name="node" select="document(@href, $node)"/>
        </xsl:call-template>
      </xsl:when>
      <xsl:otherwise>
        <xsl:text>@link[topic ></xsl:text>
        <xsl:value-of select="$base"/>
        <xsl:text> group=imports]&#x0A;</xsl:text>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:for-each>
  <xsl:for-each select="$node//xsl:include">
    <xsl:variable name="base" select="substring-before(str:split(@href, '/')[last()], '.xsl')"/>
    <xsl:text>@link[topic ></xsl:text>
    <xsl:value-of select="$base"/>
    <xsl:text> group=includes]&#x0A;</xsl:text>
  </xsl:for-each>
</xsl:template>

<xsl:template name="xsldoc.calls.templates">
  <xsl:param name="node" select="."/>
  <xsl:variable name="templates">
    <xsl:call-template name="xsldoc.calls.templates.get">
      <xsl:with-param name="node" select="$node"/>
    </xsl:call-template>
  </xsl:variable>
  <xsl:if test="normalize-space($templates) != ''">
    <xsl:text>&#x0A;[list .compact]&#x0A;</xsl:text>
    <xsl:text>. Calls Templates&#x0A;</xsl:text>
    <xsl:for-each select="set:distinct(str:split($templates))">
      <xsl:sort select="."/>
      <xsl:if test="not(preceding-sibling::*[@xref = current()/@xref])">
        <xsl:text>* $link[></xsl:text>
        <xsl:value-of select="."/>
        <xsl:text>]&#x0A;</xsl:text>
      </xsl:if>
    </xsl:for-each>
  </xsl:if>
</xsl:template>

<xsl:template name="xsldoc.calls.templates.get">
  <xsl:param name="node" select="."/>
  <xsl:for-each select="$node//xsl:call-template[
                        not(@name = $node/self::xsl:stylesheet/xsl:template/@name) and
                        not(starts-with(@name, '_'))
                        ]">
    <xsl:value-of select="@name"/>
    <xsl:text> </xsl:text>
  </xsl:for-each>
  <xsl:for-each select="$node/self::xsl:stylesheet/xsl:import">
    <xsl:variable name="base" select="substring-before(str:split(@href, '/')[last()], '.xsl')"/>
    <xsl:if test="processing-instruction('xsldoc.passthrough')">
      <xsl:call-template name="xsldoc.calls.templates.get">
        <xsl:with-param name="node" select="document(@href, $node)"/>
      </xsl:call-template>
    </xsl:if>
  </xsl:for-each>
</xsl:template>

<xsl:template name="xsldoc.calls.modes">
  <xsl:param name="node" select="."/>
  <xsl:variable name="modes">
    <xsl:call-template name="xsldoc.calls.modes.get">
      <xsl:with-param name="node" select="$node"/>
    </xsl:call-template>
  </xsl:variable>
  <xsl:if test="normalize-space($modes) != ''">
    <xsl:text>&#x0A;[list .compact]&#x0A;</xsl:text>
    <xsl:text>. Calls Modes&#x0A;</xsl:text>
    <xsl:for-each select="set:distinct(str:split($modes))">
      <xsl:sort select="."/>
      <xsl:if test="not(preceding-sibling::*[@xref = current()/@xref])">
        <xsl:text>* $link[></xsl:text>
        <xsl:value-of select="."/>
        <xsl:text>]&#x0A;</xsl:text>
      </xsl:if>
    </xsl:for-each>
  </xsl:if>
</xsl:template>

<xsl:template name="xsldoc.calls.modes.get">
  <xsl:param name="node" select="."/>
  <xsl:for-each select="$node//xsl:apply-templates[@mode]">
    <xsl:value-of select="@mode"/>
    <xsl:text> </xsl:text>
  </xsl:for-each>
  <xsl:for-each select="$node/self::xsl:stylesheet/xsl:import">
    <xsl:variable name="base" select="substring-before(str:split(@href, '/')[last()], '.xsl')"/>
    <xsl:if test="processing-instruction('xsldoc.passthrough')">
      <xsl:call-template name="xsldoc.calls.modes.get">
        <xsl:with-param name="node" select="document(@href, $node)"/>
      </xsl:call-template>
    </xsl:if>
  </xsl:for-each>
</xsl:template>

<xsl:template name="xsldoc.calls.keys">
  <xsl:param name="node" select="."/>
  <xsl:variable name="keys">
    <xsl:call-template name="xsldoc.calls.keys.get">
      <xsl:with-param name="node" select="$node"/>
    </xsl:call-template>
  </xsl:variable>
  <xsl:if test="normalize-space($keys) != ''">
    <xsl:text>&#x0A;[list .compact]&#x0A;</xsl:text>
    <xsl:text>. Calls Keys&#x0A;</xsl:text>
    <xsl:for-each select="set:distinct(str:split($keys))">
      <xsl:sort select="."/>
      <xsl:if test="not(preceding-sibling::*[@xref = current()/@xref])">
        <xsl:text>* $link[></xsl:text>
        <xsl:value-of select="."/>
        <xsl:text>]&#x0A;</xsl:text>
      </xsl:if>
    </xsl:for-each>
  </xsl:if>
</xsl:template>

<xsl:template name="xsldoc.calls.keys.get">
  <xsl:param name="node" select="."/>
  <xsl:for-each select="$node//xsl:variable/@select   |
                        $node//xsl:param/@select      |
                        $node//xsl:with-param/@select |
                        $node//xsl:for-each/@select   |
                        $node//xsl:sort/@select       |
                        $node//xsl:value-of/@select   |
                        $node//xsl:if/@test           | 
                        $node//xsl:when/@test         ">
    <xsl:variable name="xpath_node" select="."/>
    <xsl:if test="contains($xpath_node, 'key(')">
      <!-- libxslt doesn't str:split when the string starts with the split arg -->
      <xsl:for-each select="str:split(concat(' ', $xpath_node), 'key(')[position() > 1]">
        <xsl:for-each select="str:tokenize(., concat('&quot;', &quot;&apos;&quot;))[1]">
          <xsl:value-of select="."/>
          <xsl:text> </xsl:text>
        </xsl:for-each>
      </xsl:for-each>
    </xsl:if>
  </xsl:for-each>
  <xsl:for-each select="$node/self::xsl:stylesheet/xsl:import">
    <xsl:variable name="base" select="substring-before(str:split(@href, '/')[last()], '.xsl')"/>
    <xsl:if test="processing-instruction('xsldoc.passthrough')">
      <xsl:call-template name="xsldoc.calls.keys.get">
        <xsl:with-param name="node" select="document(@href, $node)"/>
      </xsl:call-template>
    </xsl:if>
  </xsl:for-each>
</xsl:template>

<xsl:template name="xsldoc.calls.params">
  <xsl:param name="node" select="."/>
  <xsl:variable name="params">
    <xsl:call-template name="xsldoc.calls.params.get">
      <xsl:with-param name="node" select="$node"/>
    </xsl:call-template>
  </xsl:variable>
  <xsl:if test="normalize-space($params) != ''">
    <xsl:text>&#x0A;[list .compact]&#x0A;</xsl:text>
    <xsl:text>. Calls Parameters&#x0A;</xsl:text>
    <xsl:for-each select="set:distinct(str:split($params))">
      <xsl:sort select="."/>
      <xsl:if test="not(preceding-sibling::*[@xref = current()/@xref])">
        <xsl:text>* $link[></xsl:text>
        <xsl:value-of select="."/>
        <xsl:text>]&#x0A;</xsl:text>
      </xsl:if>
    </xsl:for-each>
  </xsl:if>
</xsl:template>

<xsl:template name="xsldoc.calls.params.get">
  <xsl:param name="node" select="."/>
  <xsl:for-each select="$node//xsl:variable/@select   |
                        $node//xsl:param/@select      |
                        $node//xsl:with-param/@select |
                        $node//xsl:for-each/@select   |
                        $node//xsl:sort/@select       |
                        $node//xsl:value-of/@select   |
                        $node//xsl:if/@test           | 
                        $node//xsl:when/@test         ">
    <xsl:variable name="xpath_node" select="."/>
    <xsl:if test="contains($xpath_node, '$')">
      <!-- libxslt doesn't str:split when the string starts with the split arg -->
      <xsl:for-each select="str:split(concat(' ', $xpath_node), '$')[position() > 1]">
        <xsl:variable name="paramname">
          <xsl:call-template name="xsldoc.getword">
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
          <xsl:value-of select="$paramname"/>
          <xsl:text> </xsl:text>
        </xsl:if>
      </xsl:for-each>
    </xsl:if>
  </xsl:for-each>
  <xsl:for-each select="$node/self::xsl:stylesheet/xsl:import">
    <xsl:variable name="base" select="substring-before(str:split(@href, '/')[last()], '.xsl')"/>
    <xsl:if test="processing-instruction('xsldoc.passthrough')">
      <xsl:call-template name="xsldoc.calls.params.get">
        <xsl:with-param name="node" select="document(@href, $node)"/>
      </xsl:call-template>
    </xsl:if>
  </xsl:for-each>
</xsl:template>

<!-- FIXME: follow imports? -->
<xsl:template name="xsldoc.implements.templates">
  <xsl:param name="node" select="."/>
  <xsl:variable name="impls">
    <xsl:for-each select="$node/xsl:template[@match]">
      <xsl:variable name="mode" select="@mode"/>
      <template mode="{$mode}" match="{@match}"/>
    </xsl:for-each>
  </xsl:variable>
  <xsl:variable name="impls_nodes" select="exsl:node-set($impls)/*"/>
  <xsl:if test="count($impls_nodes) != 0">
    <xsl:text>&#x0A;[table rules=rows]&#x0A;. Implements Templates&#x0A;</xsl:text>
    <xsl:text>[thead]&#x0A;[tr]&#x0A;- Mode&#x0a;- Match&#x0A;[tbody]&#x0A;</xsl:text>
    <xsl:for-each select="$impls_nodes">
      <xsl:sort select="@mode"/>
      <xsl:text>[tr]&#x0A;* </xsl:text>
      <xsl:choose>
        <xsl:when test="@mode != ''">
          <xsl:text>$code[></xsl:text>
          <xsl:value-of select="@mode"/>
          <xsl:text>](</xsl:text>
          <xsl:value-of select="@mode"/>
          <xsl:text>)</xsl:text>
        </xsl:when>
        <xsl:otherwise>
          <xsl:value-of select="@mode"/>
        </xsl:otherwise>
      </xsl:choose>
      <xsl:text>&#x0A;* $code(</xsl:text>
      <xsl:value-of select="@match"/>
      <xsl:text>)&#x0A;</xsl:text>
    </xsl:for-each>
  </xsl:if>
</xsl:template>

<xsl:template name="xsldoc.getword">
  <xsl:param name="string" select="''"/>
  <xsl:if test="$string != ''">
    <xsl:variable name="char" select="substring($string, 1, 1)"/>
    <xsl:if test="contains('abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ01234567890.-_', $char)">
      <xsl:value-of select="$char"/>
      <xsl:call-template name="xsldoc.getword">
        <xsl:with-param name="string" select="substring($string, 2)"/>
      </xsl:call-template>
    </xsl:if>
  </xsl:if>
</xsl:template>

</xsl:stylesheet>
