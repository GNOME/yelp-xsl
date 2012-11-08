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
DITA to HTML - Media

REMARK: Describe this module
-->


<!-- = image = -->
<xsl:template mode="dita2html.topic.mode" match="&topic_image;">
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
      <div class="media media-image">
        <div class="inner">
          <xsl:call-template name="_dita2html.image.img">
            <xsl:with-param name="conref" select="$conref"/>
          </xsl:call-template>
        </div>
      </div>
    </xsl:when>
    <xsl:otherwise>
      <span class="media media-image">
        <xsl:call-template name="_dita2html.image.img">
          <xsl:with-param name="conref" select="$conref"/>
        </xsl:call-template>
      </span>
    </xsl:otherwise>
  </xsl:choose>
</xsl:template>

<!--#* _dita2html.image.img -->
<xsl:template name="_dita2html.image.img">
  <xsl:param name="node" select="."/>
  <xsl:param name="conref" select="yelp:dita.ref.conref($node)"/>
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

</xsl:stylesheet>
