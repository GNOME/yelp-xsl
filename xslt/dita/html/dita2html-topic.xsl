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
                xmlns:exsl="http://exslt.org/common"
                xmlns:str="http://exslt.org/strings"
                xmlns:yelp="http://projects.gnome.org/yelp/"
                xmlns:msg="http://projects.gnome.org/yelp/gettext/"
                xmlns="http://www.w3.org/1999/xhtml"
                exclude-result-prefixes="exsl str yelp msg"
                version="1.0">

<!--!!==========================================================================
DITA to HTML - Topics

REMARK: Describe this module
-->


<xsl:template match="/">
  <xsl:choose>
    <xsl:when test="&map_map;">
      <xsl:for-each select="$dita.map">
        <xsl:call-template name="html.output">
          <xsl:with-param name="node" select="&map_map;"/>
          <xsl:with-param name="href" select="concat('index', $html.extension)"/>
        </xsl:call-template>
      </xsl:for-each>
    </xsl:when>
    <xsl:otherwise>
      <xsl:message>
        <xsl:text>Unmatched root element: </xsl:text>
        <xsl:value-of select="local-name(*)"/>
      </xsl:message>
    </xsl:otherwise>
  </xsl:choose>
</xsl:template>


<!-- == dita2html.links.prevnext == -->
<xsl:template name="dita2html.links.prevnext">
  <xsl:param name="node" select="."/>
  <xsl:variable name="prev" select="($node/ancestor::&map_topicref;[@href][1] |
                                     $node/preceding::&map_topicref;[@href][1] |
                                     $node/ancestor::&map_map;[1]
                                    )[last()]"/>
  <xsl:variable name="next" select="($node//&map_topicref;[@href][1] |
                                     $node/following::&map_topicref;[@href]
                                    )[1]"/>
  <div class="links nextlinks">
    <xsl:if test="$prev">
      <a class="nextlinks-prev">
        <xsl:attribute name="href">
          <xsl:for-each select="str:split($node/@href, '/')">
            <xsl:if test="position() != last()">
              <xsl:text>../</xsl:text>
            </xsl:if>
          </xsl:for-each>
          <xsl:choose>
            <xsl:when test="$prev[self::&map_map;]">
              <xsl:call-template name="dita.ref.href.target">
                <xsl:with-param name="href" select="'index'"/>
              </xsl:call-template>
            </xsl:when>
            <xsl:otherwise>
              <xsl:call-template name="dita.ref.href.target">
                <xsl:with-param name="node" select="$prev"/>
              </xsl:call-template>
            </xsl:otherwise>
          </xsl:choose>
        </xsl:attribute>
        <xsl:attribute name="title">
          <xsl:call-template name="dita.ref.topicref.navtitle">
            <xsl:with-param name="node" select="$prev"/>
          </xsl:call-template>
        </xsl:attribute>
        <xsl:call-template name="l10n.gettext">
          <xsl:with-param name="msgid" select="'Previous'"/>
        </xsl:call-template>
      </a>
    </xsl:if>
    <xsl:if test="$next">
      <a class="nextlinks-next">
        <xsl:attribute name="href">
          <xsl:for-each select="str:split($node/@href, '/')">
            <xsl:if test="position() != last()">
              <xsl:text>../</xsl:text>
            </xsl:if>
          </xsl:for-each>
          <xsl:call-template name="dita.ref.href.target">
            <xsl:with-param name="node" select="$next"/>
          </xsl:call-template>
        </xsl:attribute>
        <xsl:attribute name="title">
          <xsl:call-template name="dita.ref.topicref.navtitle">
            <xsl:with-param name="node" select="$next"/>
          </xsl:call-template>
        </xsl:attribute>
        <xsl:call-template name="l10n.gettext">
          <xsl:with-param name="msgid" select="'Next'"/>
        </xsl:call-template>
      </a>
    </xsl:if>
  </div>
</xsl:template>


<!-- == dita2html.links.topic == -->
<xsl:template name="dita2html.links.topic">
  <xsl:param name="source" select="."/>
  <xsl:if test="$source/&map_topicref;">
    <div class="links sectionlinks" role="navigation">
      <ul>
        <xsl:apply-templates mode="dita2html.links.topic.mode" select="$source/&map_topicref;">
          <xsl:with-param name="source" select="$source"/>
        </xsl:apply-templates>
      </ul>
    </div>
  </xsl:if>
</xsl:template>

<xsl:template mode="dita2html.links.topic.mode" match="*"/>
<xsl:template mode="dita2html.links.topic.mode" match="&map_topicref;">
  <xsl:param name="source" select=".."/>
  <li class="links">
    <xsl:choose>
      <xsl:when test="@href">
        <a>
          <xsl:attribute name="href">
            <xsl:for-each select="str:split($source/@href, '/')">
              <xsl:if test="position() != last()">
                <xsl:text>../</xsl:text>
              </xsl:if>
            </xsl:for-each>
            <xsl:call-template name="dita.ref.href.target"/>
          </xsl:attribute>
          <xsl:call-template name="dita.ref.topicref.navtitle"/>
        </a>
        <xsl:variable name="desc">
          <xsl:call-template name="dita.ref.topicref.shortdesc"/>
        </xsl:variable>
        <xsl:if test="$desc != ''">
          <span class="desc">
            <xsl:text> &#x2014; </xsl:text>
            <xsl:copy-of select="$desc"/>
          </span>
        </xsl:if>
      </xsl:when>
      <xsl:otherwise>
        <xsl:call-template name="dita.ref.topicref.navtitle"/>
        <xsl:if test="&map_topicref;">
          <ul>
            <xsl:apply-templates mode="dita2html.links.topic.mode" select="&map_topicref;">
              <xsl:with-param name="source" select="$source"/>
            </xsl:apply-templates>
          </ul>
        </xsl:if>
      </xsl:otherwise>
    </xsl:choose>
  </li>
</xsl:template>


<!-- == dita2html.topic.about == -->
<xsl:template name="dita2html.topic.about">
  <xsl:param name="node" select="."/>
  <xsl:variable name="info" select="yelp:dita.ref.conref($node/&topic_prolog;) |
                                    yelp:dita.ref.conref($node/&map_topicmeta;)"/>
  <xsl:variable name="copyrights" select="$info/&topic_copyright;"/>
  <xsl:variable name="authors" select="$info/&topic_author;[@type = 'creator']"/>
  <xsl:variable name="translators" select="$info/&topic_author;[@type = 'translator']"/>
  <xsl:variable name="publishers" select="$info/&topic_publisher;"/>
  <xsl:variable name="others" select="$info/&topic_author;[not(@type = 'creator' or @type = 'translator')]"/>
  <xsl:if test="$copyrights or $authors or $translators or $publishers or $others">
    <div class="sect about ui-expander" role="contentinfo">
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
            <xsl:if test="$authors">
              <div class="aboutblurb authors">
                <div class="title">
                  <span class="title">
                    <xsl:call-template name="l10n.gettext">
                      <xsl:with-param name="msgid" select="'Written By'"/>
                    </xsl:call-template>
                  </span>
                </div>
                <ul class="credits">
                  <xsl:for-each select="$authors">
                    <li>
                      <xsl:apply-templates mode="dita2html.topic.mode"/>
                    </li>
                  </xsl:for-each>
                </ul>
              </div>
            </xsl:if>
            <xsl:if test="$translators">
              <div class="aboutblurb translators">
                <div class="title">
                  <span class="title">
                    <xsl:call-template name="l10n.gettext">
                      <xsl:with-param name="msgid" select="'Translated By'"/>
                    </xsl:call-template>
                  </span>
                </div>
                <ul class="credits">
                  <xsl:for-each select="$translators">
                    <li>
                      <xsl:apply-templates mode="dita2html.topic.mode"/>
                    </li>
                  </xsl:for-each>
                </ul>
              </div>
            </xsl:if>
            <xsl:if test="$publishers">
              <div class="aboutblurb publishers">
                <div class="title">
                  <span class="title">
                    <xsl:call-template name="l10n.gettext">
                      <xsl:with-param name="msgid" select="'Published By'"/>
                    </xsl:call-template>
                  </span>
                </div>
                <ul class="credits">
                  <xsl:for-each select="$publishers">
                    <li>
                      <xsl:apply-templates mode="dita2html.topic.mode"/>
                    </li>
                  </xsl:for-each>
                </ul>
              </div>
            </xsl:if>
            <xsl:if test="$others">
              <div class="aboutblurb othercredits">
                <div class="title">
                  <span class="title">
                    <xsl:call-template name="l10n.gettext">
                      <xsl:with-param name="msgid" select="'Other Credits'"/>
                    </xsl:call-template>
                  </span>
                </div>
                <ul class="credits">
                  <xsl:for-each select="$others">
                    <li>
                      <xsl:apply-templates mode="dita2html.topic.mode"/>
                    </li>
                  </xsl:for-each>
                </ul>
              </div>
            </xsl:if>
          </div>
        </div>
      </div>
    </div>
  </xsl:if>
</xsl:template>

<xsl:template mode="l10n.format.mode" match="msg:copyright.years">
  <xsl:param name="node"/>
  <xsl:value-of select="$node/&topic_copyryear;/@year"/>
</xsl:template>

<xsl:template mode="l10n.format.mode" match="msg:copyright.name">
  <xsl:param name="node"/>
  <xsl:apply-templates mode="dita2html.topic.mode"
                       select="$node/&topic_copyrholder;/node()"/>
</xsl:template>


<!--#% html.output.after.mode -->
<xsl:template mode="html.output.after.mode" match="/&map_map; | &map_topicref;">
  <xsl:for-each select="&map_topicref;">
    <xsl:choose>
      <xsl:when test="@href">
        <xsl:call-template name="html.output">
          <xsl:with-param name="href">
            <xsl:call-template name="dita.ref.href.target"/>
          </xsl:with-param>
        </xsl:call-template>
      </xsl:when>
      <xsl:otherwise>
        <xsl:apply-templates mode="html.output.after.mode" select="."/>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:for-each>
</xsl:template>


<!-- == map == -->

<!-- = map % html.title.mode = -->
<xsl:template mode="html.title.mode" match="&map_map;">
  <xsl:choose>
    <xsl:when test="&topic_booktitle;/&topic_mainbooktitle;">
      <xsl:value-of select="&topic_booktitle;/&topic_mainbooktitle;"/>
    </xsl:when>
    <xsl:otherwise>
      <xsl:value-of select="&topic_title_all;"/>
    </xsl:otherwise>
  </xsl:choose>
</xsl:template>

<!-- = map % html.header.mode = -->
<xsl:template mode="html.header.mode" match="&map_map;">
  <xsl:call-template name="html.linktrails.empty">
    <xsl:with-param name="node" select="."/>
  </xsl:call-template>
</xsl:template>

<!-- = map % html.footer.mode = -->
<xsl:template mode="html.footer.mode" match="&map_map;">
  <xsl:call-template name="dita2html.topic.about"/>
</xsl:template>

<!-- = map % html.body.mode = -->
<xsl:template mode="html.body.mode" match="&map_map;">
  <xsl:call-template name="dita2html.links.prevnext"/>
  <div class="hgroup">
    <h1 class="title">
      <span class="title">
        <xsl:apply-templates mode="dita2html.topic.mode" select="&topic_title_all;/node()"/>
      </span>
    </h1>
  </div>
  <div class="region">
    <xsl:call-template name="dita.id"/>
    <xsl:call-template name="html.lang.attrs"/>
    <xsl:call-template name="dita2html.links.topic">
      <xsl:with-param name="source" select="."/>
    </xsl:call-template>
  </div>
  <xsl:call-template name="dita2html.links.prevnext"/>
  <div class="clear"/>
</xsl:template>


<!-- == topicref == -->

<!-- = topicref % html.title.mode = -->
<xsl:template mode="html.title.mode" match="&map_topicref;">
  <xsl:value-of select="document(@href, $dita.map.base)/&topic_topic_all;/&topic_title_all;"/>
</xsl:template>

<!-- = topicref % html.header.mode = -->
<xsl:template mode="html.header.mode" match="&map_topicref;">
  <xsl:variable name="node" select="."/>
  <xsl:variable name="direction">
    <xsl:call-template name="l10n.direction"/>
  </xsl:variable>
  <xsl:variable name="sep">
    <xsl:choose>
      <xsl:when test="$direction = 'rtl'">
        <xsl:text>&#x200F;&#x00A0;» &#x200F;</xsl:text>
      </xsl:when>
      <xsl:otherwise>
        <xsl:text>&#x00A0;» </xsl:text>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:variable>
  <div class="trails" role="navigation">
    <div class="trail">
      <xsl:call-template name="html.linktrails.prefix">
        <xsl:with-param name="node" select="$node"/>
      </xsl:call-template>
      <a class="trail">
        <xsl:attribute name="href">
          <xsl:for-each select="str:split($node/@href, '/')">
            <xsl:if test="position() != last()">
              <xsl:text>../</xsl:text>
            </xsl:if>
          </xsl:for-each>
          <xsl:call-template name="dita.ref.href.target">
            <xsl:with-param name="href" select="'index'"/>
          </xsl:call-template>
        </xsl:attribute>
        <xsl:call-template name="dita.ref.topicref.navtitle">
          <xsl:with-param name="node" select="/&map_map;"/>
        </xsl:call-template>
      </a>
      <xsl:value-of select="$sep"/>
      <xsl:for-each select="(ancestor::&map_topicref;)">
        <xsl:choose>
          <xsl:when test="@href">
            <a class="trail">
              <xsl:attribute name="href">
                <xsl:for-each select="str:split($node/@href, '/')">
                  <xsl:if test="position() != last()">
                    <xsl:text>../</xsl:text>
                  </xsl:if>
                </xsl:for-each>
                <xsl:call-template name="dita.ref.href.target"/>
              </xsl:attribute>
              <xsl:call-template name="dita.ref.topicref.navtitle"/>
            </a>
          </xsl:when>
          <xsl:otherwise>
            <xsl:call-template name="dita.ref.topicref.navtitle"/>
          </xsl:otherwise>
        </xsl:choose>
        <xsl:value-of select="$sep"/>
      </xsl:for-each>
    </div>
  </div>
</xsl:template>

<!-- = topicref % html.footer.mode = -->
<xsl:template mode="html.footer.mode" match="&map_topicref;">
  <xsl:call-template name="dita2html.topic.about">
    <xsl:with-param name="node" select="document(@href, $dita.map.base)/*"/>
  </xsl:call-template>
</xsl:template>

<!-- = topicref % html.body.mode = -->
<xsl:template mode="html.body.mode" match="&map_topicref;">
  <xsl:variable name="node" select="."/>
  <xsl:call-template name="dita2html.links.prevnext"/>
  <xsl:apply-templates mode="dita2html.topic.mode" select="document(@href, $dita.map.base)/*">
    <xsl:with-param name="topicref" select="$node"/>
  </xsl:apply-templates>
  <xsl:call-template name="dita2html.links.prevnext"/>
  <div class="clear"/>
</xsl:template>


<!-- == CSS == -->

<xsl:template mode="html.css.mode" match="*">
<!-- FIXME: open document for @lang -->
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
span.b {
  font-weight: bold;
  color: </xsl:text><xsl:value-of select="$color.text_light"/><xsl:text>;
}
span.i { font-style: italic; }
span.u { text-decoration: underline; }
span.shortcut { text-decoration: underline; }
li.stepsection {
  margin-</xsl:text><xsl:value-of select="$left"/><xsl:text>: 0;
  list-style-type: none;
}
ul.list-sli { list-style-type: none; }
ul.compact-sli li { margin-top: 0; line-height: 1.44em; }
dt.dthd, dd.ddhd {
  font-weight: bold;
  color: </xsl:text><xsl:value-of select="$color.text_light"/><xsl:text>;
}
th, td { border: solid 1px; }
div.dita-object > div.desc {
  margin: 0 0 0.2em 0;
  font-weight: bold;
  color: </xsl:text><xsl:value-of select="$color.text_light"/><xsl:text>;
}

</xsl:text>
</xsl:template>


<!-- == Matched Templates == -->

<!-- = topic = -->
<xsl:template mode="dita2html.topic.mode" match="&topic_topic_all;">
  <xsl:param name="topicref" select="/false"/>
  <xsl:choose>
    <xsl:when test="parent::&topic_topic_all;">
      <div>
        <xsl:call-template name="dita.id"/>
        <xsl:call-template name="html.lang.attrs"/>
        <xsl:call-template name="html.class.attr">
          <xsl:with-param name="class" select="'sect'"/>
        </xsl:call-template>
        <div class="inner">
          <xsl:call-template name="_dita2html.topic.inner"/>
        </div>
      </div>
    </xsl:when>
    <xsl:otherwise>
      <xsl:call-template name="_dita2html.topic.inner">
        <xsl:with-param name="topicref" select="$topicref"/>
      </xsl:call-template>
    </xsl:otherwise>
  </xsl:choose>
</xsl:template>

<!--#* _dita2html.topic.inner -->
<xsl:template name="_dita2html.topic.inner">
  <xsl:param name="topicref" select="/false"/>
  <xsl:variable name="conref" select="yelp:dita.ref.conref(.)"/>
  <xsl:variable name="depth" select="count(ancestor::*) + 1"/>
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
  <div class="hgroup">
    <xsl:element name="{concat('h', $depth_)}" namespace="{$html.namespace}">
      <xsl:attribute name="class">
        <xsl:text>title</xsl:text>
      </xsl:attribute>
      <span class="title">
        <xsl:apply-templates mode="dita2html.topic.mode" select="$conref/&topic_title_all;/node()"/>
      </span>
    </xsl:element>
  </div>
  <xsl:apply-templates mode="dita2html.topic.mode" select="$conref/&topic_body;">
    <xsl:with-param name="topicref" select="$topicref"/>
  </xsl:apply-templates>
  <xsl:apply-templates mode="dita2html.topic.mode" select="$conref/&topic_topic_all;"/>
  <xsl:apply-templates mode="dita2html.topic.mode" select="$conref/&topic_related-links;"/>
</xsl:template>

<xsl:template mode="dita2html.topic.mode" match="&topic_body;">
  <xsl:param name="topicref" select="/false"/>
  <xsl:variable name="node" select="."/>
  <xsl:variable name="conref" select="yelp:dita.ref.conref(.)"/>
  <div>
    <xsl:call-template name="dita.id"/>
    <xsl:call-template name="html.lang.attrs"/>
    <xsl:call-template name="html.class.attr">
      <xsl:with-param name="class" select="'region'"/>
    </xsl:call-template>
    <div class="contents">
      <xsl:apply-templates mode="dita2html.topic.mode" select="../&topic_shortdesc;"/>
      <xsl:apply-templates mode="dita2html.topic.mode" select="$conref/node()"/>
    </div>
    <xsl:call-template name="dita2html.links.topic">
      <xsl:with-param name="source" select="$topicref"/>
    </xsl:call-template>
  </div>
</xsl:template>

<xsl:template mode="dita2html.topic.mode" match="&topic_related-links;">
  <div role="navigation">
    <xsl:call-template name="html.lang.attrs"/>
    <xsl:call-template name="html.class.attr">
      <xsl:with-param name="class" select="'sect sect-links'"/>
    </xsl:call-template>
    <div class="hgroup"/>
    <div class="contents">
      <div class="links">
        <xsl:call-template name="dita.id"/>
        <xsl:call-template name="html.lang.attrs"/>
        <div class="inner">
          <div class="region">
            <ul>
              <xsl:apply-templates mode="dita2html.topic.mode"/>
            </ul>
          </div>
        </div>
      </div>
    </div>
  </div>
</xsl:template>

<xsl:template mode="dita2html.topic.mode" match="&topic_link;">
  <!-- FIXME -->
  <li>
    <xsl:call-template name="dita.id"/>
    <xsl:call-template name="html.lang.attrs"/>
    <xsl:call-template name="html.class.attr">
      <xsl:with-param name="class" select="'links'"/>
    </xsl:call-template>
    <a>
      <xsl:attribute name="href">
        <!-- FIXME -->
        <xsl:value-of select="@href"/>
      </xsl:attribute>
      <xsl:variable name="linktext" select="&topic_linktext;"/>
      <xsl:choose>
        <xsl:when test="$linktext">
          <xsl:for-each select="$linktext[1]">
            <span class="linktext">
              <xsl:call-template name="html.lang.attrs"/>
              <xsl:apply-templates mode="dita2html.topic.mode"/>
            </span>
          </xsl:for-each>
        </xsl:when>
        <xsl:otherwise>
          <!-- FIXME -->
          <xsl:value-of select="@href"/>
        </xsl:otherwise>
      </xsl:choose>
    </a>
    <xsl:variable name="desc" select="&topic_desc;"/>
    <xsl:for-each select="$desc[1]">
      <span class="desc">
        <xsl:call-template name="html.lang.attrs"/>
        <xsl:text> &#x2014; </xsl:text>
        <xsl:apply-templates mode="dita2html.topic.mode"/>
      </span>
    </xsl:for-each>
  </li>
</xsl:template>

<xsl:template mode="dita2html.topic.mode" match="&topic_linkinfo;">
  <li>
    <xsl:call-template name="dita.id"/>
    <xsl:call-template name="html.lang.attrs"/>
    <xsl:call-template name="html.class.attr">
      <xsl:with-param name="class" select="'links links-linkinfo'"/>
    </xsl:call-template>
    <xsl:apply-templates modes="dita2html.topic.mode"/>
  </li>
</xsl:template>

<xsl:template mode="dita2html.topic.mode" match="&topic_linklist;">
  <xsl:choose>
    <xsl:when test="&topic_title_all; or &topic_desc; or &topic_linkinfo;">
      <li class="links">
        <div>
          <xsl:call-template name="dita.id"/>
          <xsl:call-template name="html.lang.attrs"/>
          <xsl:call-template name="html.class.attr">
            <xsl:with-param name="class" select="'links'"/>
          </xsl:call-template>
          <div class="inner">
            <xsl:apply-templates mode="dita2html.topic.mode" select="&topic_title_all;"/>
            <div class="region">
              <xsl:apply-templates mode="dita2html.topic.mode" select="&topic_desc;"/>
              <ul>
                <xsl:apply-templates mode="dita2html.topic.mode" select="&topic_link; | &topic_linklist;"/>
                <xsl:apply-templates mode="dita2html.topic.mode" select="&topic_linkinfo;"/>
              </ul>
            </div>
          </div>
        </div>
      </li>
    </xsl:when>
    <xsl:otherwise>
      <xsl:apply-templates mode="dita2html.topic.mode"
                           select="&topic_link; | &topic_linklist;"/>
    </xsl:otherwise>
  </xsl:choose>
</xsl:template>

<xsl:template mode="dita2html.topic.mode" match="&topic_linkpool;">
  <xsl:apply-templates mode="dita2html.topic.mode"/>
</xsl:template>

<!-- FIXME -->

<xsl:template mode="dita2html.topic.mode" match="&topic_prolog;"/>

<xsl:template mode="dita2html.topic.mode" match="*">
  <xsl:message>
    <xsl:text>Unmatched element: </xsl:text>
    <xsl:value-of select="local-name(.)"/>
  </xsl:message>
  <xsl:apply-templates mode="dita2html.topic.mode"/>
</xsl:template>

</xsl:stylesheet>
