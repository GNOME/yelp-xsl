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
                xmlns:msg="http://projects.gnome.org/yelp/gettext/"
                xmlns:its="http://www.w3.org/2005/11/its"
                xmlns:str="http://exslt.org/strings"
                exclude-result-prefixes="msg str"
                version="1.0">

<xsl:variable name="xml_out" select="/"/>
<xsl:variable name="xml_in" select="document('yelp-xsl.xml.in')"/>

<xsl:template match="/">
  <xsl:for-each select="$xml_in/msg:l10n/msg:msg">
    <xsl:variable name="msg" select="."/>
    <xsl:if test="contains(its:locNote, '&#x000A;&lt;')">
      <xsl:for-each select="str:split(its:locNote, '&#x000A;&lt;')[position() != 1]">
        <xsl:variable name="element" select="substring-before(., '/>')"/>
        <xsl:for-each select="$xml_out/msg:l10n/msg:msg[@id = $msg/@id]/msg:msgstr">
          <xsl:if test="not(.//*[local-name(.) = $element])">
            <xsl:message>
              <xsl:text>Missing </xsl:text>
              <xsl:value-of select="$element"/>
              <xsl:text> in </xsl:text>
              <xsl:value-of select="@xml:lang"/>
              <xsl:text> translation of </xsl:text>
              <xsl:value-of select="$msg/@id"/>
              <xsl:for-each select="descendant::*">
                <xsl:text>:</xsl:text>
                <xsl:value-of select="local-name(.)"/>
              </xsl:for-each>
            </xsl:message>
          </xsl:if>
        </xsl:for-each>
      </xsl:for-each>
    </xsl:if>
    <xsl:if test="$msg/@id = 'default:LTR'">
      <xsl:for-each select="$xml_out/msg:l10n/msg:msg[@id = $msg/@id]/msg:msgstr">
        <xsl:if test="not(. = 'default:LTR') and not(. = 'default:RTL')">
          <xsl:message>
            <xsl:text>Incorrect </xsl:text>
            <xsl:value-of select="@xml:lang"/>
            <xsl:text> translation of </xsl:text>
            <xsl:value-of select="$msg/@id"/>
          </xsl:message>
        </xsl:if>
      </xsl:for-each>
    </xsl:if>
    <xsl:if test="$msg/@id = 'Other Credits'">
      <xsl:for-each select="$xml_out/msg:l10n/msg:msg[@id = $msg/@id]/msg:msgstr">
        <xsl:if test="contains(., '@')">
          <xsl:message>
            <xsl:text>Probably incorrect </xsl:text>
            <xsl:value-of select="@xml:lang"/>
            <xsl:text> translation of </xsl:text>
            <xsl:value-of select="$msg/@id"/>
          </xsl:message>
        </xsl:if>
      </xsl:for-each>
    </xsl:if>
  </xsl:for-each>
</xsl:template>

</xsl:stylesheet>
