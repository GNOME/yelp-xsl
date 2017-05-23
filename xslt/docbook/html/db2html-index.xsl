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
<!ENTITY % selectors SYSTEM "../common/db-selectors.mod">
%selectors;
<!ENTITY primarykey "normalize-space(concat(
  primary/@sortas | db:primary/@sortas, ' ',
  primary | db:primary))">
<!ENTITY secondarykey "normalize-space(concat(
  primary/@sortas | db:primary/@sortas, ' ',
  primary | db:primary, ' ',
  secondary/@sortas | db:secondary/@sortas, ' ',
  secondary | db:secondary))">
<!ENTITY tertiarykey "normalize-space(concat(
  primary/@sortas | db:primary/@sortas, ' ',
  primary | db:primary, ' ',
  secondary/@sortas | db:secondary/@sortas, ' ',
  secondary | db:secondary, ' ',
  tertiary/@sortas | db:tertiary/@sortas, ' ',
  tertiary | db:tertiary))">
<!ENTITY uppercase "'ABCDEFGHIJKLMNOPQRSTUVWXYZ'">
<!ENTITY lowercase "'abcdefghijklmnopqrstuvwxyz'">
]>
<!-- FIXME: upper/lower for langs? -->

<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
                xmlns:db="http://docbook.org/ns/docbook"
                xmlns:msg="http://projects.gnome.org/yelp/gettext/"
                xmlns:set="http://exslt.org/sets"
                xmlns="http://www.w3.org/1999/xhtml"
                exclude-result-prefixes="db msg set"
                version="1.0">

<!--!!==========================================================================
DocBook to HTML - Indexes
:Requires: db-chunk db2html-division l10n

This module provides templates to process DocBook indexes.
-->

<!-- FIXME:
indexdiv
seeie
seealsoie
indexterm (autoidx)
-->

<xsl:key name="db.index.all.key"
         match="indexterm | db:indexterm"
         use="''"/>

<xsl:key name="db.index.primary.key"
         match="indexterm | db:indexterm"
         use="&primarykey;"/>

<xsl:key name="db.index.secondary.key"
         match="indexterm[secondary] | db:indexterm[db:secondary]"
         use="&secondarykey;"/>

<xsl:key name="db.index.tertiary.key"
         match="indexterm[tertiary] | db:indexterm[db:tertiary]"
         use="&tertiarykey;"/>

<!-- == Matched Templates == -->

<!-- = suppress = -->
<xsl:template match="primaryie | db:primaryie"/>
<xsl:template match="secondaryie | db:secondaryie"/>
<xsl:template match="tertiaryie | db:tertiaryie"/>

<!-- = indexentry = -->
<xsl:template match="indexentry | db:indexentry">
  <xsl:variable name="if"><xsl:call-template name="db.profile.test"/></xsl:variable>
  <xsl:if test="$if != ''">
  <dt class="ixprimary">
    <xsl:apply-templates select="primaryie/node() | db:primaryie/node()"/>
  </dt>
  <xsl:variable name="pri_see"
                select="seeie[not(preceding-sibling::secondaryie)] |
                        db:seeie[not(preceding-sibling::db:secondaryie)]"/>
  <xsl:variable name="pri_seealso"
                select="seealsoie[not(preceding-sibling::secondaryie)] |
                        db:seealsoie[not(preceding-sibling::db:secondaryie)]"/>
  <xsl:if test="$pri_see">
    <dd class="ixsee">
      <xsl:call-template name="l10n.gettext">
        <xsl:with-param name="msgid" select="'seeie.format'"/>
        <xsl:with-param name="node" select="$pri_see"/>
        <xsl:with-param name="format" select="true()"/>
      </xsl:call-template>
    </dd>
  </xsl:if>
  <xsl:if test="$pri_seealso">
    <dd class="ixseealso">
      <xsl:call-template name="l10n.gettext">
        <xsl:with-param name="msgid" select="'seealsoie.format'"/>
        <xsl:with-param name="node" select="$pri_seealso"/>
        <xsl:with-param name="format" select="true()"/>
      </xsl:call-template>
    </dd>
  </xsl:if>
  <xsl:for-each select="secondaryie | db:secondaryie">
    <dd class="ixsecondary">
      <dl class="ixsecondary">
        <dt class="ixsecondary">
          <xsl:apply-templates/>
        </dt>
        <xsl:variable name="sec_see"
                      select="following-sibling::seeie
                                [set:has-same-node(preceding-sibling::secondaryie[1], current())] |
                              following-sibling::db:seeie
                                [set:has-same-node(preceding-sibling::db:secondaryie[1], current())]"/>
        <xsl:variable name="sec_seealso"
                      select="following-sibling::seealsoie
                                [set:has-same-node(preceding-sibling::secondaryie[1], current())] |
                              following-sibling::db:seealsoie
                                [set:has-same-node(preceding-sibling::db:secondaryie[1], current())]"/>
        <xsl:variable name="tertiary"
                      select="following-sibling::tertiaryie
                                [set:has-same-node(preceding-sibling::secondaryie[1], current())] |
                              following-sibling::db:tertiaryie
                                [set:has-same-node(preceding-sibling::db:secondaryie[1], current())]"/>
        <xsl:if test="$sec_see">
          <dd class="ixsee">
            <xsl:call-template name="l10n.gettext">
              <xsl:with-param name="msgid" select="'seeie.format'"/>
              <xsl:with-param name="node" select="$sec_see"/>
              <xsl:with-param name="format" select="true()"/>
            </xsl:call-template>
          </dd>
        </xsl:if>
        <xsl:if test="$sec_seealso">
          <dd class="ixseealso">
            <xsl:call-template name="l10n.gettext">
              <xsl:with-param name="msgid" select="'seealsoie.format'"/>
              <xsl:with-param name="node" select="$sec_seealso"/>
              <xsl:with-param name="format" select="true()"/>
            </xsl:call-template>
          </dd>
        </xsl:if>
        <xsl:if test="$tertiary">
          <!-- FIXME -->
        </xsl:if>
      </dl>
    </dd>
  </xsl:for-each>
  </xsl:if>
</xsl:template>

<!-- = index = -->
<xsl:template match="index | db:index">
  <xsl:param name="depth_in_chunk">
    <xsl:call-template name="db.chunk.depth-in-chunk"/>
  </xsl:param>
  <xsl:param name="depth_of_chunk">
    <xsl:call-template name="db.chunk.depth-of-chunk"/>
  </xsl:param>
  <xsl:call-template name="db2html.division.div">
    <xsl:with-param name="info" select="indexinfo | db:info"/>
    <xsl:with-param name="divisions" select="indexdiv | db:indexdiv"/>
    <xsl:with-param name="entries" select="indexentry | db:indexentry"/>
    <xsl:with-param name="depth_in_chunk" select="$depth_in_chunk"/>
    <xsl:with-param name="depth_of_chunk" select="$depth_of_chunk"/>
  </xsl:call-template>
</xsl:template>

<!-- = indexdiv = -->
<xsl:template match="indexdiv | db:indexdiv">
  <xsl:param name="depth_in_chunk">
    <xsl:call-template name="db.chunk.depth-in-chunk"/>
  </xsl:param>
  <xsl:param name="depth_of_chunk">
    <xsl:call-template name="db.chunk.depth-of-chunk"/>
  </xsl:param>
  <xsl:call-template name="db2html.division.div">
    <xsl:with-param name="entries" select="indexentry | db:indexentry"/>
    <xsl:with-param name="depth_in_chunk" select="$depth_in_chunk"/>
    <xsl:with-param name="depth_of_chunk" select="$depth_of_chunk"/>
  </xsl:call-template>
</xsl:template>

<!-- = setindex = -->
<xsl:template match="setindex | db:setindex">
  <xsl:param name="depth_in_chunk">
    <xsl:call-template name="db.chunk.depth-in-chunk"/>
  </xsl:param>
  <xsl:param name="depth_of_chunk">
    <xsl:call-template name="db.chunk.depth-of-chunk"/>
  </xsl:param>
  <xsl:call-template name="db2html.division.div">
    <xsl:with-param name="info" select="setindexinfo | db:info"/>
    <xsl:with-param name="divisions" select="indexdiv | db:indexdiv"/>
    <xsl:with-param name="entries" select="indexentry | db:indexentry"/>
    <xsl:with-param name="depth_in_chunk" select="$depth_in_chunk"/>
    <xsl:with-param name="depth_of_chunk" select="$depth_of_chunk"/>
  </xsl:call-template>
</xsl:template>

<!--#% l10n.format.mode -->
<xsl:template mode="l10n.format.mode" match="msg:seeie">
  <xsl:param name="node"/>
  <xsl:for-each select="$node">
    <xsl:if test="position() != 1">
      <xsl:call-template name="l10n.gettext">
        <xsl:with-param name="msgid" select="', '"/>
      </xsl:call-template>
    </xsl:if>
    <xsl:apply-templates/>
<!--
    <xsl:choose>
      <xsl:when test="@otherterm">
        <a>
          <xsl:attribute name="href">
            <xsl:call-template name="db.xref.target">
              <xsl:with-param name="linkend" select="@otherterm"/>
            </xsl:call-template>
          </xsl:attribute>
          <xsl:attribute name="title">
            <xsl:call-template name="db.xref.tooltip">
              <xsl:with-param name="linkend" select="@otherterm"/>
            </xsl:call-template>
          </xsl:attribute>
          <xsl:choose>
            <xsl:when test="normalize-space(.) != ''">
              <xsl:apply-templates/>
            </xsl:when>
            <xsl:otherwise>
              <xsl:call-template name="db.xref.content">
                <xsl:with-param name="linkend" select="@otherterm"/>
                <xsl:with-param name="role" select="'glosssee'"/>
              </xsl:call-template>
            </xsl:otherwise>
          </xsl:choose>
        </a>
      </xsl:when>
      <xsl:otherwise>
        <xsl:apply-templates/>
      </xsl:otherwise>
    </xsl:choose>
-->
  </xsl:for-each>
</xsl:template>

<!-- = index % db2html.division.div.content.mode = -->
<!-- Auto-generated indexes -->
<xsl:template mode="db2html.division.div.content.mode"
              match="index[count(indexentry | indexdiv) = 0] |
                     db:index[count(db:indexentry | db:indexdiv) = 0]">
  <xsl:param name="node" select="."/>
  <xsl:param name="info" select="indexinfo | db:info"/>
  <xsl:param name="depth_in_chunk">
    <xsl:call-template name="db.chunk.depth-in-chunk">
      <xsl:with-param name="node" select="$node"/>
    </xsl:call-template>
  </xsl:param>
  <xsl:param name="depth_of_chunk">
    <xsl:call-template name="db.chunk.depth-of-chunk">
      <xsl:with-param name="node" select="$node"/>
    </xsl:call-template>
  </xsl:param>
  <xsl:variable name="nots" select="title | db:title | titleabbrev | db:titleabbrev | subtitle | db:subtitle"/>
  <xsl:apply-templates select="set:difference(*, $nots)">
    <xsl:with-param name="depth_in_chunk" select="$depth_in_chunk + 1"/>
    <xsl:with-param name="depth_of_chunk" select="$depth_of_chunk"/>
  </xsl:apply-templates>

  <xsl:variable name="allterms" select="key('db.index.all.key', '')"/>
  <xsl:variable name="prifirstterms"
                select="$allterms[count(. | key('db.index.primary.key', &primarykey;)[1]) = 1]"/>
  <dl>
    <xsl:for-each select="$prifirstterms">
      <xsl:sort select="translate(&primarykey;, &uppercase;, &lowercase;)"/>
      <xsl:variable name="term" select="."/>
      <xsl:if test="true()">
        <dt class="ixprimary">
          <xsl:apply-templates select="primary/node() | db:primary/node()"/>
        </dt>
        <xsl:variable name="prikey" select="&primarykey;"/>
        <xsl:variable name="priterms" select="key('db.index.primary.key', $prikey)"/>
        <xsl:variable name="prilinks"
                      select="$priterms[not(secondary | db:secondary | see | db:see)]"/>
        <xsl:for-each select="$prilinks">
          <dd class="ixlink">
            <xsl:call-template name="db2html.xref">
              <xsl:with-param name="target" select="."/>
            </xsl:call-template>
          </dd>
        </xsl:for-each>
        <xsl:variable name="prisee"
                      select="$priterms[not(secondary)]/see | $priterms[not(db:secondary)]/db:see"/>
        <xsl:for-each select="$prisee">
          <dd class="ixsee">
            <xsl:call-template name="l10n.gettext">
              <xsl:with-param name="msgid" select="'seeie.format'"/>
              <xsl:with-param name="node" select="."/>
              <xsl:with-param name="format" select="true()"/>
            </xsl:call-template>
          </dd>
        </xsl:for-each>
        <xsl:variable name="priseealso"
                      select="$priterms[not(secondary)]/seealso | $priterms[not(db:secondary)]/db:seealso"/>
        <xsl:for-each select="$priseealso">
          <dd class="ixseealso">
            <xsl:call-template name="l10n.gettext">
              <xsl:with-param name="msgid" select="'seealsoie.format'"/>
              <xsl:with-param name="node" select="."/>
              <xsl:with-param name="format" select="true()"/>
            </xsl:call-template>
          </dd>
        </xsl:for-each>
        <xsl:if test="$priterms/secondary or $priterms/db:secondary">
          <dd class="ixsecondary">
            <dl class="ixsecondary">
              <xsl:variable name="secfirstterms"
                            select="$priterms[count(. | key('db.index.secondary.key',
                                                            &secondarykey;)[1]) = 1]"/>
              <xsl:for-each select="$secfirstterms">
                <xsl:sort select="translate(&secondarykey;, &uppercase;, &lowercase;)"/>
                <xsl:if test="secondary | db:secondary">
                  <dt class="ixsecondary">
                    <xsl:value-of select="secondary | db:secondary"/>
                  </dt>
                  <xsl:variable name="seckey" select="&secondarykey;"/>
                  <xsl:variable name="secterms" select="key('db.index.secondary.key', $seckey)"/>
                  <xsl:variable name="seclinks"
                                select="$secterms[not(tertiary | db:tertiary | see | db:see)]"/>
                  <xsl:for-each select="$seclinks">
                    <dd class="ixlink">
                      <xsl:call-template name="db2html.xref">
                        <xsl:with-param name="target" select="."/>
                      </xsl:call-template>
                    </dd>
                  </xsl:for-each>
                  <xsl:variable name="secsee"
                                select="$secterms[not(tertiary)]/see | $secterms[not(db:tertiary)]/db:see"/>
                  <xsl:for-each select="$secsee">
                    <dd class="ixsee">
                      <xsl:call-template name="l10n.gettext">
                        <xsl:with-param name="msgid" select="'seeie.format'"/>
                        <xsl:with-param name="node" select="."/>
                        <xsl:with-param name="format" select="true()"/>
                      </xsl:call-template>
                    </dd>
                  </xsl:for-each>
                  <xsl:variable name="secseealso"
                                select="$secterms[not(tertiary)]/seealso | $secterms[not(db:tertiary)]/db:seealso"/>
                  <xsl:for-each select="$secseealso">
                    <dd class="ixseealso">
                      <xsl:call-template name="l10n.gettext">
                        <xsl:with-param name="msgid" select="'seealsoie.format'"/>
                        <xsl:with-param name="node" select="."/>
                        <xsl:with-param name="format" select="true()"/>
                      </xsl:call-template>
                    </dd>
                  </xsl:for-each>
                  <xsl:if test="$secterms/tertiary or $secterms/db:tertiary">
                    <dd class="ixtertiary">
                      <dl class="ixtertiary">
                        <xsl:variable name="terfirstterms"
                            select="$secterms[count(. | key('db.index.tertiary.key',
                                                            &tertiarykey;)[1]) = 1]"/>
                        <xsl:for-each select="$terfirstterms">
                          <xsl:sort select="translate(&tertiarykey;, &uppercase;, &lowercase;)"/>
                          <xsl:if test="tertiary | db:tertiary">
                            <dt class="ixtertiary">
                              <xsl:value-of select="tertiary | db:tertiary"/>
                            </dt>
                            <xsl:variable name="terkey" select="&tertiarykey;"/>
                            <xsl:variable name="terterms" select="key('db.index.tertiary.key', $terkey)"/>
                            <xsl:variable name="terlinks" select="$terterms[not(see | db:see)]"/>
                            <xsl:for-each select="$terlinks">
                              <dd class="ixlink">
                                <xsl:call-template name="db2html.xref">
                                  <xsl:with-param name="target" select="."/>
                                </xsl:call-template>
                              </dd>
                            </xsl:for-each>
                            <xsl:variable name="tersee"
                                          select="$terterms/see | $terterms/db:see"/>
                            <xsl:for-each select="$tersee">
                              <dd class="ixsee">
                                <xsl:call-template name="l10n.gettext">
                                  <xsl:with-param name="msgid" select="'seeie.format'"/>
                                  <xsl:with-param name="node" select="."/>
                                  <xsl:with-param name="format" select="true()"/>
                                </xsl:call-template>
                              </dd>
                            </xsl:for-each>
                            <xsl:variable name="terseealso"
                                          select="$terterms/seealso | $terterms/db:seealso"/>
                            <xsl:for-each select="$terseealso">
                              <dd class="ixseealso">
                                <xsl:call-template name="l10n.gettext">
                                  <xsl:with-param name="msgid" select="'seealsoie.format'"/>
                                  <xsl:with-param name="node" select="."/>
                                  <xsl:with-param name="format" select="true()"/>
                                </xsl:call-template>
                              </dd>
                            </xsl:for-each>
                          </xsl:if>
                        </xsl:for-each>
                      </dl>
                    </dd>
                  </xsl:if>
                </xsl:if>
              </xsl:for-each>
            </dl>
          </dd>
        </xsl:if>
      </xsl:if>
    </xsl:for-each>
  </dl>
</xsl:template>

</xsl:stylesheet>
