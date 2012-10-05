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
DITA to HTML - Blocks

REMARK: Describe this module
-->


<!--**==========================================================================
dita2html.div
Output an HTML #{div} element.
:Revision:version="3.8" date="2012-10-04" status="incomplete"
$node: The source element to output a #{div} for.
$class: The value of the HTML #{class} attribute.

FIXME
-->
<xsl:template name="dita2html.div">
  <xsl:param name="node" select="."/>
  <xsl:param name="class" select="''"/>
  <xsl:variable name="conref" select="yelp:dita.ref.conref($node)"/>
  <div>
    <xsl:copy-of select="$node/@id"/>
    <xsl:call-template name="html.lang.attrs">
      <xsl:with-param name="node" select="$node"/>
    </xsl:call-template>
    <xsl:if test="$class != ''">
      <xsl:attribute name="class">
        <xsl:value-of select="$class"/>
      </xsl:attribute>
    </xsl:if>
    <xsl:apply-templates mode="dita2html.topic.mode" select="$conref/node()"/>
  </div>
</xsl:template>


<!--**==========================================================================
dita2html.p
Output an HTML #{p} element.
:Revision:version="3.8" date="2012-10-04" status="incomplete"
$node: The source element to output a #{p} for.
$class: The value of the HTML #{class} attribute.

FIXME
-->
<xsl:template name="dita2html.p">
  <xsl:param name="node" select="."/>
  <xsl:param name="class" select="''"/>
  <xsl:variable name="conref" select="yelp:dita.ref.conref($node)"/>
  <p>
    <xsl:copy-of select="$node/@id"/>
    <xsl:call-template name="html.lang.attrs">
      <xsl:with-param name="node" select="$node"/>
    </xsl:call-template>
    <xsl:if test="$class != ''">
      <xsl:attribute name="class">
        <xsl:value-of select="$class"/>
      </xsl:attribute>
    </xsl:if>
    <xsl:apply-templates mode="dita2html.topic.mode" select="$conref/node()"/>
  </p>
</xsl:template>


<!-- == Matched Templates == -->

<!-- = cmd = -->
<xsl:template mode="dita2html.topic.mode" match="&topic_cmd;">
  <xsl:call-template name="dita2html.p"/>
</xsl:template>

<!-- = codeblock = -->
<xsl:template mode="dita2html.topic.mode" match="&topic_codeblock;">
  <xsl:variable name="conref" select="yelp:dita.ref.conref(.)"/>
  <div class="code">
    <xsl:copy-of select="@id"/>
    <xsl:call-template name="html.lang.attrs"/>
    <pre class="contents">
      <xsl:apply-templates mode="dita2html.topic.mode" select="$conref/node()"/>
    </pre>
  </div>
</xsl:template>

<!-- = context = -->
<xsl:template mode="dita2html.topic.mode" match="&topic_context;">
  <xsl:call-template name="dita2html.div">
    <xsl:with-param name="class" select="'context'"/>
  </xsl:call-template>
</xsl:template>

<!-- = desc = -->
<xsl:template mode="dita2html.topic.mode" match="&topic_desc;">
  <xsl:call-template name="dita2html.div">
    <xsl:with-param name="class" select="'desc'"/>
  </xsl:call-template>
</xsl:template>

<!-- = info = -->
<xsl:template mode="dita2html.topic.mode" match="&topic_info;">
  <xsl:call-template name="dita2html.p"/>
</xsl:template>

<!-- = note = -->
<xsl:template mode="dita2html.topic.mode" match="&topic_note;">
  <xsl:variable name="conref" select="yelp:dita.ref.conref(.)"/>
  <xsl:variable name="type">
    <xsl:call-template name="dita.ref.conref.attr">
      <xsl:with-param name="attr" select="'type'"/>
      <xsl:with-param name="node" select="."/>
      <xsl:with-param name="conref" select="$conref"/>
    </xsl:call-template>
  </xsl:variable>
  <xsl:variable name="notetype">
    <xsl:choose>
      <xsl:when test="$type = 'attention' or $type = 'important' or
                      $type = 'remember' or $type = 'restriction'">
        <xsl:text>important</xsl:text>
      </xsl:when>
      <xsl:when test="$type = 'caution' or $type = 'danger' or
                      $type = 'notice' or $type = 'warning'">
        <xsl:text>warning</xsl:text>
      </xsl:when>
      <xsl:when test="$type = 'fastpath' or $type = 'tip'">
        <xsl:text>tip</xsl:text>
      </xsl:when>
    </xsl:choose>
  </xsl:variable>
  <div>
    <xsl:copy-of select="@id"/>
    <xsl:call-template name="html.lang.attrs"/>
    <xsl:attribute name="class">
      <xsl:text>note</xsl:text>
      <xsl:if test="$notetype != ''">
        <xsl:text> note-</xsl:text>
        <xsl:value-of select="$notetype"/>
      </xsl:if>
    </xsl:attribute>
    <div class="inner">
      <div class="region">
        <div class="contents">
          <xsl:apply-templates mode="dita2html.topic.mode" select="$conref/node()"/>
        </div>
      </div>
    </div>
  </div>
</xsl:template>

<!-- = p = -->
<xsl:template mode="dita2html.topic.mode" match="&topic_p;">
  <xsl:call-template name="dita2html.p"/>
</xsl:template>

<!-- = postreq = -->
<xsl:template mode="dita2html.topic.mode" match="&topic_postreq;">
  <xsl:call-template name="dita2html.div">
    <xsl:with-param name="class" select="'postreq'"/>
  </xsl:call-template>
</xsl:template>

<!-- = prereq = -->
<xsl:template mode="dita2html.topic.mode" match="&topic_prereq;">
  <xsl:call-template name="dita2html.div">
    <xsl:with-param name="class" select="'prereq'"/>
  </xsl:call-template>
</xsl:template>

<!-- = result = -->
<xsl:template mode="dita2html.topic.mode" match="&topic_result;">
  <xsl:call-template name="dita2html.div">
    <xsl:with-param name="class" select="'result'"/>
  </xsl:call-template>
</xsl:template>

<!-- = section = -->
<xsl:template mode="dita2html.topic.mode" match="&topic_section;">
  <xsl:variable name="conref" select="yelp:dita.ref.conref(.)"/>
  <div class="section">
    <xsl:copy-of select="@id"/>
    <xsl:call-template name="html.lang.attrs"/>
    <!-- A DITA section may have an optional title. But it can be anywhere
         in the child node list. And there could be more than one, but all
         but the first are ignored. Apparently. Spec isn't very clear, but
         this is the OT's behavior. -->
    <xsl:apply-templates mode="dita2html.topic.mode" select="$conref/&topic_title;[1]"/>
    <div class="region">
      <xsl:apply-templates mode="dita2html.topic.mode" select="$conref/node()[not(self::&topic_title;)]"/>
    </div>
  </div>
</xsl:template>

<!-- = shortdesc = -->
<xsl:template mode="dita2html.topic.mode" match="&topic_shortdesc;">
  <xsl:call-template name="dita2html.p">
    <xsl:with-param name="class" select="'shortdesc'"/>
  </xsl:call-template>
</xsl:template>

<!-- = stepresult = -->
<xsl:template mode="dita2html.topic.mode" match="&topic_stepresult;">
  <xsl:call-template name="dita2html.p"/>
</xsl:template>

<!-- = stepxmp = -->
<xsl:template mode="dita2html.topic.mode" match="&topic_stepxmp;">
  <xsl:call-template name="dita2html.div">
    <xsl:with-param name="class" select="'example'"/>
  </xsl:call-template>
</xsl:template>

<!-- = title = -->
<xsl:template mode="dita2html.topic.mode" match="&topic_title;">
  <xsl:variable name="conref" select="yelp:dita.ref.conref(.)"/>
  <xsl:variable name="depth" select="count(ancestor::&topic_topic_all;) + 1"/>
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
  <div class="title">
    <xsl:copy-of select="@id"/>
    <xsl:call-template name="html.lang.attrs"/>
    <xsl:element name="{concat('h', $depth_)}" namespace="{$html.namespace}">
      <xsl:apply-templates mode="dita2html.topic.mode" select="$conref/node()"/>
    </xsl:element>
  </div>
</xsl:template>

<!-- = tutorialinfo = -->
<xsl:template mode="dita2html.topic.mode" match="&topic_tutorialinfo;">
  <xsl:call-template name="dita2html.p"/>
</xsl:template>

</xsl:stylesheet>
