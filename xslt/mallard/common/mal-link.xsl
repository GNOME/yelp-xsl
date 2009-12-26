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
                xmlns:mal="http://projectmallard.org/1.0/"
                xmlns:exsl="http://exslt.org/common"
                xmlns:str="http://exslt.org/strings"
                version="1.0">

<!--!!==========================================================================
Mallard Links
-->


<!--@@==========================================================================
mal.cache.file
The location of the cache file
-->
<xsl:param name="mal.cache.file"/>
<xsl:param name="mal.cache" select="document($mal.cache.file)/mal:cache"/>
<xsl:key name="mal.cache.key" match="mal:page | mal:section" use="@id"/>


<!--**==========================================================================
mal.link.content
Generates the content for a #{link} element
$link: The #{link} or other element creating the link
$xref: The #{xref} attribute of ${link}
$href: The #{href} attribute of ${link}
$role: A link role, used to select the appropriate title
-->
<xsl:template name="mal.link.content">
  <xsl:param name="link" select="."/>
  <xsl:param name="xref" select="$link/@xref"/>
  <xsl:param name="href" select="$link/@href"/>
  <xsl:param name="role" select="''"/>
  <xsl:choose>
    <xsl:when test="contains($xref, '/')">
      <!--
      This is a link to another document, which we don't handle in these
      stylesheets.  Extensions such as library or yelp should override
      this template to provide this functionality.
      -->
      <xsl:choose>
        <xsl:when test="$href">
          <xsl:value-of select="$href"/>
        </xsl:when>
        <xsl:otherwise>
          <xsl:value-of select="$xref"/>
        </xsl:otherwise>
      </xsl:choose>
    </xsl:when>
    <xsl:otherwise>
      <xsl:variable name="fullid">
        <xsl:choose>
          <xsl:when test="contains($xref, '#')">
            <xsl:variable name="pageid" select="substring-before($xref, '#')"/>
            <xsl:variable name="sectionid" select="substring-after($xref, '#')"/>
            <xsl:if test="$pageid = ''">
              <xsl:value-of select="$link/ancestor::mal:page/@id"/>
            </xsl:if>
            <xsl:value-of select="concat($pageid, '#', $sectionid)"/>
          </xsl:when>
          <xsl:otherwise>
            <xsl:value-of select="$xref"/>
          </xsl:otherwise>
        </xsl:choose>
      </xsl:variable>
      <xsl:for-each select="$mal.cache">
        <xsl:variable name="titles" select="key('mal.cache.key', $fullid)
                                           /mal:info/mal:title[@type = 'link']"/>
        <xsl:choose>
          <xsl:when test="$role != '' and $titles[@role = $role]">
            <xsl:apply-templates mode="mal.link.content.mode"
                                 select="$titles[@role = $role][1]/node()"/>
          </xsl:when>
          <xsl:otherwise>
            <xsl:apply-templates mode="mal.link.content.mode"
                                 select="$titles[not(@role)][1]/node()"/>
          </xsl:otherwise>
        </xsl:choose>
      </xsl:for-each>
    </xsl:otherwise>
  </xsl:choose>
</xsl:template>


<!--%%==========================================================================
mal.link.content.mode
Renders the content of a link from a title

This mode is applied to the contents of a #{title} element by *{mal.link.content}.
By default, it returns the string value of its input.  Stylesheets that import
this module should override this to call their inline mode.
-->
<xsl:template mode="mal.link.content.mode" match="* | text()">
  <xsl:value-of select="."/>
</xsl:template>


<!--**==========================================================================
mal.link.target
Generates the target for a #{link} element
$link: The #{link} or other element creating the link
$xref: The #{xref} attribute of ${link}
$href: The #{href} attribute of ${link}
-->
<xsl:template name="mal.link.target">
  <xsl:param name="link" select="."/>
  <xsl:param name="xref" select="$link/@xref"/>
  <xsl:param name="href" select="$link/@href"/>
  <xsl:choose>
    <xsl:when test="string($xref) = ''">
      <xsl:value-of select="$href"/>
    </xsl:when>
    <xsl:when test="contains($xref, '/')">
      <!--
      This is a link to another document, which we don't handle in these
      stylesheets.  Extensions such as library or yelp should override
      this template to provide this functionality.
      -->
      <xsl:value-of select="$href"/>
    </xsl:when>
    <xsl:when test="contains($xref, '#')">
      <xsl:variable name="pageid" select="substring-before($xref, '#')"/>
      <xsl:variable name="sectionid" select="substring-after($xref, '#')"/>
      <xsl:if test="$pageid != ''">
        <xsl:value-of select="concat($pageid, $mal.chunk.extension)"/>
      </xsl:if>
      <xsl:value-of select="concat('#', $sectionid)"/>
    </xsl:when>
    <xsl:otherwise>
      <xsl:value-of select="concat($xref, $mal.chunk.extension)"/>
    </xsl:otherwise>
  </xsl:choose>
</xsl:template>


<!--**==========================================================================
mal.link.tooltip
Generates the tooltip for a #{link} or other linking element
$link: The #{link} or other element creating the link
$xref: The #{xref} attribute of ${link}
$href: The #{href} attribute of ${link}
-->
<xsl:template name="mal.link.tooltip">
  <xsl:param name="link" select="."/>
  <xsl:param name="xref" select="$link/@xref"/>
  <xsl:param name="href" select="$link/@href"/>
  <xsl:choose>
    <xsl:when test="string($xref) != ''">
      <!-- FIXME -->
    </xsl:when>
    <xsl:when test="starts-with($href, 'mailto:')">
      <xsl:variable name="address" select="substring-after($href, 'mailto:')"/>
      <xsl:call-template name="l10n.gettext">
        <xsl:with-param name="msgid" select="'email.tooltip'"/>
        <xsl:with-param name="string" select="$address"/>
        <xsl:with-param name="format" select="true()"/>
      </xsl:call-template>
    </xsl:when>
    <xsl:otherwise>
      <xsl:value-of select="normalize-space($href)"/>
    </xsl:otherwise>
  </xsl:choose>
</xsl:template>


<!--**==========================================================================
mal.link.guidelinks
FIXME

REMARK: FIXME
-->
<xsl:template name="mal.link.guidelinks">
  <xsl:param name="node" select="."/>
  <xsl:variable name="id">
    <xsl:choose>
      <xsl:when test="$node/self::mal:section">
        <xsl:value-of select="concat($node/ancestor::mal:page[1]/@id, '#', $node/@id)"/>
      </xsl:when>
      <xsl:otherwise>
        <xsl:value-of select="$node/@id"/>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:variable>
  <xsl:for-each select="$node/mal:info/mal:link[@type = 'guide']">
    <xsl:variable name="xref" select="@xref"/>
    <mal:link xref="{$xref}">
      <mal:title type="sort">
        <xsl:for-each select="$mal.cache">
          <xsl:value-of select="key('mal.cache.key', $xref)/mal:info/mal:title[@type = 'sort'][1]"/>
        </xsl:for-each>
      </mal:title>
    </mal:link>
  </xsl:for-each>
  <xsl:for-each select="$mal.cache//*[mal:info/mal:link[@type = 'topic'][@xref = $id]]">
    <xsl:variable name="xref" select="@id"/>
    <xsl:if test="not($node/mal:info/mal:link[@type = 'guide'][@xref = $xref])">
      <mal:link xref="{$xref}">
        <mal:title type="sort">
          <xsl:value-of select="mal:info/mal:title[@type = 'sort'][1]"/>
        </mal:title>
      </mal:link>
    </xsl:if>
  </xsl:for-each>
</xsl:template>


<xsl:template name="mal.link.linkid">
  <xsl:param name="node" select="."/>
  <xsl:choose>
    <xsl:when test="contains($node/@id, '#')">
      <xsl:value-of select="$node/@id"/>
    </xsl:when>
    <xsl:when test="$node/self::mal:section">
      <xsl:value-of select="concat($node/ancestor::mal:page[1]/@id, '#', $node/@id)"/>
    </xsl:when>
    <xsl:otherwise>
      <xsl:value-of select="$node/@id"/>
    </xsl:otherwise>
  </xsl:choose>
</xsl:template>

<xsl:template name="mal.link.xref.linkid">
  <xsl:param name="node" select="."/>
  <xsl:param name="xref" select="$node/@xref"/>
  <xsl:if test="starts-with($xref, '#')">
    <xsl:value-of select="$node/ancestor-or-self::mal:page/@id"/>
  </xsl:if>
  <xsl:value-of select="$xref"/>
</xsl:template>

<!--**==========================================================================
mal.link.topiclinks
FIXME

REMARK: FIXME
-->
<xsl:template name="mal.link.topiclinks">
  <xsl:param name="node" select="."/>
  <xsl:variable name="id">
    <xsl:call-template name="mal.link.linkid">
      <xsl:with-param name="node" select="$node"/>
    </xsl:call-template>
  </xsl:variable>
  <xsl:variable name="groups">
    <xsl:value-of select="$node/@groups"/>
    <xsl:if test="not(contains(concat(' ', $node/@groups, ' '), ' #default '))">
      <xsl:text> #default</xsl:text>
    </xsl:if>
  </xsl:variable>
  <xsl:variable name="groupslist" select="str:split($groups)"/>
  <xsl:variable name="defaultpos">
    <xsl:for-each select="$groupslist">
      <xsl:if test="string(.) = '#default'">
        <xsl:value-of select="position()"/>
      </xsl:if>
    </xsl:for-each>
  </xsl:variable>
  <xsl:for-each select="$node/mal:info/mal:link[@type = 'topic']">
    <xsl:variable name="xref">
      <xsl:call-template name="mal.link.xref.linkid"/>
    </xsl:variable>
    <xsl:variable name="link" select="."/>
    <xsl:variable name="grouppos">
      <xsl:if test="$link/@group">
        <xsl:for-each select="$groupslist">
          <xsl:if test="string(.) = $link/@group">
            <xsl:value-of select="position()"/>
          </xsl:if>
        </xsl:for-each>
      </xsl:if>
    </xsl:variable>
    <xsl:variable name="groupsort">
      <xsl:value-of select="$grouppos"/>
      <xsl:if test="string($grouppos) = ''">
        <xsl:value-of select="$defaultpos"/>
      </xsl:if>
    </xsl:variable>
    <mal:link xref="{$xref}">
      <xsl:attribute name="group">
        <xsl:value-of select="$groupslist[number($groupsort)]"/>
      </xsl:attribute>
      <xsl:attribute name="groupsort">
        <xsl:value-of select="$groupsort"/>
      </xsl:attribute>
      <mal:title type="sort">
        <xsl:for-each select="$mal.cache">
          <xsl:value-of select="key('mal.cache.key', $xref)/mal:info/mal:title[@type = 'sort'][1]"/>
        </xsl:for-each>
      </mal:title>
    </mal:link>
  </xsl:for-each>
  <xsl:for-each select="$mal.cache//mal:info/mal:link[@type = 'guide'][@xref = $id]">
    <xsl:variable name="source" select="../.."/>
    <xsl:variable name="xref">
      <xsl:call-template name="mal.link.xref.linkid">
        <xsl:with-param name="node" select="$source"/>
        <xsl:with-param name="xref" select="$source/@id"/>
      </xsl:call-template>
    </xsl:variable>
    <xsl:if test="not($node/mal:info/mal:link[@type = 'topic'][@xref = $xref])">
      <xsl:variable name="link" select="."/>
      <xsl:variable name="grouppos">
        <xsl:if test="$link/@group">
          <xsl:for-each select="$groupslist">
            <xsl:if test="string(.) = $link/@group">
              <xsl:value-of select="position()"/>
            </xsl:if>
          </xsl:for-each>
        </xsl:if>
      </xsl:variable>
      <xsl:variable name="groupsort">
        <xsl:value-of select="$grouppos"/>
        <xsl:if test="string($grouppos) = ''">
          <xsl:value-of select="$defaultpos"/>
        </xsl:if>
      </xsl:variable>
      <mal:link xref="{$xref}">
        <xsl:attribute name="group">
          <xsl:value-of select="$groupslist[number($groupsort)]"/>
        </xsl:attribute>
        <xsl:attribute name="groupsort">
          <xsl:value-of select="$groupsort"/>
        </xsl:attribute>
        <mal:title type="sort">
          <xsl:value-of select="$source/mal:info/mal:title[@type = 'sort'][1]"/>
        </mal:title>
      </mal:link>
    </xsl:if>
  </xsl:for-each>
</xsl:template>

<xsl:param name="mal.link.default_root" select="'index'"/>

<xsl:template name="mal.link.linktrails">
  <xsl:param name="node" select="."/>
  <xsl:param name="trail" select="/false"/>
  <xsl:param name="root" select="$mal.link.default_root"/>
  <xsl:variable name="guidelinks">
    <xsl:call-template name="mal.link.guidelinks">
      <xsl:with-param name="node" select="$node"/>
    </xsl:call-template>
  </xsl:variable>
  <xsl:variable name="guidenodes" select="exsl:node-set($guidelinks)/*"/>
  <xsl:choose>
    <xsl:when test="count($guidenodes) = 0">
      <xsl:choose>
        <xsl:when test="$node/self::mal:section">
          <xsl:variable name="page" select="$node/ancestor::mal:page"/>
          <xsl:call-template name="mal.link.linktrails">
            <xsl:with-param name="node" select="$page"/>
            <xsl:with-param name="trail">
              <mal:link xref="{$page/@id}" child="section">
                <xsl:copy-of select="$page/mal:info/mal:title[@type='sort']"/>
                <xsl:copy-of select="$trail"/>
              </mal:link>
            </xsl:with-param>
            <xsl:with-param name="root" select="$root"/>
          </xsl:call-template>
        </xsl:when>
        <xsl:otherwise>
          <xsl:copy-of select="$trail"/>
        </xsl:otherwise>
      </xsl:choose>
    </xsl:when>
    <xsl:otherwise>
      <xsl:for-each select="$guidenodes">
        <xsl:variable name="self" select="."/>
        <xsl:choose>
          <xsl:when test="$self/@xref = $root">
            <mal:link xref="{$self/@xref}">
              <xsl:copy-of select="$self/mal:title"/>
              <xsl:copy-of select="$trail"/>
            </mal:link>
          </xsl:when>
          <xsl:otherwise>
            <xsl:for-each select="$mal.cache">
              <xsl:call-template name="mal.link.linktrails">
                <xsl:with-param name="node" select="key('mal.cache.key', $self/@xref)"/>
                <xsl:with-param name="trail">
                  <mal:link xref="{$self/@xref}">
                    <xsl:copy-of select="$self/mal:title"/>
                    <xsl:copy-of select="$trail"/>
                  </mal:link>
                </xsl:with-param>
                <xsl:with-param name="root" select="$root"/>
              </xsl:call-template>
            </xsl:for-each>
          </xsl:otherwise>
        </xsl:choose>
      </xsl:for-each>
    </xsl:otherwise>
  </xsl:choose>
</xsl:template>

</xsl:stylesheet>
