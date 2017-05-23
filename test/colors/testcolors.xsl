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
along with this program; see the file COPYING.LGPL.  If not, see <http://www.gnu.org/licenses/>.
-->

<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
                xmlns:math="http://exslt.org/math"
                exclude-result-prefixes="math"
                version="1.0">

<xsl:include href="../../xslt/common/color.xsl"/>

<xsl:template match="/">
  <html>
    <head>
      <style type="text/css">
body {
  margin: 0;
  display: flex;
  flex-flow: row wrap;
  font-size: 14px;
  font-family: sans-serif;
  background: <xsl:value-of select="$color.bg"/>;
  color: <xsl:value-of select="$color.fg"/>;
}
h1 {
  margin: 10px;
  flex: 100% 1 0;
  font-size: 30px;
}
h2 { margin: 0; font-size: 20px; }
section {
  margin: 10px;
  flex: 300px 1 0;
}
div.box { margin: 20px 0; padding: 10px; border: solid 1px black; }
p { margin: 10px 0 0 0; }
p:first-child { margin-top: 0; }
      </style>
    </head>
    <body>
      <h1>Color Test</h1>
      <xsl:call-template name="section">
        <xsl:with-param name="title" select="'Red'"/>
        <xsl:with-param name="base" select="$color.red"/>
        <xsl:with-param name="fg" select="$color.fg.red"/>
        <xsl:with-param name="bg" select="$color.bg.red"/>
      </xsl:call-template>
      <xsl:call-template name="section">
        <xsl:with-param name="title" select="'Orange'"/>
        <xsl:with-param name="base" select="$color.orange"/>
        <xsl:with-param name="fg" select="$color.fg.orange"/>
        <xsl:with-param name="bg" select="$color.bg.orange"/>
      </xsl:call-template>
      <xsl:call-template name="section">
        <xsl:with-param name="title" select="'Yellow'"/>
        <xsl:with-param name="base" select="$color.yellow"/>
        <xsl:with-param name="fg" select="$color.fg.yellow"/>
        <xsl:with-param name="bg" select="$color.bg.yellow"/>
      </xsl:call-template>
      <xsl:call-template name="section">
        <xsl:with-param name="title" select="'Green'"/>
        <xsl:with-param name="base" select="$color.green"/>
        <xsl:with-param name="fg" select="$color.fg.green"/>
        <xsl:with-param name="bg" select="$color.bg.green"/>
      </xsl:call-template>
      <xsl:call-template name="section">
        <xsl:with-param name="title" select="'Blue'"/>
        <xsl:with-param name="base" select="$color.blue"/>
        <xsl:with-param name="fg" select="$color.fg.blue"/>
        <xsl:with-param name="bg" select="$color.bg.blue"/>
      </xsl:call-template>
      <xsl:call-template name="section">
        <xsl:with-param name="title" select="'Purple'"/>
        <xsl:with-param name="base" select="$color.purple"/>
        <xsl:with-param name="fg" select="$color.fg.purple"/>
        <xsl:with-param name="bg" select="$color.bg.purple"/>
      </xsl:call-template>
      <xsl:call-template name="section">
        <xsl:with-param name="title" select="'Gray'"/>
        <xsl:with-param name="base" select="$color.gray"/>
        <xsl:with-param name="fg" select="$color.fg.gray"/>
        <xsl:with-param name="bg" select="$color.bg.gray"/>
      </xsl:call-template>
      <xsl:call-template name="section">
        <xsl:with-param name="title" select="'Dark'"/>
        <xsl:with-param name="base" select="$color.gray"/>
        <xsl:with-param name="fg" select="$color.fg.dark"/>
        <xsl:with-param name="bg" select="$color.bg.dark"/>
      </xsl:call-template>
      <xsl:call-template name="section">
        <xsl:with-param name="title" select="'White'"/>
        <xsl:with-param name="base" select="$color.gray"/>
        <xsl:with-param name="fg" select="$color.fg"/>
        <xsl:with-param name="bg" select="$color.bg"/>
      </xsl:call-template>
      <section/>
      <section/>
    </body>
  </html>
</xsl:template>

<xsl:template name="section">
  <xsl:param name="title"/>
  <xsl:param name="base"/>
  <xsl:param name="fg"/>
  <xsl:param name="bg"/>
  <section>
    <h2><xsl:value-of select="$title"/></h2>
    <div class="box" style="color: {$fg}; border-color: {$base};">
      <p>This text is <xsl:value-of select="$fg"/></p>
      <p>The border is <xsl:value-of select="$base"/></p>
    </div>
    <div class="box" style="background-color: {$bg}; border-color: {$base};">
      <p>This background is <xsl:value-of select="$bg"/></p>
    </div>
    <div class="box" style="background-color: {$bg}; border-color: {$base};">
      <xsl:call-template name="row">
        <xsl:with-param name="bg" select="$bg"/>
        <xsl:with-param name="fg" select="$color.fg.red"/>
        <xsl:with-param name="label" select="'red'"/>
      </xsl:call-template>
      <xsl:call-template name="row">
        <xsl:with-param name="bg" select="$bg"/>
        <xsl:with-param name="fg" select="$color.fg.orange"/>
        <xsl:with-param name="label" select="'orange'"/>
      </xsl:call-template>
      <xsl:call-template name="row">
        <xsl:with-param name="bg" select="$bg"/>
        <xsl:with-param name="fg" select="$color.fg.yellow"/>
        <xsl:with-param name="label" select="'yellow'"/>
      </xsl:call-template>
      <xsl:call-template name="row">
        <xsl:with-param name="bg" select="$bg"/>
        <xsl:with-param name="fg" select="$color.fg.green"/>
        <xsl:with-param name="label" select="'green'"/>
      </xsl:call-template>
      <xsl:call-template name="row">
        <xsl:with-param name="bg" select="$bg"/>
        <xsl:with-param name="fg" select="$color.fg.blue"/>
        <xsl:with-param name="label" select="'blue'"/>
      </xsl:call-template>
      <xsl:call-template name="row">
        <xsl:with-param name="bg" select="$bg"/>
        <xsl:with-param name="fg" select="$color.fg.purple"/>
        <xsl:with-param name="label" select="'purple'"/>
      </xsl:call-template>
      <xsl:call-template name="row">
        <xsl:with-param name="bg" select="$bg"/>
        <xsl:with-param name="fg" select="$color.fg.gray"/>
        <xsl:with-param name="label" select="'gray'"/>
      </xsl:call-template>
      <xsl:call-template name="row">
        <xsl:with-param name="bg" select="$bg"/>
        <xsl:with-param name="fg" select="$color.fg.dark"/>
        <xsl:with-param name="label" select="'dark'"/>
      </xsl:call-template>
      <xsl:call-template name="row">
        <xsl:with-param name="bg" select="$bg"/>
        <xsl:with-param name="fg" select="$color.fg"/>
        <xsl:with-param name="label" select="'text'"/>
      </xsl:call-template>
    </div>
  </section>
</xsl:template>

<xsl:template name="row">
  <xsl:param name="bg"/>
  <xsl:param name="fg"/>
  <xsl:param name="label"/>
  <xsl:variable name="ratio">
    <xsl:call-template name="color.contrast">
      <xsl:with-param name="bg" select="$bg"/>
      <xsl:with-param name="fg" select="$fg"/>
    </xsl:call-template>
  </xsl:variable>
  <p style="color: {$fg}">
    <xsl:value-of select="$fg"/>
    <xsl:text> </xsl:text>
    <xsl:value-of select="$label"/>
    <xsl:text> </xsl:text>
    <xsl:value-of select="format-number($ratio, '##0.00')"/>
    <xsl:if test="$ratio &lt; 4.5">
      <b> &lt; 4.5</b>
    </xsl:if>
  </p>
</xsl:template>

</xsl:stylesheet>
