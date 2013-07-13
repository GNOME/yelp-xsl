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
    <xsl:call-template name="dita.id">
      <xsl:with-param name="node" select="$node"/>
    </xsl:call-template>
    <xsl:call-template name="html.lang.attrs">
      <xsl:with-param name="node" select="$node"/>
    </xsl:call-template>
    <xsl:call-template name="html.class.attr">
      <xsl:with-param name="node" select="$node"/>
      <xsl:with-param name="class" select="$class"/>
    </xsl:call-template>
    <div class="contents">
      <xsl:apply-templates mode="dita2html.topic.mode" select="$conref/node()"/>
    </div>
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
    <xsl:call-template name="dita.id">
      <xsl:with-param name="node" select="$node"/>
    </xsl:call-template>
    <xsl:call-template name="html.lang.attrs">
      <xsl:with-param name="node" select="$node"/>
    </xsl:call-template>
    <xsl:call-template name="html.class.attr">
      <xsl:with-param name="node" select="$node"/>
      <xsl:with-param name="class" select="$class"/>
    </xsl:call-template>
    <xsl:apply-templates mode="dita2html.topic.mode" select="$conref/node()"/>
  </p>
</xsl:template>

<!--**==========================================================================
dita2html.pre
Output an HTML #{pre} element.
:Revision:version="3.8" date="2012-10-05" status="incomplete"
$node: The source element to output a #{pre} for.
$class: The value of the HTML #{class} attribute.

FIXME
-->
<xsl:template name="dita2html.pre">
  <xsl:param name="node" select="."/>
  <xsl:param name="class" select="''"/>
  <xsl:variable name="conref" select="yelp:dita.ref.conref($node)"/>
  <xsl:variable name="children" select="$conref/node()"/>
  <div>
    <xsl:call-template name="dita.id">
      <xsl:with-param name="node" select="$node"/>
    </xsl:call-template>
    <xsl:call-template name="html.lang.attrs">
      <xsl:with-param name="node" select="$node"/>
    </xsl:call-template>
    <xsl:call-template name="html.class.attr">
      <xsl:with-param name="node" select="$node"/>
      <xsl:with-param name="class" select="$class"/>
    </xsl:call-template>
    <pre class="contents">
      <!-- Strip off a leading newline -->
      <xsl:if test="$children[1]/self::text()">
        <xsl:choose>
          <xsl:when test="starts-with($node/text()[1], '&#x000A;')">
            <xsl:value-of select="substring-after($node/text()[1], '&#x000A;')"/>
          </xsl:when>
          <xsl:otherwise>
            <xsl:value-of select="$node/text()[1]"/>
          </xsl:otherwise>
        </xsl:choose>
      </xsl:if>
      <xsl:apply-templates mode="dita2html.topic.mdoe"
                           select="$children[not(position() = 1 and self::text())]"/>
    </pre>
  </div>
</xsl:template>


<!-- == Matched Templates == -->

<!-- = bodydiv = -->
<xsl:template mode="dita2html.topic.mode" match="&topic_bodydiv_all;">
  <xsl:call-template name="dita2html.div">
    <xsl:with-param name="class" select="'bodydiv'"/>
  </xsl:call-template>
</xsl:template>

<!-- = cmd = -->
<xsl:template mode="dita2html.topic.mode" match="&topic_cmd;">
  <xsl:call-template name="dita2html.p"/>
</xsl:template>

<!-- = codeblock = -->
<xsl:template mode="dita2html.topic.mode" match="&topic_codeblock;">
  <xsl:call-template name="dita2html.pre">
    <xsl:with-param name="class" select="'code'"/>
  </xsl:call-template>
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

<!-- = example = -->
<xsl:template mode="dita2html.topic.mode" match="&topic_example;">
  <xsl:call-template name="dita2html.div">
    <xsl:with-param name="class" select="'example'"/>
  </xsl:call-template>
</xsl:template>

<!-- = fig = -->
<xsl:template mode="dita2html.topic.mode" match="&topic_fig;">
  <xsl:variable name="conref" select="yelp:dita.ref.conref(.)"/>
  <!-- If there's images or video, treat it like a Mallard figure.
       Otherwise, treat it like a Mallard listing. -->
  <xsl:variable name="style">
    <xsl:choose>
      <xsl:when test="$conref/&topic_image; or $conref/&topic_object;">
        <xsl:text>figure</xsl:text>
      </xsl:when>
      <xsl:otherwise>
        <xsl:text>listing</xsl:text>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:variable>
  <div>
    <xsl:call-template name="dita.id"/>
    <xsl:call-template name="html.class.attr">
      <xsl:with-param name="class" select="$style"/>
    </xsl:call-template>
    <xsl:call-template name="html.lang.attrs"/>
    <div class="inner">
      <xsl:apply-templates mode="dita2html.topic.mode" select="$conref/&topic_title_all;"/>
      <div class="region">
        <xsl:if test="$style = 'listing'">
          <xsl:apply-templates mode="dita2html.topic.mode" select="$conref/&topic_desc;"/>
        </xsl:if>
        <div class="contents">
          <xsl:apply-templates mode="dita2html.topic.mode"
                               select="$conref/node()[not(self::&topic_title_all; or self::&topic_desc;)]"/>
        </div>
        <xsl:if test="$style = 'figure'">
          <xsl:apply-templates mode="dita2html.topic.mode" select="$conref/&topic_desc;"/>
        </xsl:if>
      </div>
    </div>
  </div>
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
    <xsl:call-template name="dita.id"/>
    <xsl:call-template name="html.lang.attrs"/>
    <xsl:call-template name="html.class.attr">
      <xsl:with-param name="class">
        <xsl:text>note</xsl:text>
        <xsl:if test="$notetype != ''">
          <xsl:text> note-</xsl:text>
          <xsl:value-of select="$notetype"/>
        </xsl:if>
      </xsl:with-param>
    </xsl:call-template>
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

<!-- = pre = -->
<xsl:template mode="dita2html.topic.mode" match="&topic_pre;">
  <xsl:call-template name="dita2html.pre"/>
</xsl:template>

<!-- = prereq = -->
<xsl:template mode="dita2html.topic.mode" match="&topic_prereq;">
  <xsl:call-template name="dita2html.div">
    <xsl:with-param name="class" select="'prereq'"/>
  </xsl:call-template>
</xsl:template>

<!-- = refsyn = -->
<xsl:template mode="dita2html.topic.mode" match="&topic_refsyn;">
  <xsl:call-template name="dita2html.div">
    <xsl:with-param name="class" select="'synopsis'"/>
  </xsl:call-template>
</xsl:template>

<!-- = result = -->
<xsl:template mode="dita2html.topic.mode" match="&topic_result;">
  <xsl:call-template name="dita2html.div">
    <xsl:with-param name="class" select="'result'"/>
  </xsl:call-template>
</xsl:template>

<!-- = screen = -->
<xsl:template mode="dita2html.topic.mode" match="&topic_screen;">
  <xsl:call-template name="dita2html.pre">
    <xsl:with-param name="class" select="'screen'"/>
  </xsl:call-template>
</xsl:template>

<!-- = section = -->
<xsl:template mode="dita2html.topic.mode" match="&topic_section;">
  <xsl:variable name="conref" select="yelp:dita.ref.conref(.)"/>
  <div>
    <xsl:call-template name="dita.id"/>
    <xsl:call-template name="html.lang.attrs"/>
    <xsl:call-template name="html.class.attr">
      <xsl:with-param name="class" select="'section'"/>
    </xsl:call-template>
    <!-- A DITA section may have an optional title. But it can be anywhere
         in the child node list. And there could be more than one, but all
         but the first are ignored. Apparently. Spec isn't very clear, but
         this is the OT's behavior. -->
    <xsl:apply-templates mode="dita2html.topic.mode" select="$conref/&topic_title_all;[1]"/>
    <div class="region">
      <xsl:apply-templates mode="dita2html.topic.mode" select="$conref/node()[not(self::&topic_title_all;)]"/>
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

<!-- = steps-informal = -->
<xsl:template mode="dita2html.topic.mode" match="&topic_steps-informal;">
  <xsl:call-template name="dita2html.div">
    <xsl:with-param name="class" select="'steps-informal'"/>
  </xsl:call-template>
</xsl:template>

<!-- = stepxmp = -->
<xsl:template mode="dita2html.topic.mode" match="&topic_stepxmp;">
  <xsl:call-template name="dita2html.div">
    <xsl:with-param name="class" select="'example'"/>
  </xsl:call-template>
</xsl:template>

<!-- = title = -->
<xsl:template mode="dita2html.topic.mode" match="&topic_title_all;">
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
  <div>
    <xsl:call-template name="dita.id"/>
    <xsl:call-template name="html.lang.attrs"/>
    <xsl:call-template name="html.class.attr">
      <xsl:with-param name="class" select="'title'"/>
    </xsl:call-template>
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
