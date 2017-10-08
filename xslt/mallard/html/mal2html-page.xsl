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
                xmlns:mal="http://projectmallard.org/1.0/"
                xmlns:ui="http://projectmallard.org/ui/1.0/"
                xmlns:uix="http://projectmallard.org/experimental/ui/"
                xmlns:e="http://projectmallard.org/experimental/"
                xmlns:exsl="http://exslt.org/common"
                xmlns:set="http://exslt.org/sets"
                xmlns:msg="http://projects.gnome.org/yelp/gettext/"
                xmlns="http://www.w3.org/1999/xhtml"
                exclude-result-prefixes="mal ui uix e exsl set msg"
                version="1.0">

<!--!!==========================================================================
Mallard to HTML - Pages
Handle pages, sections, and top-level data.
:Revision:version="3.8" date="2012-11-05" status="final"

This stylesheet contains templates to process Mallard #{page} and #{section}
elements, including implementations of the interfaces provided by the common
!{html} stylesheet.
-->


<!--@@==========================================================================
mal2html.editor_mode
Add information that's useful to writers and editors.
:Revision:version="3.8" date="2012-11-05" status="final"

When this parameter is set to true, these stylesheets will output editorial
comments, status markers, and other information that's useful to writers and
editors.
-->
<xsl:param name="mal2html.editor_mode" select="false()"/>


<!--**==========================================================================
mal2html.page.about
Output the copyrights, credits, and license information at the bottom of a page.
:Revision:version="3.8" date="2012-11-05" status="final"
$node: The top-level #{page} element.

This template outputs copyright information, credits, and license information for
the page. By default it is called by the %{html.footer.mode} implementation for
the #{page} element. Information is extracted from the #{info} element of ${node}.
-->
<xsl:template name="mal2html.page.about">
  <xsl:param name="node" select="."/>
  <xsl:if test="$node/mal:info/mal:credit or $node/mal:info/mal:license">
  <footer class="about ui-expander" role="contentinfo">
    <div class="yelp-data yelp-data-ui-expander" data-yelp-expanded="false"/>
    <div class="inner">
    <div class="hgroup">
      <h2>
        <span class="title">
          <xsl:call-template name="l10n.gettext">
            <xsl:with-param name="msgid" select="'About'"/>
          </xsl:call-template>
        </span>
      </h2>
    </div>
    <div class="region">
      <div class="contents">
        <xsl:variable name="credits" select="$node/mal:info/mal:credit"/>
        <xsl:variable name="copyrights"
                      select="$credits[contains(concat(' ', @type, ' '), ' copyright ')]
                              [mal:years]"/>
        <xsl:if test="$copyrights">
          <div class="copyrights">
            <xsl:for-each  select="$copyrights">
              <div class="copyright">
                <xsl:call-template name="l10n.gettext">
                  <xsl:with-param name="msgid" select="'copyright.format'"/>
                  <xsl:with-param name="node" select="."/>
                  <xsl:with-param name="format" select="true()"/>
                </xsl:call-template>
              </div>
            </xsl:for-each>
          </div>
        </xsl:if>
        <xsl:variable name="authors"
                      select="$credits[contains(concat(' ', @type, ' '), ' author ')]"/>
        <xsl:variable name="editors"
                      select="$credits[contains(concat(' ', @type, ' '), ' editor ')]"/>
        <xsl:variable name="maintainers"
                      select="$credits[contains(concat(' ', @type, ' '), ' maintainer ')]"/>
        <xsl:variable name="translators"
                      select="$credits[contains(concat(' ', @type, ' '), ' translator ')]"/>
        <xsl:variable name="publishers"
                      select="$credits[contains(concat(' ', @type, ' '), ' publisher ')]"/>
        <!-- others doesn't exclude all copyrights, just credits that are only copyrights -->
        <xsl:variable name="others"
                      select="set:difference($credits,
                              $authors | $editors | $maintainers | $translators | $publishers)
                              [not(@type = 'copyright' and mal:years)]"/>
        <xsl:if test="$authors or $editors or $maintainers or
                      $translators or publishers or $others">
          <div class="credits">
            <xsl:call-template name="_mal2html.page.about.credits">
              <xsl:with-param name="class" select="'credits-authors'"/>
              <xsl:with-param name="title" select="'Written By'"/>
              <xsl:with-param name="credits" select="$authors"/>
            </xsl:call-template>
            <xsl:call-template name="_mal2html.page.about.credits">
              <xsl:with-param name="class" select="'credits-editors'"/>
              <xsl:with-param name="title" select="'Edited By'"/>
              <xsl:with-param name="credits" select="$editors"/>
            </xsl:call-template>
            <xsl:call-template name="_mal2html.page.about.credits">
              <xsl:with-param name="class" select="'credits-maintainers'"/>
              <xsl:with-param name="title" select="'Maintained By'"/>
              <xsl:with-param name="credits" select="$maintainers"/>
            </xsl:call-template>
            <xsl:call-template name="_mal2html.page.about.credits">
              <xsl:with-param name="class" select="'credits-translators'"/>
              <xsl:with-param name="title" select="'Translated By'"/>
              <xsl:with-param name="credits" select="$translators"/>
            </xsl:call-template>
            <xsl:call-template name="_mal2html.page.about.credits">
              <xsl:with-param name="class" select="'credits-publishers'"/>
              <xsl:with-param name="title" select="'Published By'"/>
              <xsl:with-param name="credits" select="$publishers"/>
            </xsl:call-template>
            <xsl:call-template name="_mal2html.page.about.credits">
              <xsl:with-param name="class" select="'credits-other'"/>
              <xsl:with-param name="title" select="'Other Credits'"/>
              <xsl:with-param name="credits" select="$others"/>
            </xsl:call-template>
            <div class="credits-blank"></div>
            <div class="credits-blank"></div>
          </div>
        </xsl:if>
        <xsl:for-each select="$node/mal:info/mal:license">
          <div class="license">
            <div class="title">
              <span class="title">
                <xsl:choose>
                  <xsl:when test="starts-with(@href, 'http://creativecommons.org/')">
                    <xsl:call-template name="l10n.gettext">
                      <xsl:with-param name="msgid" select="'Creative Commons'"/>
                    </xsl:call-template>
                  </xsl:when>
                  <xsl:otherwise>
                    <xsl:call-template name="l10n.gettext">
                      <xsl:with-param name="msgid" select="'License'"/>
                    </xsl:call-template>
                  </xsl:otherwise>
                </xsl:choose>
              </span>
            </div>
            <div class="contents">
              <xsl:apply-templates mode="mal2html.block.mode"/>
            </div>
          </div>
        </xsl:for-each>
      </div>
    </div>
    </div>
  </footer>
  </xsl:if>
</xsl:template>

<!--#* _mal2html.page.about.credits -->
<xsl:template name="_mal2html.page.about.credits">
  <xsl:param name="class"/>
  <xsl:param name="title"/>
  <xsl:param name="credits"/>
  <xsl:if test="$credits">
    <div class="{$class}">
      <div class="title">
        <span class="title">
          <xsl:call-template name="l10n.gettext">
            <xsl:with-param name="msgid" select="$title"/>
          </xsl:call-template>
        </span>
      </div>
      <ul class="credits">
        <xsl:for-each select="$credits">
          <li>
            <xsl:apply-templates mode="mal2html.inline.mode" select="mal:name/node()"/>
          </li>
        </xsl:for-each>
      </ul>
    </div>
  </xsl:if>
</xsl:template>

<xsl:template mode="l10n.format.mode" match="msg:copyright.years">
  <xsl:param name="node"/>
  <xsl:apply-templates mode="mal2html.inline.mode"
                       select="$node/mal:years/node()"/>
</xsl:template>

<xsl:template mode="l10n.format.mode" match="msg:copyright.name">
  <xsl:param name="node"/>
  <xsl:apply-templates mode="mal2html.inline.mode"
                       select="$node/mal:name/node()"/>
</xsl:template>


<!--**==========================================================================
mal2html.page.linktrails
Ouput trails of guide links for a page.
:Revision:version="3.4" date="2011-11-19" status="final"
$node: The top-level #{page} element.

This template outputs all of the link trails for the page ${node}. It gets the
trails from ${mal.link.linktrails}. If the result is non-empty, it outputs a
wrapper #{div}, sorts the trails, and calls *{mal2html.page.linktrails.trail}
on each one. Otherwise, it calls the stub template *{mal2html.page.linktrails.empty}.
-->
<xsl:template name="mal2html.page.linktrails">
  <xsl:param name="node" select="."/>
  <xsl:variable name="linktrails">
    <xsl:call-template name="mal.link.linktrails">
      <xsl:with-param name="node" select="$node"/>
    </xsl:call-template>
  </xsl:variable>
  <xsl:variable name="trailnodes" select="exsl:node-set($linktrails)/*"/>
  <xsl:choose>
    <xsl:when test="count($trailnodes) &gt; 0">
      <div class="trails" role="navigation">
        <xsl:for-each select="$trailnodes">
          <xsl:sort select="(.//mal:title[@type='sort'])[1]"/>
          <xsl:sort select="(.//mal:title[@type='sort'])[2]"/>
          <xsl:sort select="(.//mal:title[@type='sort'])[3]"/>
          <xsl:sort select="(.//mal:title[@type='sort'])[4]"/>
          <xsl:sort select="(.//mal:title[@type='sort'])[5]"/>
          <xsl:call-template name="mal2html.page.linktrails.trail"/>
        </xsl:for-each>
      </div>
    </xsl:when>
    <xsl:otherwise>
      <xsl:call-template name="mal2html.page.linktrails.empty">
        <xsl:with-param name="node" select="$node"/>
      </xsl:call-template>
    </xsl:otherwise>
  </xsl:choose>
</xsl:template>


<!--**==========================================================================
mal2html.page.linktrails.empty
Deprecated stub to output something when no link trails are present.
:Stub: true
:Revision:version="3.20" date="2015-09-17" status="final"
$node: The top-level #{page} element.

This template is deprecated. Use *{html.linktrails.empty} instead. By default,
this template calls *{html.linktrails.empty}, passing the ${node} parameter.

This template is a stub. It is called by ${mal2html.page.linktrails} when there
are no link trails to output. Some customizations prepend extra site links to
link trails. This template allows them to output those links even when no link
trails would otherwise be present.
-->
<xsl:template name="mal2html.page.linktrails.empty">
  <xsl:param name="node" select="."/>
  <xsl:call-template name="html.linktrails.empty">
    <xsl:with-param name="node" select="$node"/>
  </xsl:call-template>
</xsl:template>


<!--**==========================================================================
mal2html.page.linktrails.trail
Output one trail of guide links.
:Revision:version="3.20" date="2015-09-19" status="final"
$node: A #{link} element from *{mal.link.linktrails}.

This template outputs an HTML #{div} element containing all the links in a
single link trail. It calls *{html.linktrails.prefix} (by way of 
*{mal2html.page.linktrails.trail.prefix}) to output a custom boilerplate prefix,
then calls *{mal2html.page.linktrails.link} to output the actual links.
-->
<xsl:template name="mal2html.page.linktrails.trail">
  <xsl:param name="node" select="."/>
  <div class="trail">
    <xsl:call-template name="mal2html.page.linktrails.trail.prefix">
      <xsl:with-param name="node" select="$node"/>
    </xsl:call-template>
    <xsl:call-template name="mal2html.page.linktrails.link">
      <xsl:with-param name="node" select="$node"/>
    </xsl:call-template>
  </div>
</xsl:template>


<!--**==========================================================================
mal2html.page.linktrails.trail.prefix
Deprecated stub to output extra content before a link trail.
:Stub: true
:Revision:version="3.20" date="2015-09-17" status="final"
$node: A #{link} element from *{mal.link.linktrails}.

This template is deprecated. Use *{html.linktrails.prefix} instead. By default,
this template calls *{html.linktrails.prefix}, passing the ${node} parameter.

This template is a stub. It is called by *{mal2html.page.linktrails.trail} for
each link trail before the normal links are output with
*{mal2html.page.linktrails.link}. This template is useful for adding extra site
links at the beginning of each link trail.
-->
<xsl:template name="mal2html.page.linktrails.trail.prefix">
  <xsl:param name="node" select="."/>
  <xsl:call-template name="html.linktrails.prefix">
    <xsl:with-param name="node" select="$node"/>
  </xsl:call-template>
</xsl:template>


<!--**==========================================================================
mal2html.page.linktrails.link
Output a link and the following links in a link trail.
:Revision:version="3.4" date="2011-11-19" status="final"
$node: A #{link} element from *{mal.link.linktrails}.
$direction: The text directionality.

This template is called by *{mal2html.page.linktrails.trail} to output the links
in a trail. Link trails returned by *{mal.link.linktrails} are returned as nested
#{link} elements. This template takes one of those elements, outputs an HTML #{a}
element, then calls itself recursively on the child #{link} element, if it exists.

The ${direction} parameter specifies the current text directionality. If not
provided, it is computed automatically with *{l10n.direction}. It determines the
separators used between links.
-->
<xsl:template name="mal2html.page.linktrails.link">
  <xsl:param name="node" select="."/>
  <xsl:param name="direction">
    <xsl:call-template name="l10n.direction"/>
  </xsl:param>
  <a class="trail">
    <xsl:attribute name="href">
      <xsl:call-template name="mal.link.target">
        <xsl:with-param name="xref" select="$node/@xref"/>
      </xsl:call-template>
    </xsl:attribute>
    <xsl:attribute name="title">
      <xsl:call-template name="mal.link.tooltip">
        <xsl:with-param name="xref" select="$node/@xref"/>
        <xsl:with-param name="role" select="'trail guide'"/>
      </xsl:call-template>
    </xsl:attribute>
    <xsl:call-template name="mal.link.content">
      <xsl:with-param name="node" select="$node"/>
      <xsl:with-param name="xref" select="$node/@xref"/>
      <xsl:with-param name="role" select="'trail guide'"/>
    </xsl:call-template>
  </a>
  <xsl:if test="$direction = 'rtl'">
    <xsl:text>&#x200F;</xsl:text>
  </xsl:if>
  <xsl:choose>
    <xsl:when test="$node/@child = 'section'">
      <xsl:text>&#x00A0;› </xsl:text>
    </xsl:when>
    <xsl:otherwise>
      <xsl:text>&#x00A0;» </xsl:text>
    </xsl:otherwise>
  </xsl:choose>
  <xsl:if test="$direction = 'rtl'">
    <xsl:text>&#x200F;</xsl:text>
  </xsl:if>
  <xsl:for-each select="$node/mal:link">
    <xsl:call-template name="mal2html.page.linktrails.link">
      <xsl:with-param name="direction" select="$direction"/>
    </xsl:call-template>
  </xsl:for-each>
</xsl:template>


<!--**==========================================================================
mal2html.editor.badge
Output a badge for a link showing the revision status of the target.
:Revision:version="3.8" date="2012-11-05" status="final"
$target: The page or section being linked to.

This template may be called by link formatters to output a badge showing the
revision status of the linked-to page or section. It only outputs a badge if
@{mal2html.editor_mode} is #{true}.
-->
<xsl:template name="mal2html.editor.badge">
  <xsl:param name="target" select="."/>
  <xsl:if test="$mal2html.editor_mode">
    <xsl:variable name="page" select="$target/ancestor-or-self::mal:page[1]"/>
    <xsl:variable name="date">
      <xsl:for-each select="$page/mal:info/mal:revision">
        <xsl:sort select="@date" data-type="text" order="descending"/>
        <xsl:if test="position() = 1">
          <xsl:value-of select="@date"/>
        </xsl:if>
      </xsl:for-each>
    </xsl:variable>
    <xsl:variable name="revision"
                  select="$page/mal:info/mal:revision[@date = $date][last()]"/>
    <xsl:if test="$revision/@status != ''">
      <xsl:text> </xsl:text>
      <span>
        <xsl:attribute name="class">
          <xsl:value-of select="concat('status status-', $revision/@status)"/>
        </xsl:attribute>
        <xsl:choose>
          <xsl:when test="$revision/@status = 'stub'">
            <xsl:call-template name="l10n.gettext">
              <xsl:with-param name="msgid" select="'Stub'"/>
            </xsl:call-template>
          </xsl:when>
          <xsl:when test="$revision/@status = 'incomplete'">
            <xsl:call-template name="l10n.gettext">
              <xsl:with-param name="msgid" select="'Incomplete'"/>
            </xsl:call-template>
          </xsl:when>
          <xsl:when test="$revision/@status = 'draft'">
            <xsl:call-template name="l10n.gettext">
              <xsl:with-param name="msgid" select="'Draft'"/>
            </xsl:call-template>
          </xsl:when>
          <xsl:when test="$revision/@status = 'outdated'">
            <xsl:call-template name="l10n.gettext">
              <xsl:with-param name="msgid" select="'Outdated'"/>
            </xsl:call-template>
          </xsl:when>
          <xsl:when test="$revision/@status = 'review'">
            <xsl:call-template name="l10n.gettext">
              <xsl:with-param name="msgid" select="'Ready for review'"/>
            </xsl:call-template>
          </xsl:when>
          <xsl:when test="$revision/@status = 'candidate'">
            <xsl:call-template name="l10n.gettext">
              <xsl:with-param name="msgid" select="'Candidate'"/>
            </xsl:call-template>
          </xsl:when>
          <xsl:when test="$revision/@status = 'final'">
            <xsl:call-template name="l10n.gettext">
              <xsl:with-param name="msgid" select="'Final'"/>
            </xsl:call-template>
          </xsl:when>
        </xsl:choose>
      </span>
    </xsl:if>
  </xsl:if>
</xsl:template>


<!--**==========================================================================
mal2html.editor.banner
Output a banner with the revision status of a page.
:Revision:version="3.8" date="2012-11-05" status="final"
$node: The top-level #{page} element.

This template is called by the %{html.body.mode} implementation for #{page}
elements. It outputs a banner providing information about the revision status
of ${node}. It only outputs a banner if @{mal2html.editor_mode} is #{true}.
-->
<xsl:template name="mal2html.editor.banner">
  <xsl:param name="node" select="."/>
  <xsl:if test="$mal2html.editor_mode">
    <xsl:variable name="date">
      <xsl:for-each select="$node/mal:info/mal:revision">
        <xsl:sort select="@date" data-type="text" order="descending"/>
        <xsl:if test="position() = 1">
          <xsl:value-of select="@date"/>
        </xsl:if>
      </xsl:for-each>
    </xsl:variable>
    <xsl:variable name="revision"
                  select="$node/mal:info/mal:revision
                          [@date = $date or (not(@date) and $date = '')][last()]"/>
    <xsl:if test="$revision/@status != ''">
      <div class="note note-version pagewide"><div class="inner">
        <!-- FIXME: i18n -->
        <div class="title">
          <xsl:choose>
            <xsl:when test="$revision/@status = 'stub'">
              <xsl:call-template name="l10n.gettext">
                <xsl:with-param name="msgid" select="'Stub'"/>
              </xsl:call-template>
            </xsl:when>
            <xsl:when test="$revision/@status = 'incomplete'">
              <xsl:call-template name="l10n.gettext">
                <xsl:with-param name="msgid" select="'Incomplete'"/>
              </xsl:call-template>
            </xsl:when>
            <xsl:when test="$revision/@status = 'draft'">
              <xsl:call-template name="l10n.gettext">
                <xsl:with-param name="msgid" select="'Draft'"/>
              </xsl:call-template>
            </xsl:when>
            <xsl:when test="$revision/@status = 'outdated'">
              <xsl:call-template name="l10n.gettext">
                <xsl:with-param name="msgid" select="'Outdated'"/>
              </xsl:call-template>
            </xsl:when>
            <xsl:when test="$revision/@status = 'review'">
              <xsl:call-template name="l10n.gettext">
                <xsl:with-param name="msgid" select="'Ready for review'"/>
              </xsl:call-template>
            </xsl:when>
            <xsl:when test="$revision/@status = 'candidate'">
              <xsl:call-template name="l10n.gettext">
                <xsl:with-param name="msgid" select="'Candidate'"/>
              </xsl:call-template>
            </xsl:when>
            <xsl:when test="$revision/@status = 'final'">
              <xsl:call-template name="l10n.gettext">
                <xsl:with-param name="msgid" select="'Final'"/>
              </xsl:call-template>
            </xsl:when>
          </xsl:choose>
        </div>
        <div class="region"><div class="contents">
        <xsl:variable name="version">
          <xsl:choose>
            <xsl:when test="$revision/@version">
              <xsl:value-of select="$revision/@version"/>
            </xsl:when>
            <xsl:when test="$revision/@docversion">
              <xsl:value-of select="$revision/@docversion"/>
            </xsl:when>
            <xsl:when test="$revision/@pkgversion">
              <xsl:value-of select="$revision/@pkgversion"/>
            </xsl:when>
          </xsl:choose>
        </xsl:variable>
        <xsl:if test="$version != '' or $revision/@date">
          <p class="version">
            <xsl:value-of select="$version"/>
            <xsl:if test="$revision/@date">
              <xsl:text> (</xsl:text>
              <xsl:value-of select="$revision/@date"/>
              <xsl:text>)</xsl:text>
            </xsl:if>
          </p>
        </xsl:if>
        <xsl:apply-templates mode="mal2html.block.mode" select="$revision/*"/>
        </div></div>
      </div></div>
    </xsl:if>
  </xsl:if>
</xsl:template>


<!-- == Matched Templates == -->

<xsl:template mode="html.title.mode" match="mal:page">
  <xsl:variable name="title" select="mal:info/mal:title[@type = 'text'][1]"/>
  <xsl:choose>
    <xsl:when test="$title">
      <xsl:value-of select="$title"/>
    </xsl:when>
    <xsl:otherwise>
      <xsl:value-of select="mal:title"/>
    </xsl:otherwise>
  </xsl:choose>
</xsl:template>

<xsl:template mode="html.header.mode" match="mal:page">
  <xsl:call-template name="mal2html.page.linktrails"/>
</xsl:template>

<xsl:template mode="html.footer.mode" match="mal:page">
  <xsl:call-template name="mal2html.page.about"/>
</xsl:template>

<xsl:template mode="html.body.mode" match="mal:page">
  <xsl:call-template name="mal2html.editor.banner"/>
  <xsl:choose>
    <xsl:when test="not(mal:links[@type = 'prevnext'])">
      <xsl:call-template name="mal2html.links.prevnext"/>
    </xsl:when>
    <xsl:otherwise>
      <xsl:apply-templates
          select="mal:links[@type = 'prevnext'][contains(concat(' ', @style, ' '), ' top ')]">
      </xsl:apply-templates>
    </xsl:otherwise>
  </xsl:choose>
  <xsl:apply-templates select="."/>
  <div class="clear"/>
</xsl:template>


<!--**==========================================================================
mal2html.section
Output HTML for a Mallard #{section} element.
:Revision:version="3.4" date="2012-01-26" status="final"
$node: The #{section} element.

This template outputs HTML for a #{section} element. It it called by the
templates that handle #{page} and #{section} elements.
-->
<xsl:template name="mal2html.section">
  <xsl:param name="node" select="."/>
  <section id="{$node/@id}">
    <xsl:call-template name="html.class.attr">
      <xsl:with-param name="node" select="$node"/>
      <xsl:with-param name="class">
        <xsl:if test="@ui:expanded or @uix:expanded">
          <xsl:text>ui-expander</xsl:text>
        </xsl:if>
      </xsl:with-param>
    </xsl:call-template>
    <xsl:call-template name="mal2html.ui.expander.data">
      <xsl:with-param name="node" select="$node"/>
    </xsl:call-template>
    <div class="inner">
      <xsl:apply-templates select="$node"/>
    </div>
  </section>
</xsl:template>


<!-- page | section -->
<xsl:template match="mal:page | mal:section">
  <xsl:variable name="type" select="/mal:page/@type"/>
  <xsl:variable name="depth" select="count(ancestor-or-self::mal:section) + 1"/>
  <xsl:variable name="topiclinks">
    <xsl:if test="$type = 'guide'">
      <xsl:call-template name="mal.link.topiclinks"/>
    </xsl:if>
  </xsl:variable>
  <xsl:variable name="topicnodes" select="exsl:node-set($topiclinks)/*"/>
  <xsl:variable name="guidelinks">
    <xsl:call-template name="mal.link.guidelinks"/>
  </xsl:variable>
  <xsl:variable name="guidenodes" select="exsl:node-set($guidelinks)/*"/>
  <xsl:variable name="seealsolinks">
    <xsl:call-template name="mal.link.seealsolinks"/>
  </xsl:variable>
  <xsl:variable name="seealsonodes" select="exsl:node-set($seealsolinks)/*"/>
  <xsl:variable name="allgroups">
    <xsl:if test="$type = 'guide'">
      <xsl:text> </xsl:text>
      <xsl:for-each select="mal:links[@type = 'topic']">
        <xsl:choose>
          <xsl:when test="@groups">
            <xsl:value-of select="@groups"/>
          </xsl:when>
          <xsl:otherwise>
            <xsl:text>#default</xsl:text>
          </xsl:otherwise>
        </xsl:choose>
        <xsl:text> </xsl:text>
      </xsl:for-each>
    </xsl:if>
  </xsl:variable>
  <div class="hgroup pagewide">
    <xsl:apply-templates mode="mal2html.title.mode" select="mal:title"/>
    <xsl:apply-templates mode="mal2html.title.mode" select="mal:subtitle"/>
  </div>
  <div class="region">
  <div class="contents pagewide">
    <xsl:call-template name="html.content.pre">
      <xsl:with-param name="page" select="boolean(self::mal:page)"/>
    </xsl:call-template>
    <xsl:for-each
        select="*[not(self::mal:section or self::mal:title or self::mal:subtitle)]">
      <xsl:choose>
        <xsl:when test="preceding-sibling::mal:section"/>
        <xsl:when test="self::mal:links[@type = 'topic']">
          <xsl:if test="$type = 'guide'">
            <xsl:apply-templates select=".">
              <xsl:with-param name="allgroups" select="$allgroups"/>
              <xsl:with-param name="links" select="$topicnodes"/>
            </xsl:apply-templates>
          </xsl:if>
        </xsl:when>
        <xsl:when test="self::mal:links[@type = 'guide']">
          <xsl:apply-templates select=".">
            <xsl:with-param name="links" select="$guidenodes"/>
          </xsl:apply-templates>
        </xsl:when>
        <xsl:when test="self::mal:links[@type = 'seealso']">
          <xsl:apply-templates select=".">
            <xsl:with-param name="links" select="$seealsonodes"/>
          </xsl:apply-templates>
        </xsl:when>
        <xsl:when test="self::mal:links[@type = 'prevnext']">
          <xsl:if test="not(contains(concat(' ', @style, ' '), ' top '))">
            <xsl:apply-templates select="."/>
          </xsl:if>
        </xsl:when>
        <xsl:when test="self::mal:links">
          <xsl:apply-templates select="."/>
        </xsl:when>
        <xsl:otherwise>
          <xsl:apply-templates mode="mal2html.block.mode" select="."/>
        </xsl:otherwise>
      </xsl:choose>
    </xsl:for-each>
    <xsl:if test="$type = 'guide'">
      <xsl:if test="not(mal:links[@type = 'topic'])">
        <xsl:call-template name="mal2html.links.topic">
          <xsl:with-param name="links" select="$topicnodes"/>
        </xsl:call-template>
      </xsl:if>
    </xsl:if>
    <xsl:if test="$type = 'gloss:glossary'">
      <xsl:call-template name="mal2html.gloss.terms"/>
    </xsl:if>
    <xsl:call-template name="html.content.post">
      <xsl:with-param name="page" select="boolean(self::mal:page)"/>
    </xsl:call-template>
  </div>
  <xsl:for-each select="mal:section">
    <xsl:call-template name="mal2html.section"/>
  </xsl:for-each>
  <xsl:if test="self::mal:page and not(mal:links[@type = 'prevnext'])">
    <xsl:call-template name="mal2html.links.prevnext"/>
  </xsl:if>
  <xsl:variable name="postlinks" select="mal:section/following-sibling::mal:links"/>
  <xsl:if test="(not(mal:section) and (
                  ($guidenodes and not(mal:links[@type = 'guide']))
                  or
                  ($seealsonodes and not(mal:links[@type = 'seealso']))
                )) or
                ($topicnodes and $postlinks[self::mal:links[@type = 'topic']]) or
                ($guidenodes and
                  ($postlinks[self::mal:links[@type = 'guide']] or
                    (mal:section and not(mal:links[@type = 'guide'])))) or
                ($seealsonodes and
                  ($postlinks[self::mal:links[@type = 'seealso']] or
                    (mal:section and not(mal:links[@type = 'seealso']))))
                ">
    <section class="links" role="navigation">
      <div class="inner">
      <div class="hgroup pagewide"/>
      <div class="contents pagewide">
        <xsl:for-each select="$postlinks">
          <xsl:choose>
            <xsl:when test="self::mal:links[@type = 'topic']">
              <xsl:if test="$type = 'guide'">
                <xsl:apply-templates select=".">
                  <xsl:with-param name="depth" select="$depth + 1"/>
                  <xsl:with-param name="allgroups" select="$allgroups"/>
                  <xsl:with-param name="links" select="$topicnodes"/>
                </xsl:apply-templates>
              </xsl:if>
            </xsl:when>
            <xsl:when test="self::mal:links[@type = 'guide']">
              <xsl:apply-templates select=".">
                <xsl:with-param name="depth" select="$depth + 1"/>
                <xsl:with-param name="links" select="$guidenodes"/>
              </xsl:apply-templates>
            </xsl:when>
            <xsl:when test="self::mal:links[@type = 'seealso']">
              <xsl:apply-templates select=".">
                <xsl:with-param name="depth" select="$depth + 1"/>
                <xsl:with-param name="links" select="$seealsonodes"/>
              </xsl:apply-templates>
            </xsl:when>
            <xsl:when test="self::mal:links[@type = 'prevnext']">
              <xsl:if test="not(contains(concat(' ', @style, ' '), ' top '))">
                <xsl:apply-templates select=".">
                  <xsl:with-param name="depth" select="$depth + 1"/>
                </xsl:apply-templates>
              </xsl:if>
            </xsl:when>
            <xsl:otherwise>
              <xsl:apply-templates select=".">
                <xsl:with-param name="depth" select="$depth + 1"/>
              </xsl:apply-templates>
            </xsl:otherwise>
          </xsl:choose>
        </xsl:for-each>
        <xsl:if test="$guidenodes and not(mal:links[@type = 'guide'])">
          <xsl:call-template name="mal2html.links.guide">
            <xsl:with-param name="depth" select="$depth + 1"/>
            <xsl:with-param name="links" select="$guidenodes"/>
          </xsl:call-template>
        </xsl:if>
        <xsl:if test="$seealsonodes and not(mal:links[@type = 'seealso'])">
          <xsl:call-template name="mal2html.links.seealso">
            <xsl:with-param name="depth" select="$depth + 1"/>
            <xsl:with-param name="links" select="$seealsonodes"/>
          </xsl:call-template>
        </xsl:if>
      </div>
      </div>
    </section>
  </xsl:if>
  </div>
</xsl:template>


<!--%%==========================================================================
mal2html.title.mode
Output headings for titles and subtitles.
:Revision:version="3.10" date="2013-07-10" status="final"

This template is called on #{title} and #{subtitle} elements that appear as
direct child content of #{page} or #{section} elements. Normal block titles
are processed in %{mal2html.block.mode}.
-->
<xsl:template mode="mal2html.title.mode" match="mal:title | mal:subtitle">
  <xsl:if test="not(contains(concat(' ', @style, ' '), ' hidden '))">
  <xsl:variable name="depth"
                select="count(ancestor::mal:section) + 1 + boolean(self::mal:subtitle)"/>
  <xsl:variable name="depth_">
    <xsl:choose>
      <xsl:when test="$depth &lt; 6">
        <xsl:value-of select="$depth"/>
      </xsl:when>
      <xsl:otherwise>
        <xsl:value-of select="6"/>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:variable>
  <xsl:element name="{concat('h', $depth_)}" namespace="{$html.namespace}">
    <xsl:call-template name="html.class.attr">
      <xsl:with-param name="class" select="local-name(.)"/>
    </xsl:call-template>
    <span class="{local-name(.)}">
      <xsl:apply-templates mode="mal2html.inline.mode"/>
    </span>
  </xsl:element>
  </xsl:if>
</xsl:template>

<!--%# html.css.mode -->
<xsl:template mode="html.css.mode" match="mal:page">
  <xsl:param name="direction">
    <xsl:call-template name="l10n.direction"/>
  </xsl:param>
  <xsl:param name="left">
    <xsl:call-template name="l10n.align.start">
      <xsl:with-param name="direction" select="$direction"/>
    </xsl:call-template>
  </xsl:param>
  <xsl:param name="right">
    <xsl:call-template name="l10n.align.end">
      <xsl:with-param name="direction" select="$direction"/>
    </xsl:call-template>
  </xsl:param>
<xsl:text>
<!-- links -->
div.links .desc a {
  color: inherit;
}
div.links .desc a:hover {
  color: </xsl:text><xsl:value-of select="$color.fg.blue"/><xsl:text>;
}
a.bold { font-weight: bold; }

<!-- link/@style = 'button' -->
div.link-button {
  font-size: 1.2em;
  font-weight: bold;
}
.link-button a {
  display: inline-block;
  background-color: </xsl:text>
    <xsl:value-of select="$color.blue"/><xsl:text>;
  color: </xsl:text>
    <xsl:value-of select="$color.bg"/><xsl:text>;
  text-shadow: </xsl:text>
    <xsl:value-of select="$color.fg.blue"/><xsl:text> 1px 1px 0px;
  border: solid 1px </xsl:text>
    <xsl:value-of select="$color.fg.blue"/><xsl:text>;
  padding: 0.2em 0.5em 0.2em 0.5em;
  border-radius: 2px;
}
.link-button a:visited {
  color: </xsl:text>
    <xsl:value-of select="$color.bg"/><xsl:text>;
}
.link-button a:hover {
  text-decoration: none;
  color: </xsl:text>
    <xsl:value-of select="$color.bg"/><xsl:text>;
  box-shadow: 1px 1px 1px </xsl:text>
    <xsl:value-of select="$color.blue"/><xsl:text>;
}
div.link-button a .desc {
  display: block;
  font-weight: normal;
  font-size: 0.83em;
  color: </xsl:text>
    <xsl:value-of select="$color.bg.gray"/><xsl:text>;
}

<!-- @style = 'float*' -->
div.floatleft {
  float: left;
  margin-right: 1em;
}
div.floatright {
  float: right;
  margin-left: 1em;
}
div.floatstart {
  float: </xsl:text><xsl:value-of select="$left"/><xsl:text>;
  margin-</xsl:text><xsl:value-of select="$right"/><xsl:text>: 1em;
}
div.floatend {
  float: </xsl:text><xsl:value-of select="$right"/><xsl:text>;
  margin-</xsl:text><xsl:value-of select="$left"/><xsl:text>: 1em;
}

<!-- FIXME -->
div.title-heading h1, div.title-heading h2, div.title-heading h3,
div.title-heading h4, div.title-heading h5, div.title-heading h6 {
  font-size: 1.72em;
  font-weight: bold;
}
ul.links-heading > li { margin: 2em 0 2em 0; padding: 0; }
div.links-heading > a { font-size: 1.72em; font-weight: bold; }
ul.links-heading > li > div.desc { margin-top: 0.5em; }

div.links-uix-hover {
  position: relative;
  display: flex;
  flex-flow: row nowrap;
  align-items: stretch;
  justify-content: flex-start;
}
ul.links-uix-hover { flex-grow: 1; }
ul.links-uix-hover li { margin: 0; padding: 0; }
ul.links-uix-hover a {
  display: block;
  padding: 8px 1.2em;
  border-bottom: none;
}
ul.links-uix-hover a:hover, ul.links-uix-hover a:focus {
  background: </xsl:text><xsl:value-of select="$color.bg.blue"/><xsl:text>;
}
ul.links-uix-hover img {
  display: block;
  position: absolute;
  top: 0; </xsl:text><xsl:value-of select="$left"/><xsl:text>: 0;
  visibility: hidden;
  opacity: 0.0;
  transition: opacity 0.6s, visibility 0.6s;
}
ul.links-uix-hover a:hover img, ul.links-uix-hover a:focus img {
  visibility: visible;
  opacity: 1.0;
  transition: opacity 0.2s, visibility 0.2s;
}
@media only screen and (max-width: 480px) {
  div.links-uix-hover-img { display: none; }
  ul.links-uix-hover img { display: none; }
  ul.links-uix-hover li {
    margin-left: -10px; margin-right: -10px;
  }
  ul.links-uix-hover li a {
    padding: 10px;
  }
}

<!-- uix:overlay -->
div.ui-overlay-screen {
  position: fixed;
  margin: 0;
  left: 0; top: 0;
  width: 100%; height: 100%;
  background: </xsl:text><xsl:value-of select="$color.fg.dark"/><xsl:text>;
  animation-name: yelp-overlay-screen;
  animation-duration: 0.8s;
  animation-fill-mode: forwards;
}
@keyframes yelp-overlay-screen {
  from { opacity: 0.0; }
  to   { opacity: 0.6; }
}
div.ui-overlay {
  display: none;
  position: fixed;
  text-align: center;
  top: 20px;
  left: 50%;
  transform: translateX(-50%);
  z-index: 10;
}
div.ui-overlay-show {
  animation-name: yelp-overlay-slide;
  animation-duration: 0.8s;
  animation-fill-mode: forwards;
}
@keyframes yelp-overlay-slide {
  from { transform: translateY(-400px) translateX(-50%); }
  to   { transform: translateY(0) translateX(-50%); }
}
div.ui-overlay > div.inner {
  display: inline-block;
  padding: 8px;
  background-color: </xsl:text><xsl:value-of select="$color.bg.gray"/><xsl:text>;
  border: solid 1px </xsl:text><xsl:value-of select="$color.fg.dark"/><xsl:text>;
  box-shadow: 0 2px 4px </xsl:text><xsl:value-of select="$color.fg.dark"/><xsl:text>;
  border-radius: 6px;
  text-align: </xsl:text><xsl:value-of select="$left"/><xsl:text>;
}
div.ui-overlay img, div.ui-overlay video {
  max-height: 80vh;
  max-width: 90vw;
}
div.ui-overlay > div.inner > div.title { margin-top: -4px; }
a.ui-overlay-close {
  display: block;
  float: </xsl:text><xsl:value-of select="$right"/><xsl:text>;
  width: 23px; height: 23px;
  font-size: 18px; line-height: 23px;
  font-weight: bold;
  margin-top: -28px;
  margin-</xsl:text><xsl:value-of select="$right"/><xsl:text>: -24px;
  padding: 1px 2px 3px 2px;
  text-align: center;
  border: none;
  border-radius: 50%;
  background-color: </xsl:text><xsl:value-of select="$color.fg"/><xsl:text>;
  background-image: radial-gradient(circle farthest-corner at 50% 30%, </xsl:text><xsl:value-of select="$color.fg.dark"/><xsl:text>, </xsl:text><xsl:value-of select="$color.fg"/><xsl:text>);
  border: 3px solid </xsl:text><xsl:value-of select="$color.bg"/><xsl:text>; 
  color: </xsl:text><xsl:value-of select="$color.bg"/><xsl:text>;
  box-shadow: 0 2px 2px </xsl:text><xsl:value-of select="$color.fg"/><xsl:text>;
  text-shadow: 0 2px 2px </xsl:text><xsl:value-of select="$color.fg"/><xsl:text>;
}

<!-- links/@uix:thumbs = 'tiles' -->
div.links-tiles {
  display: flex;
  flex-flow: row wrap;
  align-items: stretch;
  justify-content: stretch;
  vertical-align: top;
  clear: both;
  margin: 0 -10px;
}
div.links-tile {
  max-width: 300px;
  flex: 1 0 300px;
  vertical-align: top;
  margin: 0;
  padding: 10px;
}
div.links-tiles > div.links-tile { max-width: none; }
div.links-tile:empty { padding: 0 10px; height: 0; }
div.links-tile > a {
  display: block;
  vertical-align: top;
  padding: 9px;
  border-radius: 6px;
  border: solid 1px </xsl:text><xsl:value-of select="$color.bg"/><xsl:text>;
}
div.links-tile > a:hover {
  border: solid 1px </xsl:text><xsl:value-of select="$color.bg.blue"/><xsl:text>;
  box-shadow: 0 1px 2px </xsl:text><xsl:value-of select="$color.blue"/><xsl:text>;
}
div.links-tile > a > span.links-tile-img {
  display: block;
  text-align: center;
}
div.links-tile > a > span.links-tile-img > img {
  width: 100%;
  border-radius: 3px;
}
div.links-tile > a > span.links-tile-text > span.title {
  display: block;
  font-weight: bold;
}
div.links-tile > a > span.links-tile-text > * + span.title {
  margin-top: 0.5em;
}
div.links-tile > a > span.links-tile-text > span.desc {
  display: block;
  margin: 0.2em 0 0 0;
  color: </xsl:text><xsl:value-of select="$color.fg.dark"/><xsl:text>;
}

<!-- links/@style = 'grid' -->
div.links-grid-container {
  margin-left: -10px;
  margin-right: -10px;
  display: flex;
  flex-flow: row wrap;
  align-items: stretch;
  justify-content: flex-start;
  vertical-align: top;
  clear: both;
}
div.links-grid {
  flex: 1 0 300px;
  padding: 10px;
}
div.links-grid:empty { padding: 0 10px; height: 0; }
div.links-grid-link { font-weight: bold; }
div.links-grid > div.desc {
  margin: 0.2em 0 0 0;
  color: </xsl:text><xsl:value-of select="$color.fg.dark"/><xsl:text>;
}

<!-- FIXME -->
<!-- links/@style = 'norwich' -->
div.links-norwich {
  width: 900px;
}
div.links-norwich-primary {
  float: left;
  vertical-align: top;
  margin: 0; padding: 0;
}
div.links-norwich-big {
  vertical-align: top;
  display: inline-block;
  background: </xsl:text><xsl:value-of select="$color.bg.blue"/><xsl:text>;
  background: radial-gradient(ellipse 800px 1200px at 100% 20px, </xsl:text>
    <xsl:value-of select="$color.bg.blue"/><xsl:text>, </xsl:text>
    <xsl:value-of select="$color.blue"/><xsl:text>);
  margin: 0 20px 20px 0;
}
div.links-norwich-big + div.links-norwich-big {
  background: </xsl:text><xsl:value-of select="$color.bg.yellow"/><xsl:text>;
  background: radial-gradient(ellipse 800px 1200px at 100% 20px, </xsl:text>
    <xsl:value-of select="$color.bg.yellow"/><xsl:text>, </xsl:text>
    <xsl:value-of select="$color.yellow"/><xsl:text>);
}
div.links-norwich-big a {
  display: block;
  width: 230px;
  height: 500px;
  height: 320px;
  padding: 9px;
  font-size: 1.2em;
  color:  </xsl:text><xsl:value-of select="$color.fg"/><xsl:text>;
  border: solid 1px </xsl:text><xsl:value-of select="$color.blue"/><xsl:text>;
  background-repeat: no-repeat;
  background-position: right -80px bottom -80px;
}
div.links-norwich-big a:hover {
  border: solid 1px </xsl:text><xsl:value-of select="$color.blue"/><xsl:text>;
  box-shadow: 2px 2px 2px </xsl:text><xsl:value-of select="$color.blue"/><xsl:text>;
}
div.links-norwich-big a span.title {
  font-size: 1.2em;
  font-weight: bold;
}
div.links-norwich-big a .desc {
  color:  </xsl:text><xsl:value-of select="$color.fg"/><xsl:text>;
  font-weight: normal;
}
div.links-norwich-secondary {
  vertical-align: top;
  margin: 0; padding: 0;
}
div.links-norwich-small {
  display: inline-block;
  vertical-align: top;
  background: </xsl:text><xsl:value-of select="$color.bg.gray"/><xsl:text>;
  margin: 0 20px 20px 0;
}
div.links-norwich-small a {
  display: block;
  width: 140px;
  height: 140px;
  padding: 9px;
  font-weight: bold;
  color:  </xsl:text><xsl:value-of select="$color.fg"/><xsl:text>;
  border: solid 1px </xsl:text><xsl:value-of select="$color.gray"/><xsl:text>;
  background-repeat: no-repeat;
  background-position: right 4px bottom 4px;
}
div.links-norwich-small a:hover {
  border: solid 1px </xsl:text><xsl:value-of select="$color.gray"/><xsl:text>;
  box-shadow: 2px 2px 2px </xsl:text><xsl:value-of select="$color.blue"/><xsl:text>;
}
@media only screen and (max-width: 900px) {
  div.links-norwich {
    width: 720px;
  }
}
@media only screen and (max-width: 720px) {
  div.links-norwich {
    width: 540px;
  }
}
@media only screen and (max-width: 540px) {
  div.links-norwich {
    width: 100%;
  }
  div.links-norwich-big {
    width: 100%;
    margin-right: 0;
  }
  div.links-norwich-big a {
    width: auto;
  }
}

<!-- links/@type = 'topic' and @style = '2column' -->
div.links-divs {
  margin-left: -10px;
  margin-right: -10px;
}
a.linkdiv {
  display: block;
  margin: 0;
  padding: 10px;
  border-bottom: none;
}
a.linkdiv:hover {
  text-decoration: none;
  background-color: </xsl:text>
    <xsl:value-of select="$color.bg.blue"/><xsl:text>;
}
a.linkdiv > span.title {
  display: block;
  margin: 0;
  font-size: 1em;
  font-weight: bold;
  color: inherit;
}
a.linkdiv > span.desc {
  display: block;
  margin: 0.2em 0 0 0;
  color: </xsl:text><xsl:value-of select="$color.fg.dark"/><xsl:text>;
}
span.linkdiv-dash { display: none; }
div.links-twocolumn {
  display: flex;
  flex-flow: row wrap;
  align-items: stretch;
  justify-content: flex-start;
  vertical-align: top;
  margin-left: -10px;
  margin-right: -10px;
}
div.links-twocolumn > div.links-divs {
  flex: 1 0 320px;
  vertical-align: top;
  margin: 0;
}

<!-- FIXME -->
div.comment {
  padding: 0.5em;
  border: solid 2px </xsl:text>
    <xsl:value-of select="$color.red"/><xsl:text>;
  background-color: </xsl:text>
    <xsl:value-of select="$color.bg.red"/><xsl:text>;
}
div.comment div.comment {
  margin: 1em 1em 0 1em;
}
div.comment div.cite {
  margin: 0 0 0.5em 0;
  font-style: italic;
}

<!-- FIXME -->
div.tree > div.inner > div.title { margin-bottom: 0.5em; }
ul.tree {
  margin: 0; padding: 0;
  list-style-type: none;
}
li.tree { margin: -2px 0 0 0; padding: 0; }
li.tree div { margin: 0; padding: 0; }
ul.tree ul.tree {
  margin-</xsl:text><xsl:value-of select="$left"/><xsl:text>: 1.44em;
}
div.tree-lines ul.tree { margin-left: 0; }

<!-- FIXME -->
span.hi {
  background-color: </xsl:text>
    <xsl:value-of select="$color.bg.yellow"/><xsl:text>;
}

<!-- experimental/gloss -->
dt.gloss-term {
  margin-top: 1.2em;
  font-weight: bold;
  color: </xsl:text><xsl:value-of select="$color.fg.dark"/><xsl:text>;
}
dt.gloss-term:first-child, dt.gloss-term + dt.gloss-term { margin-top: 0; }
dt.gloss-term + dd { margin-top: 0.2em; }
dd.gloss-link {
  margin: 0 0.2em 0 0.2em;
  border-</xsl:text><xsl:value-of select="$left"/><xsl:text>: solid 4px </xsl:text>
    <xsl:value-of select="$color.blue"/><xsl:text>;
  padding-</xsl:text><xsl:value-of select="$left"/><xsl:text>: 1em;
}
dd.gloss-def {
  margin: 0 0.2em 1em 0.2em;
  border-</xsl:text><xsl:value-of select="$left"/><xsl:text>: solid 4px </xsl:text>
    <xsl:value-of select="$color.gray"/><xsl:text>;
  padding-</xsl:text><xsl:value-of select="$left"/><xsl:text>: 1em;
}
a.gloss-term {
  position: relative;
  border-bottom: dashed 1px </xsl:text>
    <xsl:value-of select="$color.blue"/><xsl:text>;
}
a.gloss-term:hover {
  text-decoration: none;
  border-bottom-style: solid;
}
span.gloss-desc {
  display: none;
  position: absolute;
  z-index: 100;
  margin: 0;
  </xsl:text><xsl:value-of select="$left"/><xsl:text>: 0;
  top: 1.2em;
  padding: 0.2em 0.5em 0.2em 0.5em;
  min-width: 12em;
  max-width: 24em;
  overflow: hidden;
  color: </xsl:text><xsl:value-of select="$color.fg.dark"/><xsl:text>;
  background-color: </xsl:text>
    <xsl:value-of select="$color.bg.yellow"/><xsl:text>;
  border: solid 1px </xsl:text>
    <xsl:value-of select="$color.yellow"/><xsl:text>;
  box-shadow: 2px 2px 4px </xsl:text>
    <xsl:value-of select="$color.gray"/><xsl:text>;
}
a.gloss-term:hover span.gloss-desc, a.gloss-term:focus span.gloss-desc {
  display: inline-block;
  animation-name: yelp-gloss-fade;
  animation-duration: 1s;
  animation-fill-mode: forwards;
}
@keyframes yelp-gloss-fade {
  from { opacity: 0.0; }
  to   { opacity: 1.0; }
}

<!-- conditional processing -->
.if-if { display: none; }
.if-choose, .if-when, .if-else { margin: 0; padding: 0; }
.if-choose > .if-when { display: none; }
.if-choose > .if-else { display: block; }
.if-if.if__not-target-mobile { display: block; }
.if-choose.if__not-target-mobile > .if-when { display: block; }
.if-choose.if__not-target-mobile > .if-else { display: none; }
@media only screen and (max-width: 480px) {
  .if-if.if__target-mobile { display: block; }
  .if-if.if__not-target-mobile { display: none; }
  .if-choose.if__target-mobile > .if-when { display: block; }
  .if-choose.if__target-mobile > .if-else { display: none; }
  .if-choose.if__not-target-mobile > .if-when { display: none; }
  .if-choose.if__not-target-mobile > .if-else { display: block; }
}
</xsl:text>
<xsl:if test="$mal2html.editor_mode">
<xsl:text>
div.note-version {
  background-color: </xsl:text>
    <xsl:value-of select="$color.bg.yellow"/><xsl:text>;
  margin-top: 1em;
  margin-bottom: 1em;
}
span.status {
  font-size: 0.83em;
  font-weight: normal;
  padding-left: 0.2em;
  padding-right: 0.2em;
  color: </xsl:text>
    <xsl:value-of select="$color.fg.dark"/><xsl:text>;
  border: solid 1px </xsl:text>
    <xsl:value-of select="$color.red"/><xsl:text>;
  background-color: </xsl:text>
    <xsl:value-of select="$color.bg.yellow"/><xsl:text>;
}
span.status-stub, span.status-draft, span.status-incomplete, span.status-outdated { background-color: </xsl:text>
  <xsl:value-of select="$color.bg.red"/><xsl:text>; }
</xsl:text>
</xsl:if>
</xsl:template>

<!--%# html.js.mode -->
<xsl:template mode="html.js.mode" match="mal:page">
<xsl:text><![CDATA[
document.addEventListener('DOMContentLoaded', function() {
  var tiles = document.querySelectorAll('div.links-tile');
  for (var i = 0; i < tiles.length; i++) {
    (function (tile) {
      if (!tile.parentNode.classList.contains('links-tiles') &&
          (tile.nextElementSibling &&
           tile.nextElementSibling.classList.contains('links-tile')) &&
          !(tile.previousElementSibling &&
            tile.previousElementSibling.classList.contains('links-tile'))) {
        var tilesdiv = document.createElement('div');
        tilesdiv.className = 'links-tiles';
        tile.parentNode.insertBefore(tilesdiv, tile);
        var cur = tile;
        while (cur && cur.classList.contains('links-tile')) {
          var curcur = cur;
          cur = cur.nextElementSibling;
          tilesdiv.appendChild(curcur);
        }
        for (j = 0; j < 2; j++) {
          var paddiv = document.createElement('div');
          paddiv.className = 'links-tile';
          tilesdiv.appendChild(paddiv);
        }
      }
    })(tiles[i]);
  }
});
document.addEventListener('DOMContentLoaded', function() {
  var overlays = document.querySelectorAll('a.ui-overlay');
  for (var i = 0; i < overlays.length; i++) {
    (function (ovlink) {
      var overlay = ovlink.parentNode.querySelector('div.ui-overlay');
      var ui_overlay_show = function (ev) {
        overlay.style.display = 'block';
        overlay.classList.add('ui-overlay-show');
        var screen = document.querySelector('div.ui-overlay-screen');
        if (screen == null) {
          screen = document.createElement('div');
          screen.className = 'ui-overlay-screen';
          document.body.appendChild(screen);
        }
        var inner = overlay.querySelector('div.inner');
        var close = inner.querySelector('a.ui-overlay-close');
        var media = inner.querySelectorAll('audio, video');

        var overlay_play_func = function () {
          for (var j = 0; j < media.length; j++) {
            media[j].play();
          }
        };
        var overlay_play_timeout = window.setTimeout(overlay_play_func, 1000);

        var ui_overlay_funcs = {};
        ui_overlay_funcs['hide'] = function () {
          overlay.style.display = 'none';
          document.body.removeChild(screen);
          document.removeEventListener('keydown', ui_overlay_funcs['keydown'], false);
          for (var j = 0; j < media.length; j++) {
            media[j].pause();
          }
          window.clearTimeout(overlay_play_timeout);
        };
        ui_overlay_funcs['hideclick'] = function (uiev) {
          ui_overlay_funcs['hide']();
          uiev.preventDefault();
        };
        ui_overlay_funcs['keydown'] = function (uiev) {
          if (uiev.keyCode == 27) {
            ui_overlay_funcs['hide']();
          }
        };
        screen.addEventListener('click', ui_overlay_funcs['hideclick'], false);
        close.addEventListener('click', ui_overlay_funcs['hideclick'], false);
        document.addEventListener('keydown', ui_overlay_funcs['keydown'], false);
        ev.preventDefault();
      };
      ovlink.addEventListener('click', ui_overlay_show, false);
    })(overlays[i]);
  }
});
]]></xsl:text>
</xsl:template>

</xsl:stylesheet>
