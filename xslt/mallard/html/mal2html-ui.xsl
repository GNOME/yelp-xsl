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
                xmlns:ui="http://projectmallard.org/experimental/ui/"
                xmlns="http://www.w3.org/1999/xhtml"
                exclude-result-prefixes="mal ui"
                version="1.0">

<!--!!==========================================================================
Mallard to HTML - UI Extension
Support for Mallard UI extension elements.

This stylesheet contains templates to support features from the Mallard UI
extension.
-->


<!--**==========================================================================
mal2html.ui.expander.data
Output data for an expander.
:Revision:version="3.4" date="2012-02-25" status="final"
$node: The source element to output data for.
$expander: Whether ${node} is actually an expander.

This template outputs an HTML #{div} element with the #{class} attribute set to
#{"yelp-data yelp-data-ui-expander"}. All #{yelp-data} elements are hidden by
the CSS. The div contains information about text directionality, the default
expanded state, and optionally additional titles for the expanded and collapsed
states.

The expander information is only output if the ${expander} parameter is #{true}.
This parameter can be calculated automatically, but it will give false negatives
for blocks that produce automatic titles.
-->
<xsl:template name="mal2html.ui.expander.data">
  <xsl:param name="node" select="."/>
  <xsl:param name="expander" select="$node/mal:title and
                                     ($node/@ui:expanded or $node/self::ui:expander)"/>
  <xsl:if test="$expander">
    <xsl:variable name="title_e" select="$node/mal:info/mal:title[@type = 'ui:expanded'][1]"/>
    <xsl:variable name="title_c" select="$node/mal:info/mal:title[@type = 'ui:collapsed'][1]"/>
    <div class="yelp-data yelp-data-ui-expander">
      <xsl:attribute name="dir">
        <xsl:call-template name="l10n.direction"/>
      </xsl:attribute>
      <xsl:attribute name="data-yelp-expanded">
        <xsl:choose>
          <xsl:when test="$node/self::ui:expander/@expanded = 'no'">
            <xsl:text>no</xsl:text>
          </xsl:when>
          <xsl:when test="$node/@ui:expanded = 'no'">
            <xsl:text>no</xsl:text>
          </xsl:when>
          <xsl:otherwise>
            <xsl:text>yes</xsl:text>
          </xsl:otherwise>
        </xsl:choose>
      </xsl:attribute>
      <xsl:if test="$title_e">
        <div class="yelp-title-expanded">
          <xsl:apply-templates mode="mal2html.inline.mode" select="$title_e/node()"/>
        </div>
      </xsl:if>
      <xsl:if test="$title_c">
        <div class="yelp-title-collapsed">
          <xsl:apply-templates mode="mal2html.inline.mode" select="$title_c/node()"/>
        </div>
      </xsl:if>
    </div>
  </xsl:if>
</xsl:template>


<!--**==========================================================================
mal2html.ui.links.grid
Output links as a grid of thumbnails.
:Revision:version="3.4" date="2012-02-25" status="final"
$node: A #{links} element to link from.
$links: A list of links, as from a template in !{mal-link}.
$role: A link role, used to select the appropriate title.

This template outputs links as a grid of thumbnails, as per the UI extension.
For each link, it outputs an inline-block #{div} element with a thumbnail,
title, and desc (unless the #{nodesc} style hint is used). This template calls
*{mal2html.ui.links.img} to find the best-match thumbnail and output the HTML
#{img} element for each link.

This template handles link sorting.
-->
<xsl:template name="mal2html.ui.links.grid">
  <xsl:param name="node" select="."/>
  <xsl:param name="links"/>
  <xsl:param name="role"/>
  <xsl:variable name="width">
    <xsl:choose>
      <xsl:when test="$node/@ui:width">
        <xsl:value-of select="$node/@ui:width"/>
      </xsl:when>
      <xsl:otherwise>
        <xsl:text>200</xsl:text>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:variable>
  <xsl:variable name="height">
    <xsl:choose>
      <xsl:when test="$node/@ui:height">
        <xsl:value-of select="$node/@ui:height"/>
      </xsl:when>
      <xsl:otherwise>
        <xsl:text>200</xsl:text>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:variable>
  <xsl:for-each select="$links">
    <xsl:sort data-type="number" select="@groupsort"/>
    <xsl:sort select="mal:title[@type = 'sort']"/>
    <xsl:variable name="link" select="."/>
    <xsl:for-each select="$mal.cache">
      <xsl:variable name="target" select="key('mal.cache.key', $link/@xref)"/>
      <div class="links-ui-grid {$link/@class}">
        <xsl:for-each select="$link/@*">
          <xsl:if test="starts-with(name(.), 'data-')">
            <xsl:copy-of select="."/>
          </xsl:if>
        </xsl:for-each>
        <xsl:variable name="thumbs" select="$target/mal:info/ui:thumb"/>
        <a>
          <xsl:attribute name="href">
            <xsl:call-template name="mal.link.target">
              <xsl:with-param name="node" select="$node"/>
              <xsl:with-param name="xref" select="$link/@xref"/>
            </xsl:call-template>
          </xsl:attribute>
          <xsl:attribute name="title">
            <xsl:call-template name="mal.link.tooltip">
              <xsl:with-param name="node" select="$node"/>
              <xsl:with-param name="xref" select="$link/@xref"/>
            </xsl:call-template>
          </xsl:attribute>
          <span class="links-ui-grid-img" style="width: {$width}px; height: {$height}px;">
            <xsl:call-template name="mal2html.ui.links.img">
              <xsl:with-param name="node" select="$node"/>
              <xsl:with-param name="thumbs" select="$thumbs"/>
              <xsl:with-param name="width" select="$width"/>
              <xsl:with-param name="height" select="$height"/>
            </xsl:call-template>
          </span>
          <span class="title" style="width: {$width}px; max-height: {number($height) div 2}px;">
            <xsl:call-template name="mal.link.content">
              <xsl:with-param name="node" select="$node"/>
              <xsl:with-param name="xref" select="$link/@xref"/>
              <xsl:with-param name="role" select="$role"/>
            </xsl:call-template>
          </span>
          <xsl:if test="not(contains(concat(' ', $node/@style, ' '), ' nodesc '))">
            <xsl:if test="$target/mal:info/mal:desc">
              <span class="desc" style="width: {$width}px; max-height: {number($height) div 2}px;">
                <xsl:apply-templates select="$target/mal:info/mal:desc/node()"/>
              </span>
            </xsl:if>
          </xsl:if>
        </a>
      </div>
    </xsl:for-each>
  </xsl:for-each>
</xsl:template>


<!--**==========================================================================
mal2html.ui.links.hover
Output links with thumbnails shown on hover.
:Revision:version="3.4" date="2012-02-26" status="final"
$node: A #{links} element to link from.
$links: A list of links, as from a template in !{mal-link}.
$role: A link role, used to select the appropriate title.

This template outputs links alongside thumbnail images, using the UI extension.
The thumbnail image for each link is shown when the user hovers over that link.
This template calls *{mal2html.ui.links.img} to find the best-match thumbnail
and output the HTML #{img} element for each link.

If ${node} contains a #{ui:thumb} element, that image is used when no links
are hovered.

This template handles link sorting.
-->
<xsl:template name="mal2html.ui.links.hover">
  <xsl:param name="node"/>
  <xsl:param name="links"/>
  <xsl:param name="role"/>
  <xsl:variable name="width">
    <xsl:choose>
      <xsl:when test="$node/@ui:width">
        <xsl:value-of select="$node/@ui:width"/>
      </xsl:when>
      <xsl:otherwise>
        <xsl:text>250</xsl:text>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:variable>
  <xsl:variable name="height">
    <xsl:choose>
      <xsl:when test="$node/@ui:height">
        <xsl:value-of select="$node/@ui:height"/>
      </xsl:when>
      <xsl:otherwise>
        <xsl:text>200</xsl:text>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:variable>
  <div class="links-ui-hover" style="width: {$width}px; height: {$height}px;">
    <xsl:for-each select="$node/ui:thumb[1]">
      <img>
        <xsl:copy-of select="@src"/>
        <xsl:call-template name="mal2html.ui.links.img.attrs">
          <xsl:with-param name="node" select="$node"/>
          <xsl:with-param name="thumb" select="."/>
          <xsl:with-param name="width" select="$width"/>
          <xsl:with-param name="height" select="$height"/>
        </xsl:call-template>
      </img>
    </xsl:for-each>
  </div>
  <ul class="links-ui-hover">
    <xsl:for-each select="$links">
      <xsl:sort data-type="number" select="@groupsort"/>
      <xsl:sort select="mal:title[@type = 'sort']"/>
      <xsl:variable name="link" select="."/>
      <xsl:variable name="xref" select="@xref"/>
      <xsl:for-each select="$mal.cache">
        <xsl:variable name="target" select="key('mal.cache.key', $xref)"/>
        <xsl:variable name="thumbs" select="$target/mal:info/ui:thumb"/>
        <li class="links {$link/@class}">
          <xsl:for-each select="$link/@*">
            <xsl:if test="starts-with(name(.), 'data-')">
              <xsl:copy-of select="."/>
            </xsl:if>
          </xsl:for-each>
          <a class="bold">
            <xsl:attribute name="href">
              <xsl:call-template name="mal.link.target">
                <xsl:with-param name="xref" select="$xref"/>
              </xsl:call-template>
            </xsl:attribute>
            <xsl:attribute name="title">
              <xsl:call-template name="mal.link.tooltip">
                <xsl:with-param name="xref" select="$xref"/>
                <xsl:with-param name="role" select="$role"/>
              </xsl:call-template>
            </xsl:attribute>
            <span class="links-ui-hover-img" style="width: {$width}px; height: {$height}px;">
              <xsl:call-template name="mal2html.ui.links.img">
                <xsl:with-param name="node" select="$node"/>
                <xsl:with-param name="thumbs" select="$thumbs"/>
                <xsl:with-param name="width" select="$width"/>
                <xsl:with-param name="height" select="$height"/>
              </xsl:call-template>
            </span>
            <span class="title">
              <xsl:call-template name="mal.link.content">
                <xsl:with-param name="node" select="."/>
                <xsl:with-param name="xref" select="$xref"/>
                <xsl:with-param name="role" select="$role"/>
              </xsl:call-template>
            </span>
          </a>
        </li>
      </xsl:for-each>
    </xsl:for-each>
  </ul>
  <div class="clear"/>
</xsl:template>


<!--**==========================================================================
mal2html.ui.links.img
Output an image for a link using UI thumbnails.
:Revision:version="3.4" date="2012-02-25" status="final"
$node: A #{links} element to link from.
$thumbs: A list of candidate #{ui:thumb} elements.
$width: The width to fit thumbnails into.
$height: The height to fit thumbnails into.

This template selects the best-fit thumbnail from ${thumbs}, based on how well
the aspect ratio and dimensions of each image matches the ${width} and ${height}
parameters. It outputs an HTML #{img} element for the best-fit thumbnail and
calls ${mal2html.ui.links.img.attrs} to output #{width} and #{height}
attributes.

The ${width} and ${height} parameters can be computed automatically from the
${node} element.
-->
<xsl:template name="mal2html.ui.links.img">
  <xsl:param name="node"/>
  <xsl:param name="thumbs"/>
  <xsl:param name="width" select="$node/@ui:width"/>
  <xsl:param name="height" select="$node/@ui:height"/>
  <xsl:if test="$thumbs">
    <img>
      <xsl:for-each select="$thumbs">
        <xsl:sort data-type="number" select="number(not(@width))"/>
        <xsl:sort data-type="number" select="number(not(@height))"/>
        <xsl:sort data-type="number" select="($width div $height) div (@width div @height)"/>
        <xsl:sort data-type="number" select="math:abs($width - @width)"/>
        <xsl:sort data-type="number" select="math:abs($height - @height)"/>
        <xsl:if test="position() = 1">
          <xsl:attribute name="src">
            <xsl:value-of select="@src"/>
          </xsl:attribute>
          <xsl:call-template name="mal2html.ui.links.img.attrs">
            <xsl:with-param name="node" select="$node"/>
            <xsl:with-param name="thumb" select="."/>
            <xsl:with-param name="width" select="$width"/>
            <xsl:with-param name="height" select="$height"/>
          </xsl:call-template>
        </xsl:if>
      </xsl:for-each>
    </img>
  </xsl:if>
</xsl:template>


<!--**==========================================================================
mal2html.ui.links.img.attrs
Output the #{width} and #{height} attributes for a thumbnail image.
:Revision:version="3.4" date="2012-02-25" status="final"
$node: A #{links} element to link from.
$thumbs: A list of candidate #{ui:thumb} elements.
$width: The width to fit thumbnails into.
$height: The height to fit thumbnails into.

This template outputs #{width} and #{height} attributes for the HTML #{img}
element created from ${thumb}, based on the #{ui:overflow} attribute on ${node}.
The ${width} and ${height} parameters can be computed automatically from the
${node} element.
-->
<xsl:template name="mal2html.ui.links.img.attrs">
  <xsl:param name="node"/>
  <xsl:param name="thumb"/>
  <xsl:param name="width" select="$node/@ui:width"/>
  <xsl:param name="height" select="$node/@ui:height"/>
  <xsl:choose>
    <xsl:when test="$node/@ui:overflow = 'crop'"/>
    <xsl:when test="$node/@ui:overflow = 'width'">
      <xsl:attribute name="width">
        <xsl:value-of select="$width"/>
      </xsl:attribute>
    </xsl:when>
    <xsl:when test="$node/@ui:overflow = 'height'">
      <xsl:attribute name="height">
        <xsl:value-of select="$height"/>
      </xsl:attribute>
    </xsl:when>
    <xsl:when test="$node/@ui:overflow = 'scale'">
      <xsl:attribute name="width">
        <xsl:value-of select="$width"/>
      </xsl:attribute>
      <xsl:attribute name="height">
        <xsl:value-of select="$height"/>
      </xsl:attribute>
    </xsl:when>
    <xsl:when test="$thumb/@width and $thumb/@height">
      <xsl:variable name="ratio" select="$width div $height"/>
      <xsl:variable name="tratio" select="$thumb/@width div $thumb/@height"/>
      <xsl:choose>
        <xsl:when test="$ratio &lt; $tratio">
          <xsl:attribute name="width">
            <xsl:value-of select="$width"/>
          </xsl:attribute>
          <xsl:attribute name="height">
            <xsl:value-of select="round($width * ($thumb/@height div $thumb/@width))"/>
          </xsl:attribute>
        </xsl:when>
        <xsl:otherwise>
          <xsl:attribute name="width">
            <xsl:value-of select="round($height * ($thumb/@width div $thumb/@height))"/>
          </xsl:attribute>
          <xsl:attribute name="height">
            <xsl:value-of select="$height"/>
          </xsl:attribute>
        </xsl:otherwise>
      </xsl:choose>
    </xsl:when>
    <xsl:otherwise>
      <xsl:attribute name="width">
        <xsl:value-of select="$width"/>
      </xsl:attribute>
      <xsl:attribute name="height">
        <xsl:value-of select="$height"/>
      </xsl:attribute>
    </xsl:otherwise>
  </xsl:choose>
</xsl:template>

</xsl:stylesheet>
