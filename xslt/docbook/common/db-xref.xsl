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
                xmlns:set="http://exslt.org/sets"
                xmlns:xl="http://www.w3.org/1999/xlink"
                xmlns:db="http://docbook.org/ns/docbook"
                exclude-result-prefixes="db xl set"
                version="1.0">

<!--!!==========================================================================
DocBook Cross References
:Requires: db-chunk db-label db-title gettext
-->


<!--**==========================================================================
db.ulink.tooltip
Generates the tooltip for an external link
$node: The element to generate a tooltip for
$url: The URL of the link, usually from the #{url} attribute
-->
<xsl:template name="db.ulink.tooltip">
  <xsl:param name="node" select="."/>
  <xsl:param name="url" select="$node/@url | $node/@xl:href"/>
  <xsl:choose>
    <xsl:when test="starts-with($url, 'mailto:')">
      <xsl:variable name="addy" select="substring-after($url, 'mailto:')"/>
      <xsl:call-template name="l10n.gettext">
        <xsl:with-param name="msgid" select="'email.tooltip'"/>
        <xsl:with-param name="string" select="$addy"/>
        <xsl:with-param name="format" select="true()"/>
      </xsl:call-template>
    </xsl:when>
    <xsl:otherwise>
      <xsl:value-of select="normalize-space($url)"/>
    </xsl:otherwise>
  </xsl:choose>
</xsl:template>


<!--**==========================================================================
db.xref.content
Generates the content of a cross reference
$linkend: The id of the linked-to element, usually from the #{linkend} attribute
$target: The linked-to element
$xrefstyle: The cross reference style, usually from the #{xrefstyle} attribute
$role: For a role-based ${xrefstyle}, the role of the cross reference

REMARK: The xrefstyle/role stuff needs to be documented
-->
<xsl:template name="db.xref.content">
  <xsl:param name="linkend" select="@linkend"/>
  <xsl:param name="target" select="key('idkey', $linkend)"/>
  <xsl:param name="xrefstyle" select="@xrefstyle"/>
  <xsl:param name="role" select="substring-after($xrefstyle, 'role:')"/>
  <xsl:choose>
    <!-- FIXME: should we prefer xrefstyle over xreflabel? -->
    <xsl:when test="$target/@xreflabel">
      <xsl:value-of select="$target/@xreflabel"/>
    </xsl:when>
    <xsl:when test="$xrefstyle = 'role:title'">
      <xsl:call-template name="db.title">
        <xsl:with-param name="node" select="$target"/>
      </xsl:call-template>
    </xsl:when>
    <xsl:when test="$xrefstyle = 'role:titleabbrev'">
      <xsl:call-template name="db.titleabbrev">
        <xsl:with-param name="node" select="$target"/>
      </xsl:call-template>
    </xsl:when>
    <xsl:when test="$xrefstyle = 'role:subtitle'">
      <xsl:call-template name="db.subtitle">
        <xsl:with-param name="node" select="$target"/>
      </xsl:call-template>
    </xsl:when>
    <xsl:when test="$xrefstyle = 'role:label'">
      <xsl:call-template name="db.label">
        <xsl:with-param name="node" select="$target"/>
      </xsl:call-template>
    </xsl:when>
    <xsl:when test="$xrefstyle = 'role:number'">
      <xsl:call-template name="db.number">
        <xsl:with-param name="node" select="$target"/>
      </xsl:call-template>
    </xsl:when>
    <xsl:otherwise>
      <xsl:apply-templates mode="db.xref.content.mode" select="$target">
        <xsl:with-param name="xrefstyle" select="$xrefstyle"/>
        <xsl:with-param name="role" select="$role"/>
      </xsl:apply-templates>
    </xsl:otherwise>
  </xsl:choose>
</xsl:template>


<!--%%==========================================================================
db.xref.content.mode
FIXME
$xrefstyle: The cross reference style, usually from the #{xrefstyle} attribute
$role: For a role-based ${xrefstyle}, the role of the cross reference

REMARK: Document this mode
-->
<xsl:template mode="db.xref.content.mode" match="*">
  <xsl:variable name="target_chunk_id">
    <xsl:call-template name="db.chunk.chunk-id">
      <xsl:with-param name="node" select="."/>
    </xsl:call-template>
  </xsl:variable>
  <xsl:variable name="target_chunk" select="key('idkey', $target_chunk_id)"/>
  <xsl:choose>
    <xsl:when test="$target_chunk">
      <xsl:apply-templates mode="db.xref.content.mode" select="$target_chunk"/>
    </xsl:when>
    <xsl:otherwise>
      <xsl:message>
        <xsl:text>No cross reference formatter found for </xsl:text>
        <xsl:value-of select="local-name(.)"/>
        <xsl:text> elements</xsl:text>
      </xsl:message>
      <xsl:variable name="title">
        <xsl:call-template name="db.title"/>
      </xsl:variable>
      <xsl:choose>
        <xsl:when test="string($title) != ''">
          <xsl:copy-of select="$title"/>
        </xsl:when>
        <xsl:otherwise>
          <xsl:value-of select="@id | @xml:id"/>
        </xsl:otherwise>
      </xsl:choose>
    </xsl:otherwise>
  </xsl:choose>
</xsl:template>

<!-- = db.xref.content.mode % appendix = -->
<xsl:template mode="db.xref.content.mode" match="appendix | db:appendix">
  <xsl:param name="xrefstyle"/>
  <xsl:param name="role" select="substring-after($xrefstyle, 'role:')"/>
  <xsl:call-template name="l10n.gettext">
    <xsl:with-param name="msgid" select="'appendix.xref'"/>
    <xsl:with-param name="role" select="$role"/>
    <xsl:with-param name="node" select="."/>
    <xsl:with-param name="format" select="true()"/>
  </xsl:call-template>
</xsl:template>

<!-- = db.xref.content.mode % biblioentry = -->
<xsl:template mode="db.xref.content.mode" match="biblioentry | db:biblioentry">
  <xsl:call-template name="db.label">
    <xsl:with-param name="node" select="."/>
  </xsl:call-template>
</xsl:template>

<!-- = db.xref.content.mode % bibliography = -->
<xsl:template mode="db.xref.content.mode" match="bibliography | db:bibliography">
  <xsl:param name="xrefstyle"/>
  <xsl:param name="role" select="substring-after($xrefstyle, 'role:')"/>
  <xsl:call-template name="l10n.gettext">
    <xsl:with-param name="msgid" select="'bibliography.xref'"/>
    <xsl:with-param name="role" select="$role"/>
    <xsl:with-param name="node" select="."/>
    <xsl:with-param name="format" select="true()"/>
  </xsl:call-template>
</xsl:template>

<!-- = db.xref.content.mode % bibliomixed = -->
<xsl:template mode="db.xref.content.mode" match="bibliomixed | db:bibliomixed">
  <xsl:call-template name="db.label">
    <xsl:with-param name="node" select="."/>
  </xsl:call-template>
</xsl:template>

<!-- = db.xref.content.mode % book = -->
<xsl:template mode="db.xref.content.mode" match="book | db:book">
  <xsl:param name="xrefstyle"/>
  <xsl:param name="role" select="substring-after($xrefstyle, 'role:')"/>
  <xsl:call-template name="l10n.gettext">
    <xsl:with-param name="msgid" select="'book.xref'"/>
    <xsl:with-param name="role" select="$role"/>
    <xsl:with-param name="node" select="."/>
    <xsl:with-param name="format" select="true()"/>
  </xsl:call-template>
</xsl:template>

<!-- = db.xref.content.mode % chapter = -->
<xsl:template mode="db.xref.content.mode" match="chapter | db:chapter">
  <xsl:param name="xrefstyle"/>
  <xsl:param name="role" select="substring-after($xrefstyle, 'role:')"/>
  <xsl:call-template name="l10n.gettext">
    <xsl:with-param name="msgid" select="'chapter.xref'"/>
    <xsl:with-param name="role" select="$role"/>
    <xsl:with-param name="node" select="."/>
    <xsl:with-param name="format" select="true()"/>
  </xsl:call-template>
</xsl:template>

<!-- = db.xref.content.mode % example = -->
<xsl:template mode="db.xref.content.mode" match="example | db:example">
  <xsl:param name="xrefstyle"/>
  <xsl:param name="role" select="substring-after($xrefstyle, 'role:')"/>
  <xsl:call-template name="l10n.gettext">
    <xsl:with-param name="msgid" select="'example.xref'"/>
    <xsl:with-param name="role" select="$role"/>
    <xsl:with-param name="node" select="."/>
    <xsl:with-param name="format" select="true()"/>
  </xsl:call-template>
</xsl:template>

<!-- = db.xref.content.mode % figure = -->
<xsl:template mode="db.xref.content.mode" match="figure | db:figure">
  <xsl:param name="xrefstyle"/>
  <xsl:param name="role" select="substring-after($xrefstyle, 'role:')"/>
  <xsl:call-template name="l10n.gettext">
    <xsl:with-param name="msgid" select="'figure.xref'"/>
    <xsl:with-param name="role" select="$role"/>
    <xsl:with-param name="node" select="."/>
    <xsl:with-param name="format" select="true()"/>
  </xsl:call-template>
</xsl:template>

<!-- = db.xref.content.mode % glossary = -->
<xsl:template mode="db.xref.content.mode" match="glossary | db:glossary">
  <xsl:param name="xrefstyle"/>
  <xsl:param name="role" select="substring-after($xrefstyle, 'role:')"/>
  <xsl:call-template name="l10n.gettext">
    <xsl:with-param name="msgid" select="'glossary.xref'"/>
    <xsl:with-param name="role" select="$role"/>
    <xsl:with-param name="node" select="."/>
    <xsl:with-param name="format" select="true()"/>
  </xsl:call-template>
</xsl:template>

<!-- = db.xref.content.mode % glossentry = -->
<xsl:template mode="db.xref.content.mode" match="glossentry | db:glossentry">
  <xsl:param name="xrefstyle"/>
  <xsl:param name="role" select="substring-after($xrefstyle, 'role:')"/>
  <xsl:call-template name="l10n.gettext">
    <xsl:with-param name="msgid" select="'glossentry.xref'"/>
    <xsl:with-param name="role" select="$role"/>
    <xsl:with-param name="node" select="."/>
    <xsl:with-param name="format" select="true()"/>
  </xsl:call-template>
</xsl:template>

<!-- = db.xref.content.mode % part = -->
<xsl:template mode="db.xref.content.mode" match="part | db:part">
  <xsl:param name="xrefstyle"/>
  <xsl:param name="role" select="substring-after($xrefstyle, 'role:')"/>
  <xsl:call-template name="l10n.gettext">
    <xsl:with-param name="msgid" select="'part.xref'"/>
    <xsl:with-param name="role" select="$role"/>
    <xsl:with-param name="node" select="."/>
    <xsl:with-param name="format" select="true()"/>
  </xsl:call-template>
</xsl:template>

<!-- = db.xref.content.mode % preface = -->
<xsl:template mode="db.xref.content.mode" match="preface | db:preface">
  <xsl:param name="xrefstyle"/>
  <xsl:param name="role" select="substring-after($xrefstyle, 'role:')"/>
  <xsl:call-template name="l10n.gettext">
    <xsl:with-param name="msgid" select="'preface.xref'"/>
    <xsl:with-param name="role" select="$role"/>
    <xsl:with-param name="node" select="."/>
    <xsl:with-param name="format" select="true()"/>
  </xsl:call-template>
</xsl:template>

<!-- = db.xref.content.mode % qandaentry = -->
<xsl:template mode="db.xref.content.mode" match="qandaentry | db:qandaentry">
  <xsl:param name="xrefstyle"/>
  <xsl:param name="role" select="substring-after($xrefstyle, 'role:')"/>
  <xsl:apply-templates mode="db.xref.content.mode" select="question">
    <xsl:with-param name="xrefstyle" select="$xrefstyle"/>
    <xsl:with-param name="role" select="$role"/>
  </xsl:apply-templates>
</xsl:template>

<!-- = db.xref.content.mode % question = -->
<xsl:template mode="db.xref.content.mode" match="question | db:question">
  <xsl:param name="xrefstyle"/>
  <xsl:param name="role" select="substring-after($xrefstyle, 'role:')"/>
  <xsl:call-template name="l10n.gettext">
    <xsl:with-param name="msgid" select="'question.xref'"/>
    <xsl:with-param name="role" select="$role"/>
    <xsl:with-param name="node" select="."/>
    <xsl:with-param name="format" select="true()"/>
  </xsl:call-template>
</xsl:template>

<!-- = db.xref.content.mode % refentry = -->
<xsl:template mode="db.xref.content.mode" match="refentry | db:refentry">
  <xsl:param name="xrefstyle"/>
  <xsl:param name="role" select="substring-after($xrefstyle, 'role:')"/>
  <xsl:call-template name="l10n.gettext">
    <xsl:with-param name="msgid" select="'refentry.xref'"/>
    <xsl:with-param name="role" select="$role"/>
    <xsl:with-param name="node" select="."/>
    <xsl:with-param name="format" select="true()"/>
  </xsl:call-template>
</xsl:template>

<!-- = db.xref.content.mode % refsection = -->
<xsl:template mode="db.xref.content.mode" match="
              refsection    | refsect1    | refsect2    | refsect3 |
              db:refsection | db:refsect1 | db:refsect2 | db:refsect3  ">
  <xsl:param name="xrefstyle"/>
  <xsl:param name="role" select="substring-after($xrefstyle, 'role:')"/>
  <xsl:call-template name="l10n.gettext">
    <xsl:with-param name="msgid" select="'refsection.xref'"/>
    <xsl:with-param name="role" select="$role"/>
    <xsl:with-param name="node" select="."/>
    <xsl:with-param name="format" select="true()"/>
  </xsl:call-template>
</xsl:template>

<!-- = db.xref.content.mode % refsynopsisdiv = -->
<xsl:template mode="db.xref.content.mode" match="refsynopsisdiv |
                                                 db:refsynopsisdiv">
  <xsl:call-template name="db.title"/>
</xsl:template>

<!-- = db.xref.content.mode % section = -->
<xsl:template mode="db.xref.content.mode" match="
              section | sect1 | sect2 | sect3 | sect4 | sect5 | simplesect |
              db:section | db:sect1 | db:sect2 | db:sect3 | db:sect4 |
              db:sect5 | db:simplesect">
  <xsl:param name="xrefstyle"/>
  <xsl:param name="role" select="substring-after($xrefstyle, 'role:')"/>
  <xsl:call-template name="l10n.gettext">
    <xsl:with-param name="msgid" select="'section.xref'"/>
    <xsl:with-param name="role" select="$role"/>
    <xsl:with-param name="node" select="."/>
    <xsl:with-param name="format" select="true()"/>
  </xsl:call-template>
</xsl:template>

<!-- = db.xref.content.mode % synopfragment = -->
<xsl:template mode="db.xref.content.mode" match="synopfragment |
                                                 db:synopfragment">
  <xsl:param name="xrefstyle"/>
  <xsl:call-template name="l10n.gettext">
    <xsl:with-param name="msgid" select="'synopfragment.label'"/>
    <xsl:with-param name="node" select="."/>
    <xsl:with-param name="format" select="true()"/>
  </xsl:call-template>
</xsl:template>

<!-- = db.xref.content.mode % table = -->
<xsl:template mode="db.xref.content.mode" match="table | db:table">
  <xsl:param name="xrefstyle"/>
  <xsl:param name="role" select="substring-after($xrefstyle, 'role:')"/>
  <xsl:call-template name="l10n.gettext">
    <xsl:with-param name="msgid" select="'table.xref'"/>
    <xsl:with-param name="role" select="$role"/>
    <xsl:with-param name="node" select="."/>
    <xsl:with-param name="format" select="true()"/>
  </xsl:call-template>
</xsl:template>


<!--**==========================================================================
db.xref.target
Generates the target identifier of a cross reference
$linkend: The id of the linked-to element, usually from the #{linkend} attribute
$target: The linked-to element
$is_chunk: Whether ${target} is known to be a chunked element

REMARK: Talk about how this works with chunking
-->
<xsl:template name="db.xref.target">
  <xsl:param name="linkend" select="@linkend"/>
  <xsl:param name="target" select="key('idkey', $linkend)"/>
  <xsl:param name="is_chunk" select="false()"/>
  <xsl:choose>
    <xsl:when test="$linkend = $db.chunk.info_basename">
      <xsl:value-of
       select="concat($db.chunk.info_basename, $db.chunk.extension)"/>
    </xsl:when>
    <xsl:when test="set:has-same-node($target, /*)">
      <xsl:value-of select="concat($db.chunk.basename, $db.chunk.extension)"/>
    </xsl:when>
    <xsl:when test="$is_chunk">
      <xsl:value-of select="concat($linkend, $db.chunk.extension)"/>
    </xsl:when>
    <xsl:otherwise>
      <xsl:variable name="target_chunk_id">
        <xsl:call-template name="db.chunk.chunk-id">
          <xsl:with-param name="node" select="$target"/>
        </xsl:call-template>
      </xsl:variable>
      <xsl:value-of select="concat($target_chunk_id, $db.chunk.extension)"/>
      <xsl:if test="string($linkend) != '' and string($target_chunk_id) != string($linkend)">
        <xsl:value-of select="concat('#', $linkend)"/>
      </xsl:if>
    </xsl:otherwise>
  </xsl:choose>
</xsl:template>


<!--**==========================================================================
db.xref.tooltip
Generates the tooltip for a cross reference
$linkend: The id of the linked-to element, usually from the #{linkend} attribute
$target: The linked-to element

REMARK: Document this
-->
<xsl:template name="db.xref.tooltip">
  <xsl:param name="linkend" select="@linkend"/>
  <xsl:param name="target" select="key('idkey', $linkend)"/>
  <xsl:apply-templates mode="db.xref.tooltip.mode" select="$target"/>
</xsl:template>


<!--%%==========================================================================
db.xref.tooltip.mode
FIXME

REMARK: Document this
-->
<xsl:template mode="db.xref.tooltip.mode" match="*">
  <xsl:call-template name="db.title">
    <xsl:with-param name="node" select="."/>
  </xsl:call-template>
</xsl:template>

<!-- = db.xref.tooltip.mode % biblioentry | bibliomixed = -->
<xsl:template mode="db.xref.tooltip.mode" match="biblioentry | bibliomixed |
                                                 db:biblioentry | db:bibliomixed">
  <xsl:call-template name="l10n.gettext">
    <xsl:with-param name="msgid" select="'biblioentry.tooltip'"/>
    <xsl:with-param name="node" select="."/>
    <xsl:with-param name="format" select="true()"/>
  </xsl:call-template>
</xsl:template>

<!-- = db.xref.tooltip.mode % glossentry = -->
<xsl:template mode="db.xref.tooltip.mode" match="glossentry | db:glossentry">
  <xsl:call-template name="l10n.gettext">
    <xsl:with-param name="msgid" select="'glossentry.tooltip'"/>
    <xsl:with-param name="node" select="."/>
    <xsl:with-param name="format" select="true()"/>
  </xsl:call-template>
</xsl:template>

</xsl:stylesheet>
