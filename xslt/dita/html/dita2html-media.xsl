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
DITA to HTML - Media

REMARK: Describe this module
-->


<!-- = image = -->
<xsl:template mode="dita2html.topic.mode" match="&topic_image;">
  <xsl:param name="usemap" select="''"/>
  <xsl:variable name="conref" select="yelp:dita.ref.conref(.)"/>
  <xsl:variable name="placement">
    <xsl:call-template name="dita.ref.conref.attr">
      <xsl:with-param name="attr" select="'placement'"/>
      <xsl:with-param name="node" select="."/>
      <xsl:with-param name="conref" select="$conref"/>
    </xsl:call-template>
  </xsl:variable>
  <xsl:choose>
    <xsl:when test="$placement = 'break'">
      <div>
        <xsl:call-template name="html.lang.attrs"/>
        <xsl:call-template name="html.class.attr">
          <xsl:with-param name="class" select="'media media-image'"/>
        </xsl:call-template>
        <div class="inner">
          <xsl:call-template name="_dita2html.image.img">
            <xsl:with-param name="conref" select="$conref"/>
            <xsl:with-param name="usemap" select="$usemap"/>
          </xsl:call-template>
        </div>
      </div>
    </xsl:when>
    <xsl:otherwise>
      <span>
        <xsl:call-template name="html.lang.attrs"/>
        <xsl:call-template name="html.class.attr">
          <xsl:with-param name="class" select="'media media-image'"/>
        </xsl:call-template>
        <xsl:call-template name="_dita2html.image.img">
          <xsl:with-param name="conref" select="$conref"/>
          <xsl:with-param name="usemap" select="$usemap"/>
        </xsl:call-template>
      </span>
    </xsl:otherwise>
  </xsl:choose>
</xsl:template>

<!--#* _dita2html.image.img -->
<xsl:template name="_dita2html.image.img">
  <xsl:param name="node" select="."/>
  <xsl:param name="conref" select="yelp:dita.ref.conref($node)"/>
  <xsl:param name="usemap" select="''"/>
  <xsl:variable name="href">
    <xsl:call-template name="dita.ref.conref.attr">
      <xsl:with-param name="attr" select="'href'"/>
      <xsl:with-param name="node" select="$node"/>
      <xsl:with-param name="conref" select="$conref"/>
    </xsl:call-template>
  </xsl:variable>
  <img src="{$href}">
    <xsl:if test="$node/@width">
      <xsl:variable name="width">
        <xsl:call-template name="dita.ref.conref.attr">
          <xsl:with-param name="attr" select="'width'"/>
          <xsl:with-param name="node" select="$node"/>
          <xsl:with-param name="conref" select="$conref"/>
        </xsl:call-template>
      </xsl:variable>
      <xsl:if test="contains('1234567890', substring($width, string-length($width)))">
        <xsl:attribute name="width">
          <xsl:value-of select="$width"/>
        </xsl:attribute>
      </xsl:if>
    </xsl:if>
    <xsl:if test="$node/@height">
      <xsl:variable name="height">
        <xsl:call-template name="dita.ref.conref.attr">
          <xsl:with-param name="attr" select="'height'"/>
          <xsl:with-param name="node" select="$node"/>
          <xsl:with-param name="conref" select="$conref"/>
        </xsl:call-template>
      </xsl:variable>
      <xsl:if test="contains('1234567890', substring($height, string-length($height)))">
        <xsl:attribute name="height">
          <xsl:value-of select="$height"/>
        </xsl:attribute>
      </xsl:if>
    </xsl:if>
    <xsl:if test="$usemap != ''">
      <xsl:attribute name="usemap">
        <xsl:value-of select="$usemap"/>
      </xsl:attribute>
    </xsl:if>
    <xsl:choose>
      <xsl:when test="&topic_alt;">
        <xsl:attribute name="alt">
          <xsl:apply-templates mode="dita2html.topic.mode"
                               select="yelp:dita.ref.conref(&topic_alt;)/node()"/>
        </xsl:attribute>
      </xsl:when>
      <xsl:when test="@alt">
        <xsl:attribute name="alt">
          <xsl:call-template name="dita.ref.conref.attr">
            <xsl:with-param name="attr" select="'alt'"/>
            <xsl:with-param name="node" select="$node"/>
            <xsl:with-param name="conref" select="$conref"/>
          </xsl:call-template>
        </xsl:attribute>
      </xsl:when>
    </xsl:choose>
  </img>
</xsl:template>

<!-- = imagemap = -->
<xsl:template mode="dita2html.topic.mode" match="&topic_imagemap;">
  <xsl:variable name="conref" select="yelp:dita.ref.conref(.)"/>
  <xsl:variable name="name">
    <xsl:choose>
      <xsl:when test="@id">
        <xsl:value-of select="@id"/>
      </xsl:when>
      <xsl:otherwise>
        <xsl:value-of select="generate-id()"/>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:variable>
  <xsl:apply-templates mode="dita2html.topic.mode" select="$conref/&topic_image;">
    <xsl:with-param name="usemap" select="concat('#', $name)"/>
  </xsl:apply-templates>
  <map name="{$name}">
    <xsl:call-template name="html.lang.attrs"/>
    <xsl:call-template name="html.class.attr"/>
    <xsl:apply-templates mode="dita2html.topic.mode" select="$conref/&topic_area;"/>
  </map>
</xsl:template>

<!-- = area = -->
<xsl:template mode="dita2html.topic.mode" match="&topic_area;">
  <xsl:variable name="conref" select="yelp:dita.ref.conref(.)"/>
  <area>
    <xsl:call-template name="html.lang.attrs"/>
    <xsl:call-template name="html.class.attr"/>
    <xsl:attribute name="shape">
      <xsl:value-of select="$conref/&topic_shape;"/>
    </xsl:attribute>
    <xsl:attribute name="coords">
      <xsl:value-of select="$conref/&topic_coords;"/>
    </xsl:attribute>
    <xsl:for-each select="&topic_xref;[1]">
      <xsl:attribute name="href">
        <xsl:call-template name="dita.ref.href.target"/>
      </xsl:attribute>
      <xsl:attribute name="title">
        <xsl:call-template name="dita.ref.href.content"/>
      </xsl:attribute>
    </xsl:for-each>
  </area>
</xsl:template>

<!-- = object = -->
<xsl:template mode="dita2html.topic.mode" match="&topic_object;">
  <xsl:variable name="conref" select="yelp:dita.ref.conref(.)"/>
  <div>
    <xsl:call-template name="dita.id"/>
    <xsl:call-template name="html.lang.attrs"/>
    <xsl:call-template name="html.class.attr">
      <xsl:with-param name="class" select="'dita-object'"/>
    </xsl:call-template>
    <xsl:apply-templates mode="dita2html.topic.mode" select="&topic_desc;"/>
    <div class="contents">
      <xsl:element name="{local-name(.)}" namespace="{$html.namespace}">
        <xsl:for-each select="@*[namespace-uri(.) = '']">
          <xsl:attribute name="{local-name(.)}">
            <xsl:call-template name="dita.ref.conref.attr">
              <xsl:with-param name="attr" select="local-name(.)"/>
              <xsl:with-param name="conref" select="$conref"/>
            </xsl:call-template>
          </xsl:attribute>
        </xsl:for-each>
        <xsl:apply-templates mode="dita2html.topic.mode" select="$conref/&topic_param;"/>
      </xsl:element>
    </div>
  </div>
</xsl:template>

<!-- = param = -->
<xsl:template mode="dita2html.topic.mode" match="&topic_param;">
  <xsl:variable name="conref" select="yelp:dita.ref.conref(.)"/>
  <xsl:element name="{local-name(.)}" namespace="{$html.namespace}">
    <xsl:call-template name="dita.id"/>
    <xsl:call-template name="html.lang.attrs"/>
    <xsl:call-template name="html.class.attr"/>
    <xsl:for-each select="@*[namespace-uri(.) = '']">
      <xsl:attribute name="{local-name(.)}">
        <xsl:call-template name="dita.ref.conref.attr">
          <xsl:with-param name="attr" select="local-name(.)"/>
          <xsl:with-param name="node" select="$node"/>
          <xsl:with-param name="conref" select="$conref"/>
        </xsl:call-template>
      </xsl:attribute>
    </xsl:for-each>
  </xsl:element>
</xsl:template>

</xsl:stylesheet>
