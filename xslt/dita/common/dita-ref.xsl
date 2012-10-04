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
<!ENTITY % selectors SYSTEM "dita-selectors.mod">
%selectors;
]>

<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
                xmlns:func="http://exslt.org/functions"
                xmlns="http://www.w3.org/1999/xhtml"
                extension-element-prefixes="func"
                version="1.0">

<!--!!==========================================================================
DITA References

REMARK: Describe this module
-->

<xsl:key name="dita.id.key" match="&topic_topic_all;[@id]" use="@id"/>
<xsl:key name="dita.id.key" match="*[@id][not(self::&topic_topic_all;)]"
         use="concat(ancestor-or-self::&topic_topic_all;[1]/@id, '/', @id)"/>

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

<func:function xmlns:yelp="http://projects.gnome.org/yelp/" name="yelp:dita.ref.conref">
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

<!--
<xsl:template name="dita.conref.node">
  <xsl:param name="node" select="."/>
  <xsl:choose>
    <xsl:when test="$node/@conref">
    </xsl:when>
    <xsl:otherwise>
    </xsl:otherwise>
  </xsl:choose>
</xsl:template>
-->

</xsl:stylesheet>
