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
                xmlns:api="http://projectmallard.org/experimental/api/"
                xmlns:exsl="http://exslt.org/common"
                xmlns:str="http://exslt.org/strings"
                xmlns:html="http://www.w3.org/1999/xhtml"
                xmlns="http://www.w3.org/1999/xhtml"
                exclude-result-prefixes="mal api exsl str html"
                version="1.0">

<!--!!==========================================================================
Mallard to HTML - API Extension
Support for Mallard API extension elements.

This stylesheet contains templates to support features from the Mallard API
extension.
-->


<!--**==========================================================================
mal2html.api.links
Output links as a synopsis for a programming language.
$node: A #{links} element to link from.
$links: A list of links, as from a template in !{mal-link}.

This template outputs links as a synopsis according to the programming language
specified by the #{api:mime} attribute of ${node}. If #{api:mime} is recognized,
one of the language-specific templates in this stylesheet is called. Otherwise,
the links are passed to *{mal2html.links.ul}.

This template does not handle titles or other wrapper information for #{links}
elements. It should be called by an appropriate template that handles the
#{links} element.
-->
<xsl:template name="mal2html.api.links">
  <xsl:param name="node"/>
  <xsl:param name="links"/>
  <xsl:variable name="apilinks_">
    <xsl:for-each select="$links">
      <xsl:variable name="link" select="."/>
      <xsl:for-each select="$mal.cache">
        <xsl:variable name="target" select="key('mal.cache.key', $link/@xref)"/>
        <xsl:variable name="apiname" select="$target/mal:info/api:*/api:name[1]"/>
        <xsl:for-each select="$link">
          <xsl:copy>
            <xsl:copy-of select="@*"/>
            <xsl:copy-of select="*"/>
            <xsl:copy-of select="$apiname"/>
          </xsl:copy>
        </xsl:for-each>
      </xsl:for-each>
    </xsl:for-each>
  </xsl:variable>
  <xsl:variable name="apilinks" select="exsl:node-set($apilinks_)/*"/>
  <xsl:variable name="out_">
    <xsl:for-each select="$apilinks">
      <xsl:sort select="api:name"/>
      <xsl:sort data-type="number" select="@groupsort"/>
      <xsl:sort select="mal:title[@type = 'sort']"/>
      <xsl:variable name="link" select="."/>
      <xsl:choose>
        <xsl:when test="$node/@api:mime = 'text/x-csrc' or $node/@api:mime = 'text/x-chdr'">
          <xsl:call-template name="mal2html.api.link.c">
            <xsl:with-param name="node" select="$node"/>
            <xsl:with-param name="links" select="$links"/>
            <xsl:with-param name="link" select="$link"/>
          </xsl:call-template>
        </xsl:when>
        <xsl:otherwise>
          <xsl:copy-of select="$link"/>
        </xsl:otherwise>
      </xsl:choose>
    </xsl:for-each>
  </xsl:variable>
  <xsl:variable name="out" select="exsl:node-set($out_)"/>
  <xsl:if test="$out/*[not(self::mal:link)]">
    <div class="synopsis">
      <pre class="contents">
        <xsl:copy-of select="$out/*[not(self::mal:link)]"/>
      </pre>
    </div>
  </xsl:if>
  <xsl:if test="$out/mal:link">
    <xsl:call-template name="mal2html.links.ul">
      <xsl:with-param name="node" select="$node"/>
      <xsl:with-param name="links" select="$out/mal:link"/>
    </xsl:call-template>
  </xsl:if>
</xsl:template>


<!--**==========================================================================
mal2html.api.link.c
Output a link for a synopsis in C.
$node: A #{links} element to link from.
$links: A list of links, as from a template in !{mal-link}.
$link: The #{mal:link} element from ${links} to process.

This template formats a link for a synopsis in the C programming language. It
is called by *{mal2html.api.links} when the #{api:mime} attribute of ${node}
is #{text/x-csrc} or #{text/x-chdr}. The target node of ${link} is expected to
have appropriate #{api:*} elements in its #{info} element. If it does not, this
template returns ${link} unaltered. *{mal2html.api.links} collects unhandled
links and displays them after the synopsis.

This template calls other templates to format the link, based on what type of
API the target node is declared as.
-->
<xsl:template name="mal2html.api.link.c">
  <xsl:param name="node"/>
  <xsl:param name="links"/>
  <xsl:param name="link"/>
  <xsl:for-each select="$mal.cache">
    <xsl:variable name="target" select="key('mal.cache.key', $link/@xref)"/>
    <xsl:choose>
      <xsl:when test="$target/mal:info/api:function/api:name">
        <xsl:call-template name="mal2html.api.link.c.function">
          <xsl:with-param name="node" select="$node"/>
          <xsl:with-param name="links" select="$links"/>
          <xsl:with-param name="link" select="$link"/>
          <xsl:with-param name="target" select="$target"/>
        </xsl:call-template>
      </xsl:when>
      <xsl:otherwise>
        <xsl:copy-of select="$link"/>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:for-each>
</xsl:template>


<!--**==========================================================================
mal2html.api.link.c.function
Output a link as a function for a synopsis in C.
$node: A #{links} element to link from.
$links: A list of links, as from a template in !{mal-link}.
$link: The #{mal:link} element from ${links} to process.
$target: The node pointed to by ${link}.

This template formats a link formatted as a function for a synopsis in the C
programming language. It is called by *{mal2html.api.link.c} when the ${target}
contains an #{api:function} element in its #{info}.
-->
<xsl:template name="mal2html.api.link.c.function">
  <xsl:param name="node"/>
  <xsl:param name="links"/>
  <xsl:param name="link"/>
  <xsl:param name="target"/>
  <xsl:variable name="function" select="$target/mal:info/api:function"/>
  <div class="{$link/@class}">
    <xsl:for-each select="$link/@*">
      <xsl:if test="starts-with(name(.), 'data-')">
        <xsl:copy-of select="."/>
      </xsl:if>
    </xsl:for-each>
    <xsl:variable name="type">
      <xsl:choose>
        <xsl:when test="$function/api:returns/api:type">
          <xsl:apply-templates mode="mal2html.inline.mode" select="$function/api:returns/api:type/node()"/>
        </xsl:when>
        <xsl:otherwise>
          <xsl:text>int</xsl:text>
        </xsl:otherwise>
      </xsl:choose>
    </xsl:variable>
    <xsl:variable name="tab" select="20 - string-length($type)"/>
    <xsl:copy-of select="$type"/>
    <xsl:choose>
      <xsl:when test="$tab > 1">
        <xsl:value-of select="str:padding($tab)"/>
      </xsl:when>
      <xsl:otherwise>
        <xsl:text>&#x000A;</xsl:text>
        <xsl:text>                    </xsl:text>
      </xsl:otherwise>
    </xsl:choose>
    <xsl:variable name="name">
      <xsl:apply-templates mode="mal2html.inline.mode" select="$function/api:name/node()"/>
    </xsl:variable>
    <a>
      <xsl:attribute name="href">
        <xsl:call-template name="mal.link.target">
          <xsl:with-param name="node" select="$node"/>
          <xsl:with-param name="xref" select="$link/@xref"/>
        </xsl:call-template>
      </xsl:attribute>
      <xsl:attribute name="title">
        <xsl:call-template name="mal.link.tooltip">
          <xsl:with-param name="node" select="$node"/>
          <xsl:with-param name="xref" select="$link/@xref"/>
        </xsl:call-template>
      </xsl:attribute>
      <xsl:copy-of select="$name"/>
    </a>
    <xsl:variable name="paren" select="40 - string-length($name)"/>
    <xsl:choose>
      <xsl:when test="$paren > 1">
        <xsl:value-of select="str:padding($paren)"/>
      </xsl:when>
      <xsl:otherwise>
        <xsl:text>&#x000A;</xsl:text>
        <xsl:value-of select="str:padding(60)"/>
      </xsl:otherwise>
    </xsl:choose>
    <xsl:text>(</xsl:text>
    <xsl:for-each select="$function/api:arg">
      <xsl:if test="position() != 1">
        <xsl:value-of select="str:padding(61)"/>
      </xsl:if>
      <xsl:apply-templates mode="mal2html.inline.mode" select="api:type/node()"/>
      <xsl:if test="api:type and (
                    substring(api:type, string-length(api:type)) != '*'
                    or not(contains(api:type, '*')))">
        <xsl:text> </xsl:text>
      </xsl:if>
      <xsl:apply-templates mode="mal2html.inline.mode" select="api:name/node()"/>
      <xsl:choose>
        <xsl:when test="position() != last()">
          <xsl:text>,</xsl:text>
        </xsl:when>
        <xsl:otherwise>
          <xsl:text>);</xsl:text>
        </xsl:otherwise>
      </xsl:choose>
      <xsl:text>&#x000A;</xsl:text>
    </xsl:for-each>
    <xsl:if test="not($function/api:arg)">
      <xsl:text>void);&#x000A;</xsl:text>
    </xsl:if>
  </div>
</xsl:template>

</xsl:stylesheet>
