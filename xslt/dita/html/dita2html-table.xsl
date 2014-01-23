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
DITA to HTML - Tables

REMARK: Describe this module
-->


<!-- = simpletable = -->
<xsl:template mode="dita2html.topic.mode" match="&topic_simpletable;">
  <xsl:variable name="conref" select="yelp:dita.ref.conref(.)"/>
  <xsl:variable name="keycol" select="@keycol"/>
  <div>
    <xsl:call-template name="dita.id"/>
    <xsl:call-template name="html.lang.attrs"/>
    <xsl:call-template name="html.class.attr">
      <xsl:with-param name="class" select="'table'"/>
    </xsl:call-template>
    <table class="table">
      <xsl:for-each select="$conref/&topic_sthead;[1]">
        <thead>
          <xsl:call-template name="dita2html.table.simpletable.row">
            <xsl:with-param name="keycol" select="$keycol"/>
          </xsl:call-template>
        </thead>
      </xsl:for-each>
      <tbody>
        <xsl:for-each select="$conref/&topic_strow;">
          <xsl:call-template name="dita2html.table.simpletable.row">
            <xsl:with-param name="keycol" select="$keycol"/>
          </xsl:call-template>
        </xsl:for-each>
      </tbody>
    </table>
  </div>
</xsl:template>

<xsl:template name="dita2html.table.simpletable.row">
  <xsl:param name="node" select="."/>
  <xsl:param name="keycol"/>
  <xsl:variable name="conref" select="yelp:dita.ref.conref($node)"/>
  <tr>
    <xsl:call-template name="dita.id">
      <xsl:with-param name="node" select="$node"/>
    </xsl:call-template>
    <xsl:call-template name="html.lang.attrs">
      <xsl:with-param name="node" select="$node"/>
    </xsl:call-template>
    <xsl:call-template name="html.class.attr">
      <xsl:with-param name="node" select="$node"/>
    </xsl:call-template>
    <xsl:for-each select="$conref/&topic_stentry;">
      <xsl:choose>
        <xsl:when test="position() = $keycol or $node[self::&topic_sthead;]">
          <th>
            <xsl:call-template name="dita.id"/>
            <xsl:call-template name="html.lang.attrs"/>
            <xsl:apply-templates mode="dita2html.topic.mode"
                                 select="yelp:dita.ref.conref(.)/node()"/>
          </th>
        </xsl:when>
        <xsl:otherwise>
          <td>
            <xsl:call-template name="dita.id"/>
            <xsl:call-template name="html.lang.attrs"/>
            <xsl:apply-templates mode="dita2html.topic.mode"
                                 select="yelp:dita.ref.conref(.)/node()"/>
          </td>
        </xsl:otherwise>
      </xsl:choose>
    </xsl:for-each>
  </tr>
</xsl:template>

</xsl:stylesheet>
