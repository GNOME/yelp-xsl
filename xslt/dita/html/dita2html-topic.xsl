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
<!DOCTYPE xsl:stylesheet [
<!ENTITY % selectors SYSTEM "../common/dita-selectors.mod">
%selectors;
]>

<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
                xmlns:exsl="http://exslt.org/common"
                xmlns:str="http://exslt.org/strings"
                xmlns:yelp="http://projects.gnome.org/yelp/"
                xmlns="http://www.w3.org/1999/xhtml"
                exclude-result-prefixes="exsl str yelp"
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
  <xsl:variable name="prev" select="($node/parent::&map_topicref; |
                                     $node/preceding::&map_topicref;[1] |
                                     ancestor::&map_map;[1]
                                    )[last()]"/>
  <xsl:variable name="next" select="($node/&map_topicref; | $node/following::&map_topicref;)[1]"/>
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
          <xsl:choose>
            <xsl:when test="$prev[self::&map_map;]">
              <xsl:apply-templates mode="dita2html.topic.mode"
                                   select="$prev/&topic_title;/node()"/>
            </xsl:when>
            <xsl:when test="$prev/@navtitle">
              <xsl:value-of select="$prev/@navtitle"/>
            </xsl:when>
            <xsl:otherwise>
              <xsl:apply-templates mode="dita2html.topic.mode"
                                   select="document($prev/@href, $dita.map.base)/&topic_topic_all;/&topic_title_all;/node()"/>
            </xsl:otherwise>
          </xsl:choose>
        </xsl:attribute>
        <xsl:call-template name="l10n.gettext">
          <xsl:with-param name="msgid" select="'Previous'"/>
        </xsl:call-template>
      </a>
    </xsl:if>
    <xsl:if test="$prev and $next">
      <xsl:text>&#x00A0;&#x00A0;|&#x00A0;&#x00A0;</xsl:text>
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
          <xsl:choose>
            <xsl:when test="$next/@navtitle">
              <xsl:value-of select="$next/@navtitle"/>
            </xsl:when>
            <xsl:otherwise>
              <xsl:apply-templates mode="dita2html.topic.mode"
                                   select="document($next/@href, $dita.map.base)/&topic_topic_all;/&topic_title_all;/node()"/>
            </xsl:otherwise>
          </xsl:choose>
        </xsl:attribute>
        <xsl:call-template name="l10n.gettext">
          <xsl:with-param name="msgid" select="'Next'"/>
        </xsl:call-template>
      </a>
    </xsl:if>
  </div>
</xsl:template>


<!-- == map == -->

<!-- = map % html.output.after.mode = -->
<xsl:template mode="html.output.after.mode" match="/&map_map;">
  <xsl:for-each select="//&map_topicref;">
    <xsl:call-template name="html.output">
      <xsl:with-param name="href">
        <xsl:call-template name="dita.ref.href.target"/>
      </xsl:with-param>
    </xsl:call-template>
  </xsl:for-each>
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
    <div class="links sectionlinks" role="navigation">
      <ul>
        <xsl:for-each select="&map_topicref;">
          <li class="links">
            <a>
              <xsl:attribute name="href">
                <xsl:call-template name="dita.ref.href.target"/>
              </xsl:attribute>
              <xsl:choose>
                <xsl:when test="@navtitle">
                  <xsl:value-of select="@navtitle"/>
                </xsl:when>
                <xsl:otherwise>
                  <xsl:apply-templates mode="dita2html.topic.mode"
                                       select="document(@href, $dita.map.base)/&topic_topic_all;/&topic_title_all;/node()"/>
                </xsl:otherwise>
              </xsl:choose>
            </a>
          </li>
        </xsl:for-each>
      </ul>
    </div>
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
        <xsl:text>&#x00A0;« </xsl:text>
      </xsl:when>
      <xsl:otherwise>
        <xsl:text>&#x00A0;» </xsl:text>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:variable>
  <div class="trails">
    <div class="trail">
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
        <xsl:choose>
          <xsl:when test="/&map_map;/&topic_booktitle;">
            <xsl:apply-templates mode="dita2html.topic.mode"
                                 select="/&map_map;/&topic_title_all;/&topic_mainbooktitle;/node()"/>
          </xsl:when>
          <xsl:otherwise>
            <xsl:apply-templates mode="dita2html.topic.mode"
                                 select="/&map_map;/&topic_title_all;/node()"/>
          </xsl:otherwise>
        </xsl:choose>
      </a>
      <xsl:value-of select="$sep"/>
      <xsl:for-each select="ancestor::&map_topicref;">
        <a class="trail">
          <xsl:attribute name="href">
            <xsl:for-each select="str:split($node/@href, '/')">
              <xsl:if test="position() != last()">
                <xsl:text>../</xsl:text>
              </xsl:if>
            </xsl:for-each>
            <xsl:call-template name="dita.ref.href.target"/>
          </xsl:attribute>
          <xsl:choose>
            <xsl:when test="@navtitle">
              <xsl:value-of select="@navtitle"/>
            </xsl:when>
            <xsl:otherwise>
              <xsl:apply-templates mode="dita2html.topic.mode"
                                   select="document(@href, $dita.map.base)/&topic_topic_all;/&topic_title_all;/node()"/>
            </xsl:otherwise>
          </xsl:choose>
        </a>
        <xsl:value-of select="$sep"/>
      </xsl:for-each>
    </div>
  </div>
</xsl:template>

<!-- = topicref % html.footer.mode = -->
<xsl:template mode="html.footer.mode" match="&map_topicref;">
  <!-- FIXME -->
  <!--
  <xsl:call-template name="mal2html.page.about"/>
  -->
</xsl:template>

<!-- = topicref % html.body.mode = -->
<xsl:template mode="html.body.mode" match="&map_topicref;">
  <xsl:variable name="node" select="."/>
  <xsl:variable name="subtopics">
    <xsl:for-each select="&map_topicref;">
      <xsl:copy>
        <xsl:copy-of select="@*[name(.) != 'href']"/>
        <xsl:attribute name="href">
          <xsl:for-each select="str:split($node/@href, '/')">
            <xsl:if test="position() != last()">
              <xsl:text>../</xsl:text>
            </xsl:if>
          </xsl:for-each>
          <xsl:value-of select="@href"/>
        </xsl:attribute>
      </xsl:copy>
    </xsl:for-each>
  </xsl:variable>
  <xsl:call-template name="dita2html.links.prevnext"/>
  <xsl:apply-templates mode="dita2html.topic.mode" select="document(@href, $dita.map.base)/*">
    <xsl:with-param name="subtopics" select="exsl:node-set($subtopics)/*"/>
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

</xsl:text>
</xsl:template>


<!-- == Matched Templates == -->

<!-- = topic = -->
<xsl:template mode="dita2html.topic.mode" match="&topic_topic_all;">
  <xsl:param name="subtopics"/>
  <xsl:choose>
    <xsl:when test="parent::&topic_topic_all;">
      <div class="sect">
        <xsl:call-template name="dita.id"/>
        <xsl:call-template name="html.lang.attrs"/>
        <div class="inner">
          <xsl:call-template name="_dita2html.topic.inner"/>
        </div>
      </div>
    </xsl:when>
    <xsl:otherwise>
      <xsl:call-template name="_dita2html.topic.inner">
        <xsl:with-param name="subtopics" select="$subtopics"/>
      </xsl:call-template>
    </xsl:otherwise>
  </xsl:choose>
</xsl:template>

<!--#* _dita2html.topic.inner -->
<xsl:template name="_dita2html.topic.inner">
  <xsl:param name="subtopics"/>
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
    <xsl:with-param name="subtopics" select="$subtopics"/>
  </xsl:apply-templates>
  <xsl:apply-templates mode="dita2html.topic.mode" select="$conref/&topic_topic_all;"/>
  <xsl:apply-templates mode="dita2html.topic.mode" select="$conref/&topic_related-links;"/>
</xsl:template>

<xsl:template mode="dita2html.topic.mode" match="&topic_body;">
  <xsl:param name="subtopics"/>
  <xsl:variable name="node" select="."/>
  <xsl:variable name="conref" select="yelp:dita.ref.conref(.)"/>
  <div class="region">
    <xsl:call-template name="dita.id"/>
    <xsl:call-template name="html.lang.attrs"/>
    <div class="contents">
      <xsl:apply-templates mode="dita2html.topic.mode" select="../&topic_shortdesc;"/>
      <xsl:apply-templates mode="dita2html.topic.mode" select="$conref/node()"/>
    </div>
    <xsl:if test="$subtopics">
      <div class="links sectionlinks" role="navigation">
        <ul>
          <xsl:for-each select="$subtopics">
            <li class="links">
              <a>
                <xsl:attribute name="href">
                  <xsl:call-template name="dita.ref.href.target"/>
                </xsl:attribute>
                <xsl:choose>
                  <xsl:when test="@navtitle">
                    <xsl:value-of select="@navtitle"/>
                  </xsl:when>
                  <xsl:otherwise>
                    <xsl:apply-templates mode="dita2html.topic.mode"
                                         select="document(@href, $node)/&topic_topic_all;/&topic_title_all;/node()"/>
                  </xsl:otherwise>
                </xsl:choose>
              </a>
              <xsl:variable name="desc" select="document(@href, $node)/&topic_topic_all;/&topic_shortdesc;"/>
              <xsl:if test="$desc">
                <span class="desc">
                  <xsl:text> &#x2014; </xsl:text>
                  <xsl:apply-templates mode="dita2html.topic.mode" select="yelp:dita.ref.conref($desc)/node()"/>
                </span>
              </xsl:if>
            </li>
          </xsl:for-each>
        </ul>
      </div>
    </xsl:if>
  </div>
</xsl:template>

<xsl:template mode="dita2html.topic.mode" match="&topic_related-links;">
  <div class="sect sect-links">
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
  <li class="links">
    <xsl:call-template name="dita.id"/>
    <xsl:call-template name="html.lang.attrs"/>
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
  <li class="links links-linkinfo">
    <xsl:call-template name="dita.id"/>
    <xsl:call-template name="html.lang.attrs"/>
    <xsl:apply-templates modes="dita2html.topic.mode"/>
  </li>
</xsl:template>

<xsl:template mode="dita2html.topic.mode" match="&topic_linklist;">
  <xsl:choose>
    <xsl:when test="&topic_title_all; or &topic_desc; or &topic_linkinfo;">
      <li class="links">
        <div class="links">
          <xsl:call-template name="dita.id"/>
          <xsl:call-template name="html.lang.attrs"/>
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
