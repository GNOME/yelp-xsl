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
                xmlns:msg="http://www.gnome.org/~shaunm/gnome-doc-utils/l10n"
                xmlns:set="http://exslt.org/sets"
                xmlns:db="http://docbook.org/ns/docbook"
                exclude-result-prefixes="db msg set"
                version="1.0">

<!--!!==========================================================================
DocBook Labels
:Requires: db-chunk db-title gettext

REMARK: Explain labels
-->


<!--**==========================================================================
db.label
Generates the label for an element
$node: The node to generate a label for
$role: The role of the label, as passed to the format template

This template generates the label used for some sectioning and block-level
elements.  For instance, this would generate strings such as Section 14.3
or Table 5-2.  The template simply applies the mode %{db.label.mode} to the
element.  To change the behavior of a particular type of element, you should
always override the mode template for that element.

Overriding the *{db.label} template should only be done if you wish to change
the labelling mechanism completely, or if you wish to wrap the labelling
mechanism (for instance, with a caching extension).  Do not override this
template to suppress label prefixes in titles.

REMARK: Do not, but instead?
-->
<xsl:template name="db.label">
  <xsl:param name="node" select="."/>
  <xsl:param name="role"/>
  <xsl:choose>
    <xsl:when test="$node/@label">
      <xsl:value-of select="$node/@label"/>
    </xsl:when>
    <xsl:otherwise>
      <xsl:apply-templates mode="db.label.mode" select="$node">
        <xsl:with-param name="role" select="$role"/>
      </xsl:apply-templates>
    </xsl:otherwise>
  </xsl:choose>
</xsl:template>


<!--%%==========================================================================
db.label.mode
$role: The role of the label, as passed to the format template
FIXME

REMARK: Document this mode, and the role param
-->

<!-- = db.label.mode % answer = -->
<xsl:template mode="db.label.mode" match="answer | db:answer">
  <xsl:param name="role"/>
  <xsl:variable name="qandaset" select="ancestor::qandaset[1] |
                                        ancestor::db:qandaset[1]"/>
  <xsl:if test="$qandaset/@defaultlabel = 'qanda'">
    <xsl:call-template name="l10n.gettext">
      <xsl:with-param name="msgid" select="'A:'"/>
    </xsl:call-template>
  </xsl:if>
</xsl:template>

<!-- = db.label.mode % appendix = -->
<xsl:template mode="db.label.mode" match="appendix | db:appendix">
  <xsl:param name="role"/>
  <xsl:call-template name="l10n.gettext">
    <xsl:with-param name="msgid" select="'appendix.label'"/>
    <xsl:with-param name="role" select="$role"/>
    <xsl:with-param name="node" select="."/>
    <xsl:with-param name="format" select="true()"/>
  </xsl:call-template>
</xsl:template>

<!-- = db.label.mode % bibliography = -->
<xsl:template mode="db.label.mode" match="bibliography | db:bibliography"/>

<!-- = db.label.mode % biblioentry | bibliomixed = -->
<xsl:template mode="db.label.mode" match="biblioentry    | bibliomixed |
                                          db:biblioentry | db:bibliomixed">
  <xsl:if test="*[1]/self::abbrev    | @xreflabel | @id |
                *[1]/self::db:abbrev | @xml:id">
    <!-- FIXME: I18N -->
    <xsl:text>[</xsl:text>
    <xsl:choose>
      <xsl:when test="*[1]/self::abbrev">
        <xsl:apply-templates select="abbrev[1]"/>
      </xsl:when>
      <xsl:when test="*[1]/self::db:abbrev">
        <xsl:apply-templates select="db:abbrev[1]"/>
      </xsl:when>
      <xsl:when test="@xreflabel">
        <xsl:value-of select="@xreflabel"/>
      </xsl:when>
      <xsl:when test="@id">
        <xsl:value-of select="@id"/>
      </xsl:when>
      <xsl:when test="@xml:id">
        <xsl:value-of select="@xml:id"/>
      </xsl:when>
    </xsl:choose>
    <xsl:text>]</xsl:text>
  </xsl:if>
</xsl:template>

<!-- = db.label.mode % book = -->
<xsl:template mode="db.label.mode" match="book | db:book">
  <xsl:param name="role"/>
  <xsl:call-template name="l10n.gettext">
    <xsl:with-param name="msgid" select="'book.label'"/>
    <xsl:with-param name="role" select="$role"/>
    <xsl:with-param name="node" select="."/>
    <xsl:with-param name="format" select="true()"/>
  </xsl:call-template>
</xsl:template>

<!-- = db.label.mode % chapter = -->
<xsl:template mode="db.label.mode" match="chapter | db:chapter">
  <xsl:param name="role"/>
  <xsl:call-template name="l10n.gettext">
    <xsl:with-param name="msgid" select="'chapter.label'"/>
    <xsl:with-param name="role" select="$role"/>
    <xsl:with-param name="node" select="."/>
    <xsl:with-param name="format" select="true()"/>
  </xsl:call-template>
</xsl:template>

<!-- = db.label.mode % example = -->
<xsl:template mode="db.label.mode" match="example | db:example">
  <xsl:param name="role"/>
  <xsl:call-template name="l10n.gettext">
    <xsl:with-param name="msgid" select="'example.label'"/>
    <xsl:with-param name="role" select="$role"/>
    <xsl:with-param name="node" select="."/>
    <xsl:with-param name="format" select="true()"/>
  </xsl:call-template>
</xsl:template>

<!-- = db.label.mode % figure = -->
<xsl:template mode="db.label.mode" match="figure | db:figure">
  <xsl:param name="role"/>
  <xsl:call-template name="l10n.gettext">
    <xsl:with-param name="msgid" select="'figure.label'"/>
    <xsl:with-param name="role" select="$role"/>
    <xsl:with-param name="node" select="."/>
    <xsl:with-param name="format" select="true()"/>
  </xsl:call-template>
</xsl:template>

<!-- = db.label.mode % glossary = -->
<xsl:template mode="db.label.mode" match="glossary | db:glossary"/>

<!-- = db.label.mode % part = -->
<xsl:template mode="db.label.mode" match="part | db:part">
  <xsl:param name="role"/>
  <xsl:call-template name="l10n.gettext">
    <xsl:with-param name="msgid" select="'part.label'"/>
    <xsl:with-param name="role" select="$role"/>
    <xsl:with-param name="node" select="."/>
    <xsl:with-param name="format" select="true()"/>
  </xsl:call-template>
</xsl:template>

<!-- = db.label.mode % preface = -->
<xsl:template mode="db.label.mode" match="preface | db:preface"/>

<!-- = db.label.mode % question = -->
<xsl:template mode="db.label.mode" match="question | db:question">
  <xsl:param name="role"/>
  <xsl:variable name="qandaset" select="ancestor::qandaset[1] |
                                        ancestor::db:qandaset[1]"/>
  <xsl:choose>
    <xsl:when test="label | db:label">
      <xsl:apply-templates select="label/node() | db:label/node()"/>
    </xsl:when>
    <xsl:when test="$qandaset/@defaultlabel = 'none'"/>
    <xsl:when test="$qandaset/@defaultlabel = 'qanda'">
      <xsl:call-template name="l10n.gettext">
        <xsl:with-param name="msgid" select="'Q:'"/>
      </xsl:call-template>
    </xsl:when>
    <xsl:otherwise>
      <xsl:call-template name="l10n.gettext">
        <xsl:with-param name="msgid" select="'question.label'"/>
        <xsl:with-param name="role" select="$role"/>
        <xsl:with-param name="node" select="."/>
        <xsl:with-param name="format" select="true()"/>
      </xsl:call-template>
    </xsl:otherwise>
  </xsl:choose>
</xsl:template>

<!-- = db.label.mode % reference = -->
<xsl:template mode="db.label.mode" match="reference | db:reference"/>

<!-- = db.label.mode % refsection = -->
<xsl:template mode="db.label.mode"
              match="refsection    | refsect1    | refsect2    | refsect3 |
                     db:refsection | db:refsect1 | db:refsect2 | db:refsect3"/>

<!-- = db.label.mode % section = -->
<xsl:template mode="db.label.mode" match="
              section | sect1 | sect2 | sect3 | sect4 | sect5 | simplesect |
              db:section | db:sect1 | db:sect2 | db:sect3 | db:sect4 |
              db:sect5 | db:simplesect">
  <xsl:param name="role"/>
  <xsl:call-template name="l10n.gettext">
    <xsl:with-param name="msgid" select="'section.label'"/>
    <xsl:with-param name="role" select="$role"/>
    <xsl:with-param name="node" select="."/>
    <xsl:with-param name="format" select="true()"/>
  </xsl:call-template>
</xsl:template>

<!-- = db.label.mode % table = -->
<xsl:template mode="db.label.mode" match="table | db:table">
  <xsl:param name="role"/>
  <xsl:call-template name="l10n.gettext">
    <xsl:with-param name="msgid" select="'table.label'"/>
    <xsl:with-param name="role" select="$role"/>
    <xsl:with-param name="node" select="."/>
    <xsl:with-param name="format" select="true()"/>
  </xsl:call-template>
</xsl:template>

<!-- = db.label.mode % synopfragment = -->
<xsl:template mode="db.label.mode" match="synopfragment | db:synopfragment">
  <xsl:param name="role"/>
  <xsl:call-template name="l10n.gettext">
    <xsl:with-param name="msgid" select="'synopfragment.label'"/>
    <xsl:with-param name="role" select="$role"/>
    <xsl:with-param name="node" select="."/>
    <xsl:with-param name="format" select="true()"/>
  </xsl:call-template>
</xsl:template>

<xsl:template mode="db.label.mode" match="title | subtitle |
                                          db:title | db:subtitle">
  <xsl:param name="role"/>
  <xsl:call-template name="db.label">
    <xsl:with-param name="node" select=".."/>
  </xsl:call-template>
</xsl:template>

<xsl:template mode="db.label.mode" match="
              article  |
              colophon |    index     |
              qandadiv | qandaset |
              set      | setindex |
              db:article  |
              db:colophon |    db:index     |
              db:qandadiv | db:qandaset |
              db:set      | db:setindex ">
  <xsl:param name="role"/>
<!-- FIXME 
  <xsl:call-template name="db.label.name"/>
  <xsl:text> </xsl:text>
  <xsl:call-template name="db.label.number"/>
-->
</xsl:template>

<xsl:template mode="db.label.mode" match="
              appendixinfo | articleinfo  | bibliographyinfo | bookinfo     |
              chapterinfo  | glossaryinfo | indexinfo        | partinfo     |
              prefaceinfo  | refentryinfo | referenceinfo    | refsect1info |
              refsect2info | refsect3info | refsectioninfo   | sect1info    |
              sect2info    | sect3info    | sect4info        | sect5info    |
              sectioninfo  | setindexinfo | setinfo          | db:info">
  <xsl:param name="role"/>
  <xsl:call-template name="l10n.gettext">
    <xsl:with-param name="msgid" select="'About This Document'"/>
  </xsl:call-template>
<!-- FIXME 
  <xsl:call-template name="db.label.name"/>
-->
</xsl:template>

<xsl:template mode="db.label.mode" match="*"/>


<!--**==========================================================================
db.number
Generates the number portion of a label
$node: The element to generate a number for

This template generates the number portion of the label used for some sectioning
and block-level elements.  The template simply applies the mode %{db.number.mode}
to the element.  To change the behavior of a particular type of element, you
should always override the mode template for that type of element.

Overriding the *{db.number} template should only be done if you wish to change
the numbering mechanism completely, or you wish to wrap the numbering mechanism
(for example, with a caching extension).
-->
<xsl:template name="db.number">
  <xsl:param name="node" select="."/>
  <xsl:apply-templates mode="db.number.mode" select="$node"/>
</xsl:template>


<!--%%==========================================================================
db.number.mode
FIXME

REMARK: Document this mode
-->

<!-- = db.number.mode % appendix = -->
<xsl:template mode="db.number.mode" match="appendix | db:appendix">
  <xsl:choose>
    <xsl:when test="parent::part or parent::db:part">
      <xsl:call-template name="l10n.gettext">
        <xsl:with-param name="msgid" select="'appendix.number'"/>
        <xsl:with-param name="node" select="."/>
        <xsl:with-param name="format" select="true()"/>
      </xsl:call-template>
    </xsl:when>
    <xsl:otherwise>
      <xsl:call-template name="db.digit"/>
    </xsl:otherwise>
  </xsl:choose>
</xsl:template>

<!-- = db.number.mode % book = -->
<xsl:template mode="db.number.mode" match="book | db:book">
  <xsl:call-template name="db.digit"/>
</xsl:template>

<!-- = db.number.mode % chapter = -->
<xsl:template mode="db.number.mode" match="chapter | db:chapter">
  <xsl:choose>
    <xsl:when test="parent::part">
      <xsl:call-template name="l10n.gettext">
        <xsl:with-param name="msgid" select="'chapter.number'"/>
        <xsl:with-param name="node" select="."/>
        <xsl:with-param name="format" select="true()"/>
      </xsl:call-template>
    </xsl:when>
    <xsl:otherwise>
      <xsl:call-template name="db.digit"/>
    </xsl:otherwise>
  </xsl:choose>
</xsl:template>

<!-- = db.number.mode % example = -->
<xsl:template mode="db.number.mode" match="example | db:example">
  <xsl:choose>
    <xsl:when test="ancestor::appendix or ancestor::chapter or
                    ancestor::db:appendix or ancestor::db:chapter">
      <xsl:call-template name="l10n.gettext">
        <xsl:with-param name="msgid" select="'example.number'"/>
        <xsl:with-param name="node" select="."/>
        <xsl:with-param name="format" select="true()"/>
      </xsl:call-template>
    </xsl:when>
    <xsl:otherwise>
      <xsl:call-template name="db.digit"/>
    </xsl:otherwise>
  </xsl:choose>
</xsl:template>

<!-- = db.number.mode % figure = -->
<xsl:template mode="db.number.mode" match="figure | db:figure">
  <xsl:choose>
    <xsl:when test="ancestor::appendix or ancestor::chapter or
                    ancestor::db:appendix or ancestor::db:chapter">
      <xsl:call-template name="l10n.gettext">
        <xsl:with-param name="msgid" select="'figure.number'"/>
        <xsl:with-param name="node" select="."/>
        <xsl:with-param name="format" select="true()"/>
      </xsl:call-template>
    </xsl:when>
    <xsl:otherwise>
      <xsl:call-template name="db.digit"/>
    </xsl:otherwise>
  </xsl:choose>
</xsl:template>

<!-- = db.number.mode % footnote = -->
<xsl:template mode="db.number.mode" match="footnote | db:footnote">
  <xsl:variable name="depth_in_chunk">
    <xsl:call-template name="db.chunk.depth-in-chunk">
      <xsl:with-param name="node" select="."/>
    </xsl:call-template>
  </xsl:variable>
  <xsl:variable name="notes" select="preceding::footnote |
                                     preceding::db:footnote"/>
  <xsl:choose>
    <xsl:when test="count($notes) != 0">
      <xsl:call-template name="db.number.footnote.tally">
        <xsl:with-param name="chunk" select="ancestor::*[number($depth_in_chunk)]"/>
        <xsl:with-param name="notes" select="$notes"/>
        <xsl:with-param name="pos" select="1"/>
        <xsl:with-param name="count" select="1"/>
      </xsl:call-template>
    </xsl:when>
    <xsl:otherwise>
      <xsl:value-of select="1"/>
    </xsl:otherwise>
  </xsl:choose>
</xsl:template>

<!--#* db.number.footnote.tally -->
<xsl:template name="db.number.footnote.tally">
  <xsl:param name="chunk"/>
  <xsl:param name="notes"/>
  <xsl:param name="pos"/>
  <xsl:param name="count"/>
  <xsl:variable name="this" select="$notes[$pos]"/>
  <xsl:variable name="depth">
    <xsl:call-template name="db.chunk.depth-in-chunk">
      <xsl:with-param name="node" select="$this"/>
    </xsl:call-template>
  </xsl:variable>
  <xsl:variable name="increment"
                select="number(set:has-same-node($this/ancestor::*[number($depth)],
                                                 $chunk ))"/>
  <xsl:choose>
    <xsl:when test="$pos = count($notes)">
      <xsl:value-of select="$count + $increment"/>
    </xsl:when>
    <xsl:otherwise>
      <xsl:call-template name="db.number.footnote.tally">
        <xsl:with-param name="chunk" select="$chunk"/>
        <xsl:with-param name="notes" select="$notes"/>
        <xsl:with-param name="pos" select="$pos + 1"/>
        <xsl:with-param name="count" select="$count + $increment"/>
      </xsl:call-template>
    </xsl:otherwise>
  </xsl:choose>
</xsl:template>

<!-- = db.number.mode % glossary = -->
<xsl:template mode="db.number.mode" match="glossary | db:glossary"/>

<!-- = db.number.mode % part = -->
<xsl:template mode="db.number.mode" match="part | db:part">
  <xsl:call-template name="db.digit"/>
</xsl:template>

<!-- = db.number.mode % preface = -->
<xsl:template mode="db.number.mode" match="preface | db:preface"/>

<!-- = db.number.mode % question = -->
<xsl:template mode="db.number.mode" match="question | db:question">
  <xsl:call-template name="db.digit"/>
</xsl:template>

<!-- = db.number.mode % refsection = -->
<xsl:template mode="db.number.mode" match="
              refsection | refsect1 | refsect2 | refsect3 |
              db:refsection | db:refsect1 | db:refsect2 | db:refsect3">
  <xsl:choose>
    <xsl:when test="parent::refentry or parent::db:refentry">
      <xsl:call-template name="db.digit"/>
    </xsl:when>
    <xsl:otherwise>
      <xsl:call-template name="l10n.gettext">
        <xsl:with-param name="msgid" select="'refsection.number'"/>
        <xsl:with-param name="node" select="."/>
        <xsl:with-param name="format" select="true()"/>
      </xsl:call-template>
    </xsl:otherwise>
  </xsl:choose>
</xsl:template>

<!-- = db.number.mode % section = -->
<xsl:template mode="db.number.mode" match="
              section | sect1 | sect2 | sect3 | sect4 | sect5 | simplesect |
              db:section | db:sect1 | db:sect2 | db:sect3 | db:sect4 |
              db:sect5 | db:simplesect">
  <xsl:choose>
    <xsl:when test="local-name(..) != 'article'   and
                    local-name(..) != 'partintro' and
                    local-name(..) != 'preface'   and
                    .. != /                       ">
      <xsl:call-template name="l10n.gettext">
        <xsl:with-param name="msgid" select="'section.number'"/>
        <xsl:with-param name="node" select="."/>
        <xsl:with-param name="format" select="true()"/>
      </xsl:call-template>
    </xsl:when>
    <xsl:otherwise>
      <xsl:call-template name="db.digit"/>
    </xsl:otherwise>
  </xsl:choose>
</xsl:template>

<!-- = db.number.mode % synopfragment = -->
<xsl:template mode="db.number.mode" match="synopfragment | db:synopfragment">
  <xsl:call-template name="db.digit"/>
</xsl:template>

<!-- = db.number.mode % table = -->
<xsl:template mode="db.number.mode" match="table | db:table">
  <xsl:choose>
    <xsl:when test="ancestor::appendix or ancestor::chapter or
                    ancestor::db:appendix or ancestor::db:chapter">
      <xsl:call-template name="l10n.gettext">
        <xsl:with-param name="msgid" select="'table.number'"/>
        <xsl:with-param name="node" select="."/>
        <xsl:with-param name="format" select="true()"/>
      </xsl:call-template>
    </xsl:when>
    <xsl:otherwise>
      <xsl:call-template name="db.digit"/>
    </xsl:otherwise>
  </xsl:choose>
</xsl:template>

<!-- FIXME: need to use formatters -->

<xsl:template mode="db.number.mode" match="answer | db:answer">
  <!-- FIXME -->
</xsl:template>

<xsl:template mode="db.number.mode" match="article | db:article">
  <xsl:number format="I" value="
              count(preceding-sibling::article) + 1 +
              count(preceding-sibling::db:article) +
              count(parent::part/preceding-sibling::part/article) +
              count(parent::db:part/preceding-sibling::db:part/db:article)"/>
</xsl:template>

<xsl:template mode="db.number.mode" match="reference">
  <xsl:number format="I" value="
              count(preceding-sibling::reference) + 1 +
              count(preceding-sibling::db:reference) +
              count(parent::part/preceding-sibling::part/reference) +
              count(parent::db:part/preceding-sibling::db:part/db:reference)"/>
</xsl:template>

<xsl:template mode="db.number.mode" match="
              book  | bibliography | colophon | glossary |
              index    | set      | setindex |
              db:book  | db:bibliography | db:colophon | db:glossary |
              db:index    | db:set      | db:setindex "/>

<xsl:template mode="db.number.mode" match="synopfragment | db:synopfragment">
  <xsl:value-of select="count(preceding-sibling::synopfragment) + 1 +
                        count(preceding-sibling::db:synopfragment)"/>
</xsl:template>

<xsl:template mode="db.number.mode" match="title | subtitle |
                                           db:title | db:subtitle">
  <xsl:call-template name="db.number">
    <xsl:with-param name="node" select=".."/>
  </xsl:call-template>
</xsl:template>

<xsl:template mode="db.number.mode" match="*">
  <xsl:call-template name="db.number">
    <xsl:with-param name="node" select=".."/>
  </xsl:call-template>
</xsl:template>


<!--**==========================================================================
db.digit
FIXME

REMARK: Document this template
-->
<xsl:template name="db.digit">
  <xsl:param name="node" select="."/>
  <xsl:apply-templates mode="db.digit.mode" select="$node"/>
</xsl:template>

<!--#* db.digit.format -->
<xsl:template name="db.digit.format">
  <xsl:param name="digit"/>
  <xsl:param name="format"/>
  <xsl:choose>
    <xsl:when test="$format = '1'">
      <xsl:number format="1" value="$digit"/>
    </xsl:when>
    <xsl:when test="$format = 'A'">
      <xsl:number format="A" value="$digit"/>
    </xsl:when>
    <xsl:when test="$format = 'a'">
      <xsl:number format="a" value="$digit"/>
    </xsl:when>
    <xsl:when test="$format = 'I'">
      <xsl:number format="I" value="$digit"/>
    </xsl:when>
    <xsl:when test="$format = 'i'">
      <xsl:number format="i" value="$digit"/>
    </xsl:when>
    <xsl:otherwise>
      <xsl:message>
        <xsl:text>Unrecognized number formatter: </xsl:text>
        <xsl:value-of select="$format"/>
      </xsl:message>
      <xsl:number format="1" value="$digit"/>
    </xsl:otherwise>
  </xsl:choose>
</xsl:template>


<!--%%==========================================================================
db.digit.mode
FIXME

REMARK: Document this mode.  Rename to db.number.digit.mode?
-->

<!-- = db.digit.mode % appendix = -->
<xsl:template mode="db.digit.mode" match="appendix | db:appendix">
  <xsl:call-template name="db.digit.format">
    <!-- FIXME: use xsl:number -->
    <xsl:with-param name="digit" select="
                    count(preceding-sibling::appendix) + 1 +
                    count(preceding-sibling::db:appendix) +
                    count(parent::part/preceding-sibling::part/appendix) +
                    count(parent::db:part/preceding-sibling::db:part/db:appendix)"/>
    <xsl:with-param name="format">
      <xsl:call-template name="l10n.gettext">
        <xsl:with-param name="msgid" select="'appendix.digit'"/>
      </xsl:call-template>
    </xsl:with-param>
  </xsl:call-template>
</xsl:template>

<!-- = db.digit.mode % book = -->
<xsl:template mode="db.digit.mode" match="book | db:book">
  <xsl:call-template name="db.digit.format">
    <xsl:with-param name="digit" select="count(preceding-sibling::book) + 1 +
                                         count(preceding-sibling::db:book)"/>
    <xsl:with-param name="format">
      <xsl:call-template name="l10n.gettext">
        <xsl:with-param name="msgid" select="'book.digit'"/>
      </xsl:call-template>
    </xsl:with-param>
  </xsl:call-template>
</xsl:template>

<!-- = db.digit.mode % chapter = -->
<xsl:template mode="db.digit.mode" match="chapter | db:chapter">
  <xsl:call-template name="db.digit.format">
    <!-- FIXME: use xsl:number -->
    <xsl:with-param name="digit" select="
                    count(preceding-sibling::chapter) + 1 +
                    count(preceding-sibling::db:chapter) +
                    count(parent::part/preceding-sibling::part/chapter) +
                    count(parent::db:part/preceding-sibling::db:part/db:chapter)"/>
    <xsl:with-param name="format">
      <xsl:call-template name="l10n.gettext">
        <xsl:with-param name="msgid" select="'chapter.digit'"/>
      </xsl:call-template>
    </xsl:with-param>
  </xsl:call-template>
</xsl:template>

<!-- = db.digit.mode % example = -->
<xsl:template mode="db.digit.mode" match="example | db:example">
  <xsl:call-template name="db.digit.format">
    <xsl:with-param name="digit">
      <xsl:number level="any" count="example | db:example"
                              from="chapter | appendix |
                                    db:chapter | db:appendix"/>
    </xsl:with-param>
    <xsl:with-param name="format">
      <xsl:call-template name="l10n.gettext">
        <xsl:with-param name="msgid" select="'example.digit'"/>
      </xsl:call-template>
    </xsl:with-param>
  </xsl:call-template>
</xsl:template>

<!-- = db.digit.mode % figure = -->
<xsl:template mode="db.digit.mode" match="figure | db:figure">
  <xsl:call-template name="db.digit.format">
    <xsl:with-param name="digit">
      <xsl:number level="any" count="figure | db:figure"
                              from="chapter | appendix
                                    db:chapter | db:appendix"/>
    </xsl:with-param>
    <xsl:with-param name="format">
      <xsl:call-template name="l10n.gettext">
        <xsl:with-param name="msgid" select="'figure.digit'"/>
      </xsl:call-template>
    </xsl:with-param>
  </xsl:call-template>
</xsl:template>

<!-- = db.digit.mode % glossary = -->
<xsl:template mode="db.digit.mode" match="glossary | db:glossary"/>

<!-- = db.digit.mode % part = -->
<xsl:template mode="db.digit.mode" match="part | db:part">
  <xsl:call-template name="db.digit.format">
    <xsl:with-param name="digit" select="count(preceding-sibling::part) + 1 +
                                         count(preceding-sibling::db:part)"/>
    <xsl:with-param name="format">
      <xsl:call-template name="l10n.gettext">
        <xsl:with-param name="msgid" select="'part.digit'"/>
      </xsl:call-template>
    </xsl:with-param>
  </xsl:call-template>
</xsl:template>

<!-- = db.digit.mode % preface = -->
<xsl:template mode="db.digit.mode" match="preface | db:preface"/>

<!-- = db.digit.mode % question = -->
<xsl:template mode="db.digit.mode" match="question | db:question">
  <xsl:call-template name="db.digit.format">
    <xsl:with-param name="digit">
      <xsl:number level="any" format="1" count="question | db:question"
                                         from="qandaset | db:qandaset"/>
    </xsl:with-param>
    <xsl:with-param name="format">
      <xsl:call-template name="l10n.gettext">
        <xsl:with-param name="msgid" select="'question.digit'"/>
      </xsl:call-template>
    </xsl:with-param>
  </xsl:call-template>
</xsl:template>

<!-- = db.digit.mode % refsection = -->
<xsl:template mode="db.digit.mode" match="
              refsection | refsect1 | refsect2 | refsect3 |
              db:refsection | db:refsect1 | db:refsect2 | db:refsect3">
  <xsl:call-template name="db.digit.format">
    <xsl:with-param name="digit">
      <xsl:number level="single" format="1" count="
                  refsection | refsect1 | refsect2 | refsect3 |
                  db:refsection | db:refsect1 | db:refsect2 | db:refsect3"/>
    </xsl:with-param>
    <xsl:with-param name="format">
      <xsl:call-template name="l10n.gettext">
        <xsl:with-param name="msgid" select="'refsection.digit'"/>
      </xsl:call-template>
    </xsl:with-param>
  </xsl:call-template>
</xsl:template>

<!-- = db.digit.mode % section = -->
<xsl:template mode="db.digit.mode" match="
              section | sect1 | sect2 | sect3 | sect4 | sect5 | simplesect |
              db:section | db:sect1 | db:sect2 | db:sect3 | db:sect4 |
              db:sect5 | db:simplesect">
  <xsl:call-template name="db.digit.format">
    <xsl:with-param name="digit">
      <xsl:number level="single" format="1" count="
                  section | sect1 | sect2 | sect3 | sect4 | sect5 | simplesect |
                  db:section | db:sect1 | db:sect2 | db:sect3 | db:sect4 |
                  db:sect5 | db:simplesect"/>
    </xsl:with-param>
    <xsl:with-param name="format">
      <xsl:call-template name="l10n.gettext">
        <xsl:with-param name="msgid" select="'section.digit'"/>
      </xsl:call-template>
    </xsl:with-param>
  </xsl:call-template>
</xsl:template>

<!-- = db.digit.mode % synopfragment = -->
<xsl:template mode="db.digit.mode" match="synopfragment | db:synopfragment">
  <xsl:call-template name="db.digit.format">
    <xsl:with-param name="digit" select="count(preceding-sibling::synopfragment) + 1 +
                                         count(preceding-sibling::db:synopfragment)"/>
    <xsl:with-param name="format">
      <xsl:call-template name="l10n.gettext">
        <xsl:with-param name="msgid" select="'synopfragment.digit'"/>
      </xsl:call-template>
    </xsl:with-param>
  </xsl:call-template>
</xsl:template>

<!-- = db.digit.mode % table = -->
<xsl:template mode="db.digit.mode" match="table | db:table">
  <xsl:call-template name="db.digit.format">
    <xsl:with-param name="digit">
      <xsl:number level="any" count="table | db:table"
                              from="chapter | appendix |
                                    db:chapter | db:appendix"/>
    </xsl:with-param>
    <xsl:with-param name="format">
      <xsl:call-template name="l10n.gettext">
        <xsl:with-param name="msgid" select="'table.digit'"/>
      </xsl:call-template>
    </xsl:with-param>
  </xsl:call-template>
</xsl:template>


<!--%%==========================================================================
db.number.parent.mode
FIXME

REMARK: Document this mode
-->
<xsl:template mode="db.number.parent.mode" match="*">
  <xsl:call-template name="db.number">
    <xsl:with-param name="node" select=".."/>
  </xsl:call-template>
</xsl:template>

<!-- = db.number.parent.mode % example = -->
<xsl:template mode="db.number.parent.mode" match="example | db:example">
  <xsl:call-template name="db.number">
    <xsl:with-param name="node"
                    select="(ancestor::appendix | ancestor::chapter |
                            ancestor::db:appendix | ancestor::db:chapter)
                            [last()]"/>
  </xsl:call-template>
</xsl:template>

<!-- = db.number.parent.mode % figure = -->
<xsl:template mode="db.number.parent.mode" match="figure | db:figure">
  <xsl:call-template name="db.number">
    <xsl:with-param name="node"
                    select="(ancestor::appendix | ancestor::chapter |
                            ancestor::db:appendix | ancestor::db:chapter)
                            [last()]"/>
  </xsl:call-template>
</xsl:template>

<!-- = db.number.parent.mode % table = -->
<xsl:template mode="db.number.parent.mode" match="table | db:table">
  <xsl:call-template name="db.number">
    <xsl:with-param name="node"
                    select="(ancestor::appendix | ancestor::chapter |
                            ancestor::db:appendix | ancestor::db:chapter)
                            [last()]"/>
  </xsl:call-template>
</xsl:template>


<!-- == msg:* ============================================================== -->
<!--#% l10n.format.mode -->

<xsl:template mode="l10n.format.mode" match="msg:digit">
  <xsl:param name="node"/>
  <xsl:call-template name="db.digit">
    <xsl:with-param name="node" select="$node"/>
  </xsl:call-template>
</xsl:template>

<xsl:template mode="l10n.format.mode" match="msg:glossterm">
  <xsl:param name="node"/>
  <xsl:apply-templates select="$node/glossterm"/>
</xsl:template>

<xsl:template mode="l10n.format.mode" match="msg:label">
  <xsl:param name="node"/>
  <xsl:call-template name="db.label">
    <xsl:with-param name="node" select="$node"/>
  </xsl:call-template>
</xsl:template>

<xsl:template mode="l10n.format.mode" match="msg:number">
  <xsl:param name="node"/>
  <xsl:call-template name="db.number">
    <xsl:with-param name="node" select="$node"/>
  </xsl:call-template>
</xsl:template>

<xsl:template mode="l10n.format.mode" match="msg:parent">
  <xsl:param name="node"/>
  <xsl:apply-templates mode="db.number.parent.mode" select="$node"/>
</xsl:template>

</xsl:stylesheet>
