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
                xmlns:exsl="http://exslt.org/common"
                xmlns:str="http://exslt.org/strings"
                exclude-result-prefixes="exsl str"
                version="1.0">

<!--!!==========================================================================
DITA Maps

REMARK: Describe this module
-->


<xsl:param name="dita.map.base" select="/"/>

<xsl:variable name="_dita.map">
  <xsl:apply-templates mode="dita.map.copy.mode" select="/&map_map;"/>
</xsl:variable>
<xsl:param name="dita.map" select="exsl:node-set($_dita.map)"/>

<xsl:template mode="dita.map.copy.mode" match="*">
  <xsl:param name="base"/>
  <xsl:copy>
    <xsl:copy-of select="@*"/>
    <xsl:apply-templates mode="dita.map.copy.mode">
      <xsl:with-param name="base" select="$base"/>
    </xsl:apply-templates>
  </xsl:copy>
</xsl:template>

<xsl:template mode="dita.map.copy.mode" match="&map_topicref;">
  <xsl:param name="base"/>
  <xsl:variable name="uri">
    <xsl:choose>
      <xsl:when test="contains(@href, ':') or starts-with(@href, '/')">
        <xsl:value-of select="@href"/>
      </xsl:when>
      <xsl:otherwise>
        <xsl:value-of select="$base"/>
        <xsl:value-of select="@href"/>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:variable>
  <xsl:choose>
    <!-- FIXME: conref and keyref -->
    <xsl:when test="@href and @format = 'ditamap'">
      <xsl:apply-templates mode="dita.map.copy.mode"
                           select="document($uri, $dita.map.base)/*/*[not(self::&topic_title_all;)]">
        <xsl:with-param name="base">
          <xsl:variable name="_base">
            <xsl:if test="contains($uri, '/')">
              <xsl:for-each select="str:split($uri, '/')">
                <xsl:if test="position() != last()">
                  <xsl:value-of select="."/>
                  <xsl:text>/</xsl:text>
                </xsl:if>
              </xsl:for-each>
            </xsl:if>
          </xsl:variable>
          <xsl:value-of select="$_base"/>
        </xsl:with-param>
      </xsl:apply-templates>
    </xsl:when>
    <xsl:otherwise>
      <xsl:copy>
        <xsl:copy-of select="@*[name(.) != 'href']"/>
        <xsl:if test="@href">
          <xsl:attribute name="href">
            <xsl:value-of select="$uri"/>
          </xsl:attribute>
        </xsl:if>
        <xsl:apply-templates mode="dita.map.copy.mode">
          <xsl:with-param name="base" select="$base"/>
        </xsl:apply-templates>
      </xsl:copy>
    </xsl:otherwise>
  </xsl:choose>
</xsl:template>

</xsl:stylesheet>
