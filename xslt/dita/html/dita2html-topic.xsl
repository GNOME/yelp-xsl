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
                xmlns:yelp="http://projects.gnome.org/yelp/"
                xmlns="http://www.w3.org/1999/xhtml"
                exclude-result-prefixes="yelp"
                version="1.0">

<!--!!==========================================================================
DITA to HTML - Topics

REMARK: Describe this module
-->


<!-- == Matched Templates == -->

<!--%# html.title.mode -->
<xsl:template mode="html.title.mode" match="&topic_topic;">
  <xsl:value-of select="&topic_title;"/>
</xsl:template>

<!--%# html.header.mode -->
<xsl:template mode="html.header.mode" match="&topic_topic;">
  <div class="trails">
  </div>
  <!-- FIXME -->
  <!--
  <xsl:call-template name="mal2html.page.linktrails"/>
  -->
</xsl:template>

<!--%# html.footer.mode -->
<xsl:template mode="html.footer.mode" match="&topic_topic;">
  <!-- FIXME -->
  <!--
  <xsl:call-template name="mal2html.page.about"/>
  -->
</xsl:template>

<!--%# html.body.mode -->
<xsl:template mode="html.body.mode" match="&topic_topic;">
  <!-- FIXME: prevnext -->
  <xsl:apply-templates mode="dita2html.topic.mode" select="."/>
  <div class="clear"/>
</xsl:template>

<!--%# html.css.mode -->
<xsl:template mode="html.css.mode" match="&topic_topic;">
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

th, td { border: solid 1px; }

<!-- FIXME: perhaps into html.xsl? -->
div.links > div.inner > div.region > div.desc { font-style: italic; }
th { text-align: left; }
</xsl:text>
</xsl:template>


<!-- = topic = -->
<xsl:template mode="dita2html.topic.mode" match="&topic_topic;">
  <xsl:choose>
    <xsl:when test="parent::&topic_topic;">
      <div class="sect">
        <xsl:copy-of select="@id"/>
        <xsl:call-template name="html.lang.attrs"/>
        <div class="inner">
          <xsl:call-template name="_dita2html.topic.inner"/>
        </div>
      </div>
    </xsl:when>
    <xsl:otherwise>
      <xsl:call-template name="_dita2html.topic.inner"/>
    </xsl:otherwise>
  </xsl:choose>
</xsl:template>

<!--#* _dita2html.topic.inner -->
<xsl:template name="_dita2html.topic.inner">
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
        <xsl:apply-templates mode="dita2html.topic.mode" select="$conref/&topic_title;"/>
      </span>
    </xsl:element>
  </div>
  <xsl:apply-templates mode="dita2html.topic.mode" select="$conref/&topic_body;"/>
  <xsl:apply-templates mode="dita2html.topic.mode" select="$conref/&topic_topic;"/>
  <xsl:apply-templates mode="dita2html.topic.mode" select="$conref/&topic_related-links;"/>
</xsl:template>

<xsl:template mode="dita2html.topic.mode" match="&topic_body;">
  <xsl:variable name="conref" select="yelp:dita.ref.conref(.)"/>
  <div class="region">
    <xsl:copy-of select="@id"/>
    <xsl:call-template name="html.lang.attrs"/>
    <div class="contents">
      <xsl:apply-templates mode="dita2html.topic.mode" select="$conref/node()"/>
    </div>
  </div>
</xsl:template>

<xsl:template mode="dita2html.topic.mode" match="&topic_related-links;">
  <div class="sect sect-links">
    <div class="hgroup"/>
    <div class="contents">
      <div class="links">
        <xsl:copy-of select="@id"/>
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
    <xsl:copy-of select="@id"/>
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
    <xsl:copy-of select="@id"/>
    <xsl:call-template name="html.lang.attrs"/>
    <xsl:apply-templates modes="dita2html.topic.mode"/>
  </li>
</xsl:template>

<xsl:template mode="dita2html.topic.mode" match="&topic_linklist;">
  <xsl:choose>
    <xsl:when test="&topic_title; or &topic_desc; or &topic_linkinfo;">
      <li class="links">
        <div class="links">
          <xsl:copy-of select="@id"/>
          <xsl:call-template name="html.lang.attrs"/>
          <div class="inner">
            <xsl:apply-templates mode="dita2html.topic.mode" select="&topic_title;"/>
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
