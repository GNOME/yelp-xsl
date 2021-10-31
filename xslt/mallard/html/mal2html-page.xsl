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
@revision[version=3.8 date=2012-11-05 status=final]

This stylesheet contains templates to process Mallard `page` and `section`
elements, including implementations of the interfaces provided by the common
{html} stylesheet.
-->
<xsl:template match="/">
  <xsl:for-each select="mal:page | mal:stack/mal:page">
    <xsl:call-template name="html.output"/>
  </xsl:for-each>
</xsl:template>


<!--@@==========================================================================
mal2html.editor_mode
Add information that's useful to writers and editors.
@revision[version=3.8 date=2012-11-05 status=final]

When this parameter is set to true, these stylesheets will output editorial
comments, status markers, and other information that's useful to writers and
editors.
-->
<xsl:param name="mal2html.editor_mode" select="false()"/>


<!--**==========================================================================
mal2html.page.about
Output the copyrights, credits, and license information at the bottom of a page.
@revision[version=3.8 date=2012-11-05 status=final]

[xsl:params]
$node: The top-level `page` element.

This template outputs copyright information, credits, and license information for
the page. By default it is called by the {html.footer.mode} implementation for
the `page` element. Information is extracted from the `info` element of $node.
-->
<xsl:template name="mal2html.page.about">
  <xsl:param name="node" select="."/>
  <xsl:variable name="infos" select="$node/mal:info | $node/parent::mal:stack/mal:info"/>
  <xsl:if test="$infos/mal:credit or $infos/mal:license">
  <div class="about ui-expander" role="contentinfo">
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
        <xsl:variable name="credits" select="$infos/mal:credit"/>
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
        <xsl:for-each select="$infos/mal:license">
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
  </div>
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
@revision[version=3.4 date=2011-11-19 status=final]

[xsl:params]
$node: The top-level `page` element.

This template outputs all of the link trails for the page $node. It gets the
trails from $mal.link.linktrails. If the result is non-empty, it outputs a
wrapper `div`, sorts the trails, and calls {mal2html.page.linktrails.trail}
on each one. Otherwise, it calls the stub template {mal2html.page.linktrails.empty}.
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
          <xsl:call-template name="mal2html.page.linktrails.trail">
            <xsl:with-param name="page" select="$node"/>
          </xsl:call-template>
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
@revision[version=3.20 date=2015-09-17 status=final]

[xsl:params]
$node: The top-level `page` element.

This template is deprecated. Use {html.linktrails.empty} instead. By default,
this template calls {html.linktrails.empty}, passing the $node parameter.

This template is a stub. It is called by $mal2html.page.linktrails when there
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
@revision[version=42 date=2021-10-30 status=final]

[xsl:params]
$page: The source element for which an output page is being made.
$node: A `link` element from {mal.link.linktrails}.

This template outputs an HTML `div` element containing all the links in a
single link trail. It calls {html.linktrails.prefix} (by way of 
{mal2html.page.linktrails.trail.prefix}) to output a custom boilerplate prefix,
then calls {mal2html.page.linktrails.link} to output the actual links.

[note .plain]
The $page parameter was added in version 42.
-->
<xsl:template name="mal2html.page.linktrails.trail">
  <xsl:param name="page" select="."/>
  <xsl:param name="node" select="."/>
  <div class="trail">
    <xsl:call-template name="mal2html.page.linktrails.trail.prefix">
      <xsl:with-param name="page" select="$page"/>
      <xsl:with-param name="node" select="$node"/>
    </xsl:call-template>
    <xsl:call-template name="mal2html.page.linktrails.link">
      <xsl:with-param name="page" select="$page"/>
      <xsl:with-param name="node" select="$node"/>
    </xsl:call-template>
  </div>
</xsl:template>


<!--**==========================================================================
mal2html.page.linktrails.trail.prefix
Deprecated stub to output extra content before a link trail.
:Stub: true
@revision[version=42 date=2021-10-30 status=final]

[xsl:params]
$page: The source element for which an output page is being made.
$node: A `link` element from {mal.link.linktrails}.

This template is deprecated. Use {html.linktrails.prefix} instead. By default,
this template calls {html.linktrails.prefix}, passing the $node parameter.

This template is a stub. It is called by {mal2html.page.linktrails.trail} for
each link trail before the normal links are output with
{mal2html.page.linktrails.link}. This template is useful for adding extra site
links at the beginning of each link trail.

[note .plain]
The $page parameter was added in version 42.
-->
<xsl:template name="mal2html.page.linktrails.trail.prefix">
  <xsl:param name="page" select="."/>
  <xsl:param name="node" select="."/>
  <xsl:call-template name="html.linktrails.prefix">
    <xsl:with-param name="page" select="$page"/>
    <xsl:with-param name="node" select="$node"/>
  </xsl:call-template>
</xsl:template>


<!--**==========================================================================
mal2html.page.linktrails.link
Output a link and the following links in a link trail.
@revision[version=42 date=2021-11-19 status=final]

[xsl:params]
$page: The source element for which an output page is being made.
$node: A `link` element from {mal.link.linktrails}.
$direction: The text directionality.

This template is called by {mal2html.page.linktrails.trail} to output the links
in a trail. Link trails returned by {mal.link.linktrails} are returned as nested
`link` elements. This template takes one of those elements, outputs an HTML `a`
element, then calls itself recursively on the child `link` element, if it exists.

The $direction parameter specifies the current text directionality. If not
provided, it is computed automatically with {l10n.direction}. It determines the
separators used between links.

[note .plain]
The $page parameter was added in version 42.
-->
<xsl:template name="mal2html.page.linktrails.link">
  <xsl:param name="page" select="."/>
  <xsl:param name="node" select="."/>
  <xsl:param name="direction">
    <xsl:call-template name="l10n.direction">
      <xsl:with-param name="node" select="$page"/>
    </xsl:call-template>
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
      <xsl:with-param name="page" select="$page"/>
      <xsl:with-param name="direction" select="$direction"/>
    </xsl:call-template>
  </xsl:for-each>
</xsl:template>


<!--**==========================================================================
mal2html.editor.badge
Output a badge for a link showing the revision status of the target.
@revision[version=3.8 date=2012-11-05 status=final]

[xsl:params]
$target: The page or section being linked to.

This template may be called by link formatters to output a badge showing the
revision status of the linked-to page or section. It only outputs a badge if
{mal2html.editor_mode} is `true`.
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
@revision[version=3.8 date=2012-11-05 status=final]

[xsl:params]
$node: The top-level `page` element.

This template is called by the {html.body.mode} implementation for `page`
elements. It outputs a banner providing information about the revision status
of $node. It only outputs a banner if {mal2html.editor_mode} is `true`.
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

<!--%# html.title.mode -->
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

<!--%# html.header.mode -->
<xsl:template mode="html.header.mode" match="mal:page">
  <xsl:call-template name="mal2html.page.linktrails"/>
</xsl:template>

<!--%# html.footer.mode -->
<xsl:template mode="html.footer.mode" match="mal:page">
  <xsl:call-template name="mal2html.page.about"/>
</xsl:template>

<!--%# html.sidebar.contents.mode -->
<xsl:template mode="html.sidebar.contents.mode" match="mal:page">
  <xsl:param name="side"/>
  <xsl:variable name="page" select="."/>
  <div class="sidebar-contents">
    <div class="inner">
      <div class="title">
        <h2>
          <span class="title">
            <xsl:call-template name="l10n.gettext">
              <xsl:with-param name="msgid" select="'Contents'"/>
            </xsl:call-template>
          </span>
        </h2>
      </div>
      <div class="region">
        <div class="contents">
          <xsl:for-each select="$mal.cache">
            <xsl:for-each select="key('mal.cache.key', $mal.link.default_root)">
              <xsl:call-template name="_html.sidebar.contents.ul"/>
            </xsl:for-each>
          </xsl:for-each>
        </div>
      </div>
    </div>
  </div>
</xsl:template>

<xsl:template name="_html.sidebar.contents.ul">
  <xsl:param name="node" select="."/>
  <ul>
    <xsl:if test="$node/self::mal:page">
      <li class="links">
        <a>
          <xsl:attribute name="href">
            <xsl:call-template name="mal.link.target">
              <xsl:with-param name="xref" select="$node/@id"/>
            </xsl:call-template>
          </xsl:attribute>
          <xsl:attribute name="title">
            <xsl:call-template name="mal.link.tooltip">
              <xsl:with-param name="xref" select="$node/@id"/>
            </xsl:call-template>
          </xsl:attribute>
          <xsl:call-template name="mal.link.content">
            <xsl:with-param name="xref" select="$node/@id"/>
          </xsl:call-template>
        </a>
      </li>
    </xsl:if>
    <xsl:if test="$node/self::mal:section">
      <li class="links links-head">
        <xsl:choose>
          <xsl:when test="$node/mal:info/mal:title[@type = 'link'][not(@role)]">
            <xsl:apply-templates mode="mal2html.inline.mode"
                                 select="$node/mal:info/mal:title[@type = 'link'][not(@role)][1]/node()"/>
          </xsl:when>
          <xsl:otherwise>
            <xsl:apply-templates mode="mal2html.inline.mode" select="$node/mal:title/node()"/>
          </xsl:otherwise>
        </xsl:choose>
      </li>
    </xsl:if>
    <!-- FIXME: Ideally we'd group and sort based on links elements, but those
         aren't in the cache file, so that's harder.
    -->
    <xsl:variable name="links_">
      <xsl:call-template name="mal.link.topiclinks">
        <xsl:with-param name="node" select="."/>
      </xsl:call-template>
    </xsl:variable>
    <xsl:variable name="links" select="exsl:node-set($links_)/*"/>
    <xsl:for-each select="$links">
      <xsl:sort data-type="number" select="@groupsort"/>
      <xsl:sort select="mal:title[@type = 'sort']"/>
      <li class="links">
        <a>
          <xsl:attribute name="href">
            <xsl:call-template name="mal.link.target"/>
          </xsl:attribute>
          <xsl:attribute name="title">
            <xsl:call-template name="mal.link.tooltip"/>
          </xsl:attribute>
          <xsl:call-template name="mal.link.content"/>
        </a>
      </li>
    </xsl:for-each>
    <xsl:for-each select="$node/mal:section">
      <li class="links">
        <xsl:call-template name="_html.sidebar.contents.ul"/>
      </li>
    </xsl:for-each>
  </ul>
</xsl:template>

<!--%# html.sidebar.sections.mode -->
<xsl:template mode="html.sidebar.sections.mode" match="mal:page">
  <xsl:param name="side"/>
  <xsl:if test="mal:section">
    <div class="sidebar-sections">
      <div class="inner">
        <div class="title">
          <h2>
            <span class="title">
              <xsl:call-template name="l10n.gettext">
                <xsl:with-param name="msgid" select="'On This Page'"/>
              </xsl:call-template>
            </span>
          </h2>
        </div>
        <div class="region">
          <div class="contents">
            <xsl:call-template name="_mal2html.links.section.ul">
              <xsl:with-param name="node" select="."/>
              <xsl:with-param name="nodesc" select="true()"/>
            </xsl:call-template>
          </div>
        </div>
      </div>
    </div>
  </xsl:if>
</xsl:template>

<!--%# html.body.mode -->
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
Output HTML for a Mallard `section` element.
@revision[version=3.4 date=2012-01-26 status=final]

[xsl:params]
$node: The `section` element.

This template outputs HTML for a `section` element. It it called by the
templates that handle `page` and `section` elements.
-->
<xsl:template name="mal2html.section">
  <xsl:param name="node" select="."/>
  <section id="{$node/@id}">
    <xsl:call-template name="html.class.attr">
      <xsl:with-param name="node" select="$node"/>
      <xsl:with-param name="class">
        <xsl:call-template name="mal2html.ui.expander.class">
          <xsl:with-param name="node" select="$node"/>
        </xsl:call-template>
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
  <xsl:variable name="type" select="ancestor-or-self::mal:page[1]/@type"/>
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
@revision[version=3.10 date=2013-07-10 status=final]

This template is called on `title` and `subtitle` elements that appear as
direct child content of `page` or `section` elements. Normal block titles
are processed in {mal2html.block.mode}.
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

<!-- We need this in the CSS, but the text templates can't xsl:call-template -->
<xsl:variable name="_color.link_button_hover">
  <xsl:call-template name="color.blend">
    <xsl:with-param name="bg" select="$color.blue"/>
    <xsl:with-param name="fg" select="$color.bg"/>
    <xsl:with-param name="mix" select="0.1"/>
  </xsl:call-template>
</xsl:variable>

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
  <xsl:call-template name="tmpl.file">
    <xsl:with-param name="file" select="'css/mallard.css.tmpl'"/>
    <xsl:with-param name="node" select="."/>
    <xsl:with-param name="direction" select="$direction"/>
    <xsl:with-param name="left" select="$left"/>
    <xsl:with-param name="right" select="$right"/>
  </xsl:call-template>
  <xsl:if test="$mal2html.editor_mode">
    <xsl:call-template name="tmpl.file">
      <xsl:with-param name="file" select="'css/mallard-editor.css.tmpl'"/>
      <xsl:with-param name="node" select="."/>
      <xsl:with-param name="direction" select="$direction"/>
      <xsl:with-param name="left" select="$left"/>
      <xsl:with-param name="right" select="$right"/>
    </xsl:call-template>
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
