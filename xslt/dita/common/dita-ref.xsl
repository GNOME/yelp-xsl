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
<!ENTITY % selectors SYSTEM "dita-selectors.mod">
%selectors;
]>

<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
                xmlns:func="http://exslt.org/functions"
                xmlns:yelp="http://projects.gnome.org/yelp/" 
                extension-element-prefixes="func"
                exclude-result-prefixes="yelp"
                version="1.0">

<!--!!==========================================================================
DITA References

REMARK: Describe this module
-->


<!--@@==========================================================================
dita.ref.extension
The filename extension for output files.
@revision[version=3.8 date=2012-10-08 status=final]

When link targets are constructed by {dita.ref.href.target.custom} from `href`
attributes, this string is appended. This is used to specify the file extension
when creating output files from DITA topics.
-->
<xsl:param name="dita.ref.extension"/>


<xsl:key name="dita.id.key" match="&topic_topic_all;[@id]" use="@id"/>
<xsl:key name="dita.id.key" match="*[@id][not(self::&topic_topic_all;)]"
         use="concat(ancestor-or-self::&topic_topic_all;[1]/@id, '/', @id)"/>


<xsl:template mode="dita.ref.content.mode" match="* | text()">
  <xsl:value-of select="."/>
</xsl:template>

<xsl:template name="dita.id">
  <xsl:param name="node" select="."/>
  <xsl:choose>
    <xsl:when test="$node/self::&topic_topic;">
      <xsl:copy-of select="$node/@id"/>
    </xsl:when>
    <xsl:when test="$node/@id">
      <xsl:attribute name="id">
        <xsl:value-of select="concat($node/ancestor::&topic_topic;[@id][1]/@id, '::', $node/@id)"/>
      </xsl:attribute>
    </xsl:when>
  </xsl:choose>
</xsl:template>

<xsl:template name="dita.ref.conref.attr">
  <xsl:param name="attr"/>
  <xsl:param name="node"/>
  <xsl:param name="conref" select="yelp:dita.ref.conref($node)"/>
  <xsl:variable name="val" select="$node/attribute::*[name(.) = $attr]"/>
  <xsl:choose>
    <xsl:when test="$val = '-dita-use-conref-target'">
      <xsl:value-of select="$conref/attribute::*[name(.) = $attr]"/>
    </xsl:when>
    <xsl:otherwise>
      <xsl:value-of select="$val"/>
    </xsl:otherwise>
  </xsl:choose>
</xsl:template>

<func:function name="yelp:dita.ref.conref">
  <xsl:param name="node" select="."/>
  <xsl:choose>
    <xsl:when test="not($node/@conref)">
      <func:result select="$node"/>
    </xsl:when>
    <xsl:when test="starts-with($node/@conref, '#')">
      <func:result select="key('dita.id.key', substring-after($node/@conref, '#'))"/>
    </xsl:when>
    <xsl:otherwise>
      <xsl:variable name="uri">
        <xsl:choose>
          <xsl:when test="contains($node/@conref, '#')">
            <xsl:value-of select="substring-before($node/@conref, '#')"/>
          </xsl:when>
          <xsl:otherwise>
            <xsl:value-of select="$node/@conref"/>
          </xsl:otherwise>
        </xsl:choose>
      </xsl:variable>
      <xsl:for-each select="document($uri, $node)">
        <xsl:choose>
          <xsl:when test="contains($node/@conref, '#')">
            <func:result select="key('dita.id.key', substring-after($node/@conref, '#'))"/>
          </xsl:when>
          <xsl:otherwise>
            <func:result select="/*"/>
          </xsl:otherwise>
        </xsl:choose>
      </xsl:for-each>
    </xsl:otherwise>
  </xsl:choose>
</func:function>

<xsl:template name="dita.ref.href.target">
  <xsl:param name="node" select="."/>
  <xsl:param name="conref" select="yelp:dita.ref.conref($node)"/>
  <xsl:param name="href">
    <xsl:call-template name="dita.ref.conref.attr">
      <xsl:with-param name="attr" select="'href'"/>
      <xsl:with-param name="node" select="$node"/>
      <xsl:with-param name="conref" select="$conref"/>
    </xsl:call-template>
  </xsl:param>
  <xsl:variable name="format">
    <xsl:call-template name="dita.ref.conref.attr">
      <xsl:with-param name="attr" select="'format'"/>
      <xsl:with-param name="node" select="$node"/>
      <xsl:with-param name="conref" select="$conref"/>
    </xsl:call-template>
  </xsl:variable>
  <xsl:variable name="scope">
    <xsl:call-template name="dita.ref.conref.attr">
      <xsl:with-param name="attr" select="'scope'"/>
      <xsl:with-param name="node" select="$node"/>
      <xsl:with-param name="conref" select="$conref"/>
    </xsl:call-template>
  </xsl:variable>
  <xsl:variable name="type">
    <xsl:call-template name="dita.ref.conref.attr">
      <xsl:with-param name="attr" select="'type'"/>
      <xsl:with-param name="node" select="$node"/>
      <xsl:with-param name="conref" select="$conref"/>
    </xsl:call-template>
  </xsl:variable>
  <xsl:variable name="custom">
    <xsl:call-template name="dita.ref.href.target.custom">
      <xsl:with-param name="node" select="$node"/>
      <xsl:with-param name="href" select="$href"/>
    </xsl:call-template>
  </xsl:variable>
  <xsl:choose>
    <xsl:when test="$custom != ''">
      <xsl:value-of select="$custom"/>
    </xsl:when>
    <xsl:when test="$scope = 'external' or ($format != '' and $format != 'dita')">
      <xsl:value-of select="$href"/>
    </xsl:when>
    <xsl:otherwise>
      <xsl:variable name="uri">
        <xsl:choose>
          <xsl:when test="contains($href, '#')">
            <xsl:value-of select="substring-before($href, '#')"/>
          </xsl:when>
          <xsl:otherwise>
            <xsl:value-of select="$href"/>
          </xsl:otherwise>
        </xsl:choose>
      </xsl:variable>
      <xsl:variable name="frag">
        <xsl:if test="contains($href, '#')">
          <xsl:value-of select="substring-after($href, '#')"/>
        </xsl:if>
      </xsl:variable>
      <xsl:if test="$uri != ''">
        <xsl:choose>
          <xsl:when test="substring($uri, string-length($uri) - 4) = '.dita'">
            <xsl:value-of select="substring($uri, 1, string-length($uri) - 5)"/>
          </xsl:when>
          <xsl:when test="substring($uri, string-length($uri) - 3) = '.xml'">
            <xsl:value-of select="substring($uri, 1, string-length($uri) - 4)"/>
          </xsl:when>
          <xsl:otherwise>
            <xsl:value-of select="$uri"/>
          </xsl:otherwise>
        </xsl:choose>
        <xsl:value-of select="$dita.ref.extension"/>
      </xsl:if>
      <xsl:if test="$frag != ''">
        <xsl:text>#</xsl:text>
        <xsl:choose>
          <xsl:when test="contains($frag, '/')">
            <xsl:value-of select="substring-before($frag, '/')"/>
            <xsl:text>::</xsl:text>
            <xsl:value-of select="substring-after($frag, '/')"/>
          </xsl:when>
          <xsl:otherwise>
            <xsl:value-of select="$frag"/>
          </xsl:otherwise>
        </xsl:choose>
      </xsl:if>
    </xsl:otherwise>
  </xsl:choose>
</xsl:template>

<xsl:template name="dita.ref.href.target.custom">
  <xsl:param name="node" select="."/>
  <xsl:param name="conref" select="yelp:dita.ref.conref($node)"/>
  <xsl:param name="href">
    <xsl:call-template name="dita.ref.conref.attr">
      <xsl:with-param name="attr" select="'href'"/>
      <xsl:with-param name="node" select="$node"/>
      <xsl:with-param name="conref" select="$conref"/>
    </xsl:call-template>
  </xsl:param>
</xsl:template>

<xsl:template name="dita.ref.href.content">
  <xsl:param name="node" select="."/>
  <xsl:param name="conref" select="yelp:dita.ref.conref($node)"/>
  <xsl:param name="href">
    <xsl:call-template name="dita.ref.conref.attr">
      <xsl:with-param name="attr" select="'href'"/>
      <xsl:with-param name="node" select="$node"/>
      <xsl:with-param name="conref" select="$conref"/>
    </xsl:call-template>
  </xsl:param>
  <xsl:variable name="format">
    <xsl:call-template name="dita.ref.conref.attr">
      <xsl:with-param name="attr" select="'format'"/>
      <xsl:with-param name="node" select="$node"/>
      <xsl:with-param name="conref" select="$conref"/>
    </xsl:call-template>
  </xsl:variable>
  <xsl:variable name="scope">
    <xsl:call-template name="dita.ref.conref.attr">
      <xsl:with-param name="attr" select="'scope'"/>
      <xsl:with-param name="node" select="$node"/>
      <xsl:with-param name="conref" select="$conref"/>
    </xsl:call-template>
  </xsl:variable>
  <xsl:choose>
    <xsl:when test="$conref/node()[not(self::&topic_desc;)]">
      <xsl:apply-templates mode="dita2html.topic.mode"
                           select="$conref/node()[not(self::&topic_desc;)]"/>
    </xsl:when>
    <xsl:when test="$scope = 'external' or ($format != '' and $format != 'dita')">
      <xsl:value-of select="@href"/>
    </xsl:when>
    <xsl:otherwise>
      <xsl:variable name="uri">
        <xsl:choose>
          <xsl:when test="contains($href, '#')">
            <xsl:value-of select="substring-before($href, '#')"/>
          </xsl:when>
          <xsl:otherwise>
            <xsl:value-of select="$href"/>
          </xsl:otherwise>
        </xsl:choose>
      </xsl:variable>
      <xsl:for-each select="document($uri, .)">
        <xsl:variable name="frag">
          <xsl:choose>
            <xsl:when test="contains($href, '#')">
              <xsl:value-of select="substring-after($href, '#')"/>
            </xsl:when>
            <xsl:otherwise>
              <xsl:value-of select="/*/@id"/>
            </xsl:otherwise>
          </xsl:choose>
        </xsl:variable>
        <xsl:variable name="tnode" select="key('dita.id.key', $frag)"/>
        <xsl:choose>
          <xsl:when test="$tnode/&topic_titlealts;/&topic_navtitle;">
            <xsl:apply-templates mode="dita.ref.content.mode"
                                 select="$tnode/&topic_titlealts;/&topic_navtitle;/node()"/>
          </xsl:when>
          <xsl:otherwise>
            <xsl:apply-templates mode="dita.ref.content.mode"
                                 select="$tnode/&topic_title_all;/node()"/>
          </xsl:otherwise>
        </xsl:choose>
      </xsl:for-each>
    </xsl:otherwise>
  </xsl:choose>
</xsl:template>

<xsl:template name="dita.ref.topicref.navtitle">
  <xsl:param name="node" select="."/>
  <xsl:param name="href" select="$node/@href"/>
  <xsl:param name="base" select="$dita.map.base"/>
  <xsl:choose>
    <xsl:when test="$node[self::&map_map;]/&topic_booktitle;/&topic_mainbooktitle;">
      <xsl:apply-templates mode="dita.ref.content.mode"
                           select="$node/&topic_booktitle;/&topic_mainbooktitle;/node()"/>
    </xsl:when>
    <xsl:when test="$node[self::&map_map;]">
      <xsl:apply-templates mode="dita.ref.content.mode" select="$node/&topic_title;/node()"/>
    </xsl:when>
    <xsl:when test="$node/&map_topicmeta;/&topic_navtitle;">
      <xsl:apply-templates mode="dita.ref.content.mode"
                           select="$node/&map_topicmeta;/&topic_navtitle;/node()"/>
    </xsl:when>
    <xsl:when test="$node/@navtitle">
      <xsl:value-of select="$node/@navtitle"/>
    </xsl:when>
    <xsl:when test="$href != ''">
      <xsl:variable name="topic" select="document($href, $base)/&topic_topic_all;"/>
      <xsl:choose>
        <xsl:when test="$topic/&topic_titlealts;/&topic_navtitle;">
          <xsl:apply-templates mode="dita.ref.content.mode"
                               select="$topic/&topic_titlealts;/&topic_navtitle;/node()"/>
        </xsl:when>
        <xsl:otherwise>
          <xsl:apply-templates mode="dita.ref.content.mode"
                               select="$topic/&topic_title_all;/node()"/>
        </xsl:otherwise>
      </xsl:choose>
    </xsl:when>
  </xsl:choose>
</xsl:template>

<xsl:template name="dita.ref.topicref.shortdesc">
  <xsl:param name="node" select="."/>
  <xsl:param name="href" select="$node/@href"/>
  <xsl:param name="base" select="$dita.map.base"/>
  <xsl:choose>
    <xsl:when test="$node/&map_topicmeta;/&topic_shortdesc;">
      <xsl:apply-templates mode="dita.ref.content.mode"
                           select="$node/&map_topicmeta;/&topic_shortdesc;/node()"/>
    </xsl:when>
    <xsl:when test="$href != ''">
      <xsl:variable name="topic" select="document($href, $base)/&topic_topic_all;"/>
      <xsl:if test="$topic/&topic_shortdesc;">
        <xsl:apply-templates mode="dita.ref.content.mode"
                             select="$topic/&topic_shortdesc;/node()"/>
      </xsl:if>
    </xsl:when>
  </xsl:choose>
</xsl:template>
 
</xsl:stylesheet>
