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
                xmlns="http://www.w3.org/1999/xhtml"
                exclude-result-prefixes="mal"
                version="1.0">

<!--!!==========================================================================
Mallard to HTML - List Elements

REMARK: Describe this module
-->

<!-- = list = -->
<xsl:template mode="mal2html.block.mode" match="mal:list">
  <xsl:variable name="style" select="concat(' ', @style, ' ')"/>
  <xsl:variable name="el">
    <xsl:choose>
      <xsl:when test="not(@type) or (@type = 'none') or (@type = 'box')
                      or (@type = 'check') or (@type = 'circle') or (@type = 'diamond')
                      or (@type = 'disc') or (@type = 'hyphen') or (@type = 'square')">
        <xsl:text>ul</xsl:text>
      </xsl:when>
      <xsl:otherwise>
        <xsl:text>ol</xsl:text>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:variable>
  <div class="list">
    <xsl:call-template name="html.lang.attrs"/>
    <xsl:apply-templates mode="mal2html.block.mode" select="mal:title"/>
    <xsl:element name="{$el}" namespace="{$html.namespace}">
      <xsl:attribute name="class">
        <xsl:text>list</xsl:text>
        <xsl:if test="contains($style, ' compact ')">
          <xsl:text> compact</xsl:text>
        </xsl:if>
      </xsl:attribute>
      <xsl:if test="@type">
        <xsl:attribute name="style">
          <xsl:value-of select="concat('list-style-type:', @type)"/>
        </xsl:attribute>
      </xsl:if>
      <xsl:apply-templates select="mal:item"/>
    </xsl:element>
  </div>
</xsl:template>

<!-- = list/item = -->
<xsl:template match="mal:list/mal:item">
  <li class="list">
    <xsl:call-template name="html.lang.attrs"/>
    <xsl:apply-templates mode="mal2html.block.mode"/>
  </li>
</xsl:template>

<!-- = steps = -->
<xsl:template mode="mal2html.block.mode" match="mal:steps">
  <div class="steps">
    <xsl:call-template name="html.lang.attrs"/>
    <xsl:apply-templates mode="mal2html.block.mode" select="mal:title"/>
    <ol class="steps">
      <xsl:apply-templates select="mal:item"/>
    </ol>
  </div>
</xsl:template>

<!-- = steps/item = -->
<xsl:template match="mal:steps/mal:item">
  <li class="steps">
    <xsl:call-template name="html.lang.attrs"/>
    <xsl:apply-templates mode="mal2html.block.mode"/>
  </li>
</xsl:template>

<!-- = terms = -->
<xsl:template mode="mal2html.block.mode" match="mal:terms">
  <xsl:variable name="style" select="concat(' ', @style, ' ')"/>
  <div class="terms">
    <xsl:call-template name="html.lang.attrs"/>
    <xsl:apply-templates mode="mal2html.block.mode" select="mal:title"/>
    <dl class="terms">
      <xsl:attribute name="class">
        <xsl:text>terms</xsl:text>
        <xsl:if test="contains($style, ' compact ')">
          <xsl:text> compact</xsl:text>
        </xsl:if>
      </xsl:attribute>
      <xsl:apply-templates select="mal:item"/>
    </dl>
  </div>
</xsl:template>

<!-- = terms/item = -->
<xsl:template match="mal:terms/mal:item">
  <xsl:for-each select="mal:title">
    <dt class="terms">
      <xsl:call-template name="html.lang.attrs">
        <xsl:with-param name="parent" select=".."/>
      </xsl:call-template>
      <xsl:apply-templates mode="mal2html.inline.mode"/>
    </dt>
  </xsl:for-each>
  <dd class="terms">
    <xsl:call-template name="html.lang.attrs"/>
    <xsl:apply-templates mode="mal2html.block.mode" select="*[not(self::mal:title)]"/>
  </dd>
</xsl:template>

<!-- = tree = -->
<xsl:template mode="mal2html.block.mode" match="mal:tree">
  <xsl:variable name="lines" select="contains(concat(' ', @style, ' '), ' lines ')"/>
  <div>
    <xsl:call-template name="html.lang.attrs"/>
    <xsl:attribute name="class">
      <xsl:text>tree</xsl:text>
      <xsl:if test="$lines">
        <xsl:text> tree-lines</xsl:text>
      </xsl:if>
    </xsl:attribute>
    <ul class="tree">
      <xsl:apply-templates mode="mal2html.tree.mode" select="mal:item">
        <xsl:with-param name="lines" select="$lines"/>
      </xsl:apply-templates>
    </ul>
  </div>
</xsl:template>

<!-- = tree/item = -->
<xsl:template mode="mal2html.tree.mode" match="mal:item">
  <xsl:param name="lines" select="false()"/>
  <xsl:param name="prefix" select="''"/>
  <li class="tree">
    <xsl:call-template name="html.lang.attrs"/>
    <div>
      <xsl:if test="$lines">
        <xsl:value-of select="$prefix"/>
        <xsl:text> </xsl:text>
      </xsl:if>
      <xsl:apply-templates mode="mal2html.inline.mode"
                           select="node()[not(self::mal:item)]"/>
    </div>
    <xsl:if test="mal:item">
      <ul class="tree">
        <xsl:for-each select="mal:item">
          <xsl:apply-templates mode="mal2html.tree.mode" select=".">
            <xsl:with-param name="lines" select="$lines"/>
            <xsl:with-param name="prefix">
              <xsl:if test="$lines">
                <xsl:variable name="dir">
                  <xsl:call-template name="l10n.direction">
                    <xsl:with-param name="lang" select="ancestor-or-self::*[@xml:lang][1]/@xml:lang"/>
                  </xsl:call-template>
                </xsl:variable>
                <xsl:value-of select="translate(translate(translate(translate(
                                      $prefix,
                                      '&#x251C;', '&#x2502;'),
                                      '&#x2524;', '&#x2502;'),
                                      '&#x2514;', '&#x202F;'),
                                      '&#x2518;', '&#x202F;')"/>
                <xsl:text>&#x202F;&#x202F;&#x202F;&#x202F;</xsl:text>
                <xsl:choose>
                  <xsl:when test="following-sibling::mal:item">
                    <xsl:choose>
                      <xsl:when test="$dir = 'rtl'">
                        <xsl:text>&#x2524;</xsl:text>
                      </xsl:when>
                      <xsl:otherwise>
                        <xsl:text>&#x251C;</xsl:text>
                      </xsl:otherwise>
                    </xsl:choose>
                  </xsl:when>
                  <xsl:otherwise>
                    <xsl:choose>
                      <xsl:when test="$dir = 'rtl'">
                        <xsl:text>&#x2518;</xsl:text>
                      </xsl:when>
                      <xsl:otherwise>
                        <xsl:text>&#x2514;</xsl:text>
                      </xsl:otherwise>
                    </xsl:choose>
                  </xsl:otherwise>
                </xsl:choose>
              </xsl:if>
            </xsl:with-param>
          </xsl:apply-templates>
        </xsl:for-each>
      </ul>
    </xsl:if>
  </li>
</xsl:template>

</xsl:stylesheet>
