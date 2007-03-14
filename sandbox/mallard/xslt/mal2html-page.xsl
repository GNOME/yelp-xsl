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
                xmlns:mal="http://www.gnome.org/~shaunm/mallard"
                xmlns="http://www.w3.org/1999/xhtml"
                version="1.0">

<!--!!==========================================================================
Mallard to HTML - Pages

REMARK: Describe this module
-->


<!--**==========================================================================
mal2html.page.copyright
Outputs the copyright notice at the bottom of a page
$node: The top-level #{topic} or #{guide} element

REMARK: Describe this template
-->
<xsl:template name="db2html.page.copyrights">
  <xsl:param name="node"/>
  <div class="copyrights">
    <xsl:for-each select="$node/mal:info/mal:copyright">
      <div class="copyright">
        <!-- FIXME: i18n -->
        <xsl:value-of select="concat('© ', @year, ' ', @name)"/>
      </div>
    </xsl:for-each>
  </div>
</xsl:template>


<!--**==========================================================================
mal2html.page.guidelinks
Outputs the automatic links from a page to guide pages and sections
$node: The #{topic}, #{guide}, or #{section} element containing the links

REMARK: Describe this template
-->
<xsl:template name="mal2html.page.guidelinks">
  <xsl:param name="node" select="."/>
  <xsl:variable name="id">
    <xsl:choose>
      <xsl:when test="$node/self::mal:section">
        <xsl:value-of select="concat((ancestor::mal:guide[1] | ancestor::mal:topic[1])[1]/@id, '#', @id)"/>
      </xsl:when>
      <xsl:otherwise>
        <xsl:value-of select="@id"/>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:variable>
  <!-- FIXME: // is slow -->
  <xsl:variable name="pagelinks"
                select="$cache//*[mal:info/mal:link[@type = 'page'][@xref = $id]]"/>
  <xsl:variable name="guidelinks"
                select="$node/mal:info/mal:link[@type = 'guide']"/>
  <xsl:if test="$pagelinks or $guidelinks">
    <ul class="guidelinks">
      <xsl:for-each select="$pagelinks">
        <xsl:variable name="position">
          <xsl:choose>
            <xsl:when test="last() = 1 and count($guidelinks) = 0">
              <xsl:text>only</xsl:text>
            </xsl:when>
            <xsl:when test="position() = 1">
              <xsl:text>first</xsl:text>
            </xsl:when>
            <xsl:when test="position() = last() and count($guidelinks) = 0">
              <xsl:text>last</xsl:text>
            </xsl:when>
          </xsl:choose>
        </xsl:variable>
        <xsl:call-template name="mal2html.page.guidelink">
          <xsl:with-param name="node" select="$node"/>
          <xsl:with-param name="page" select="."/>
          <xsl:with-param name="position" select="$position"/>
        </xsl:call-template>
      </xsl:for-each>
      <!-- FIXME: exclude pagelinks -->
      <xsl:for-each select="$guidelinks">
        <xsl:variable name="linkid">
          <xsl:choose>
            <xsl:when test="contains(@xref, '#')">
              <xsl:value-of select="@xref"/>
            </xsl:when>
            <xsl:otherwise>
              <xsl:value-of select="concat(@xref, '#', @xref)"/>
            </xsl:otherwise>
          </xsl:choose>
        </xsl:variable>
        <xsl:variable name="position">
          <xsl:choose>
            <xsl:when test="last() = 1 and count($pagelinks) = 0">
              <xsl:text>only</xsl:text>
            </xsl:when>
            <xsl:when test="position() = 1 and count($pagelinks) = 0">
              <xsl:text>first</xsl:text>
            </xsl:when>
            <xsl:when test="position() = last()">
              <xsl:text>last</xsl:text>
            </xsl:when>
          </xsl:choose>
        </xsl:variable>
        <xsl:for-each select="$cache">
          <xsl:call-template name="mal2html.page.guidelink">
            <xsl:with-param name="node" select="$node"/>
            <xsl:with-param name="page" select="key('cache_key', $linkid)"/>
            <xsl:with-param name="position" select="$position"/>
          </xsl:call-template>
        </xsl:for-each>
      </xsl:for-each>
    </ul>
  </xsl:if>
  <!-- END guidelinks -->
</xsl:template>


<!--**==========================================================================
mal2html.page.guidelink
Outputs an automatic link block from a page or section to a guide
$node: The #{topic}, #{guide}, or #{section} element containing the link
$page: The element from the cache file of the page being linked to
$position: The position of this link in the list, either 'first', 'last', or ''

REMARK: Describe this template
-->
<xsl:template name="mal2html.page.guidelink">
  <xsl:param name="node" select="."/>
  <xsl:param name="page"/>
  <xsl:param name="position"/>
  <xsl:variable name="xref">
    <xsl:choose>
      <xsl:when test="$page/self::mal:section">
        <xsl:value-of select="($page/ancestor::mal:guide | $page/ancestor::mal:topic)[1]/@id"/>
        <xsl:text>#</xsl:text>
        <xsl:value-of select="$page/@id"/>
      </xsl:when>
      <xsl:otherwise>
        <xsl:value-of select="$page/@id"/>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:variable>
  <li>
    <xsl:attribute name="class">
      <xsl:text>guidelink</xsl:text>
      <xsl:choose>
        <xsl:when test="$position = 'only'">
          <xsl:text> guidelink-only</xsl:text>
        </xsl:when>
        <xsl:when test="$position = 'first'">
          <xsl:text> guidelink-first</xsl:text>
        </xsl:when>
        <xsl:when test="$position = 'last'">
          <xsl:text> guidelink-last</xsl:text>
        </xsl:when>
      </xsl:choose>
    </xsl:attribute>
    <a>
      <xsl:attribute name="href">
        <xsl:call-template name="mal.link.target">
          <xsl:with-param name="xref" select="$xref"/>
        </xsl:call-template>
      </xsl:attribute>
      <xsl:call-template name="mal.link.content">
        <xsl:with-param name="node" select="."/>
        <xsl:with-param name="xref" select="$xref"/>
      </xsl:call-template>
    </a>
  </li>
</xsl:template>


<!--**==========================================================================
mal2html.page.pagelinks
Outputs the automatic links from a guide page or guide section
$node: The #{guide} or #{section} element containing the links

REMARK: Describe this template
-->
<xsl:template name="mal2html.page.pagelinks">
  <xsl:param name="node" select="."/>
  <xsl:variable name="id">
    <xsl:choose>
      <xsl:when test="$node/self::mal:section">
        <xsl:value-of select="concat(ancestor::mal:guide[1]/@id, '#', @id)"/>
      </xsl:when>
      <xsl:otherwise>
        <xsl:value-of select="@id"/>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:variable>
  <xsl:variable name="pagelinks"
                select="$node/mal:info/mal:link[@type = 'page']"/>
  <!-- FIXME: // selectors are slow -->
  <!-- FIXME: exclude $pagelinks from $guidelinks -->
  <xsl:variable name="guidelinks"
                select="$cache//*[mal:info/mal:link[@type = 'guide'][@xref = $id]]"/>
  <xsl:if test="$pagelinks or $guidelinks">
    <div class="pagelinks">
      <xsl:for-each select="$pagelinks">
        <xsl:variable name="linkid">
          <xsl:choose>
            <xsl:when test="contains(@xref, '#')">
              <xsl:value-of select="@xref"/>
            </xsl:when>
            <xsl:otherwise>
              <xsl:value-of select="concat(@xref, '#', @xref)"/>
            </xsl:otherwise>
          </xsl:choose>
        </xsl:variable>
        <xsl:variable name="position">
          <xsl:choose>
            <xsl:when test="last() = 1 and count($guidelinks) = 0">
              <xsl:text>only</xsl:text>
            </xsl:when>
            <xsl:when test="position() = 1">
              <xsl:text>first</xsl:text>
            </xsl:when>
            <xsl:when test="position() = last() and count($guidelinks) = 0">
              <xsl:text>last</xsl:text>
            </xsl:when>
          </xsl:choose>
        </xsl:variable>
        <xsl:for-each select="$cache">
          <xsl:call-template name="mal2html.page.pagelink">
            <xsl:with-param name="node" select="$node"/>
            <xsl:with-param name="page" select="key('cache_key', $linkid)"/>
            <xsl:with-param name="position" select="$position"/>
          </xsl:call-template>
        </xsl:for-each>
      </xsl:for-each>
      <xsl:for-each select="$guidelinks">
        <xsl:sort select="mal:info/mal:link[@type = 'guide'][@xref = $id]/@weight"
                  data-type="number" order="descending"/>
        <!-- FIXME: lang -->
        <xsl:sort select="mal:info/mal:title[@type = 'sort']"
                  data-type="text" order="ascending"/>
        <xsl:call-template name="mal2html.page.pagelink">
          <xsl:with-param name="node" select="$node"/>
          <xsl:with-param name="page" select="."/>
          <xsl:with-param name="position">
            <xsl:choose>
              <xsl:when test="last() = 1 and count($pagelinks) = 0">
                <xsl:text>only</xsl:text>
              </xsl:when>
              <xsl:when test="position() = 1 and count($pagelinks) = 0">
                <xsl:text>first</xsl:text>
              </xsl:when>
              <xsl:when test="position() = last()">
                <xsl:text>last</xsl:text>
              </xsl:when>
            </xsl:choose>
          </xsl:with-param>
        </xsl:call-template>
      </xsl:for-each>
    </div>
  </xsl:if>
</xsl:template>


<!--**==========================================================================
mal2html.page.pagelink
Outputs an automatic link block from a guide to a page
$node: The #{guide} or #{section} element containing the link
$page: The element from the cache file of the page being linked to
$position: The position of this link in the list, either 'first', 'last', or ''

REMARK: Describe this template
-->
<xsl:template name="mal2html.page.pagelink">
  <xsl:param name="node" select="."/>
  <xsl:param name="page"/>
  <xsl:param name="position"/>
  <xsl:variable name="xref">
    <xsl:choose>
      <xsl:when test="$page/self::mal:section">
        <xsl:value-of select="($page/ancestor::mal:guide | $page/ancestor::mal:topic)[1]/@id"/>
        <xsl:text>#</xsl:text>
        <xsl:value-of select="$page/@id"/>
      </xsl:when>
      <xsl:otherwise>
        <xsl:value-of select="$page/@id"/>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:variable>
  <xsl:variable name="linkid">
    <xsl:choose>
      <xsl:when test="contains($xref, '#')">
        <xsl:value-of select="$xref"/>
      </xsl:when>
      <xsl:otherwise>
        <xsl:value-of select="concat($xref, '#', $xref)"/>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:variable>
  <a>
    <xsl:attribute name="href">
      <xsl:call-template name="mal.link.target">
        <xsl:with-param name="xref" select="$xref"/>
      </xsl:call-template>
    </xsl:attribute>
    <div>
      <xsl:attribute name="class">
        <xsl:text>pagelink</xsl:text>
        <xsl:choose>
          <xsl:when test="$position = 'only'">
            <xsl:text> pagelink-only</xsl:text>
          </xsl:when>
          <xsl:when test="$position = 'first'">
            <xsl:text> pagelink-first</xsl:text>
          </xsl:when>
          <xsl:when test="$position = 'last'">
            <xsl:text> pagelink-last</xsl:text>
          </xsl:when>
        </xsl:choose>
      </xsl:attribute>
      <!-- FIXME: call a common linkifier? -->
      <div class="title">
        <xsl:call-template name="mal.link.content">
          <xsl:with-param name="node" select="."/>
          <xsl:with-param name="xref" select="$xref"/>
        </xsl:call-template>
      </div>
      <xsl:for-each select="$cache">
        <xsl:variable name="desc"
                      select="key('cache_key', $linkid)/mal:info/mal:desc[1]"/>
        <xsl:if test="$desc">
          <div class="desc">
            <!-- FIXME: should desc contain inline or block? -->
            <xsl:apply-templates mode="mal2html.inline.mode" select="$desc/node()"/>
          </div>
        </xsl:if>
      </xsl:for-each>
    </div>
  </a>
</xsl:template>


<!--**==========================================================================
mal2html.page.seealsolinks
Outputs the automatic seealso links from a page related pages
$node: The #{topic} or #{section} element containing the links

REMARK: Describe this template
-->
<xsl:template name="mal2html.page.seealsolinks">
  <xsl:param name="node" select="."/>
  <xsl:variable name="id">
    <xsl:choose>
      <xsl:when test="$node/self::mal:section">
        <xsl:value-of select="concat(ancestor::mal:topic[1]/@id, '#', @id)"/>
      </xsl:when>
      <xsl:otherwise>
        <xsl:value-of select="@id"/>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:variable>
  <!-- FIXME: // is slow -->
  <xsl:variable name="inlinks"
                select="$cache//*[mal:info/mal:link[@type = 'seealso'][@xref = $id]]"/>
  <xsl:variable name="outlinks"
                select="$node/mal:info/mal:link[@type = 'seealso']"/>
  <xsl:if test="$inlinks or $outlinks">
    <div class="seealsolinks">
      <!-- FIXME: i18n -->
      <div class="title">See Also</div>
      <xsl:for-each select="$inlinks">
        <xsl:call-template name="mal2html.page.seealsolink">
          <xsl:with-param name="node" select="$node"/>
          <xsl:with-param name="page" select="."/>
          <xsl:with-param name="position">
            <xsl:choose>
              <xsl:when test="last() = 1 and count($outlinks) = 0">
                <xsl:text>only</xsl:text>
              </xsl:when>
              <xsl:when test="position() = 1">
                <xsl:text>first</xsl:text>
              </xsl:when>
              <xsl:when test="position() = last() and count($outlinks) = 0">
                <xsl:text>last</xsl:text>
              </xsl:when>
            </xsl:choose>
          </xsl:with-param>
        </xsl:call-template>
      </xsl:for-each>
      <xsl:for-each select="$outlinks">
        <xsl:variable name="linkid">
          <xsl:choose>
            <xsl:when test="contains(@xref, '#')">
              <xsl:value-of select="@xref"/>
            </xsl:when>
            <xsl:otherwise>
              <xsl:value-of select="concat(@xref, '#', @xref)"/>
            </xsl:otherwise>
          </xsl:choose>
        </xsl:variable>
        <xsl:variable name="position">
          <xsl:choose>
            <xsl:when test="last() = 1 and count($inlinks) = 0">
              <xsl:text>only</xsl:text>
            </xsl:when>
            <xsl:when test="position() = 1 and count($inlinks) = 0">
              <xsl:text>first</xsl:text>
            </xsl:when>
            <xsl:when test="position() = last()">
              <xsl:text>last</xsl:text>
            </xsl:when>
          </xsl:choose>
        </xsl:variable>
        <xsl:for-each select="$cache">
          <xsl:call-template name="mal2html.page.seealsolink">
            <xsl:with-param name="node" select="$node"/>
            <xsl:with-param name="page" select="key('cache_key', $linkid)"/>
            <xsl:with-param name="position" select="$position"/>
          </xsl:call-template>
        </xsl:for-each>
      </xsl:for-each>
    </div>
  </xsl:if>
  <!-- END guidelinks -->
</xsl:template>


<!--**==========================================================================
mal2html.page.seealsolink
Outputs an automatic link block for a seealso link
$node: The #{topic} or #{section} element containing the link
$page: The element from the cache file of the page being linked to
$position: The position of this link in the list, either 'first', 'last', or ''

REMARK: Describe this template
-->
<xsl:template name="mal2html.page.seealsolink">
  <xsl:param name="node" select="."/>
  <xsl:param name="page"/>
  <xsl:param name="position"/>
  <xsl:variable name="xref">
    <xsl:choose>
      <xsl:when test="$page/self::mal:section">
        <xsl:value-of select="($page/ancestor::mal:guide | $page/ancestor::mal:topic)[1]/@id"/>
        <xsl:text>#</xsl:text>
        <xsl:value-of select="$page/@id"/>
      </xsl:when>
      <xsl:otherwise>
        <xsl:value-of select="$page/@id"/>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:variable>
  <div>
    <xsl:attribute name="class">
      <xsl:text>seealsolink</xsl:text>
      <xsl:choose>
        <xsl:when test="$position = 'only'">
          <xsl:text> seealsolink-only</xsl:text>
        </xsl:when>
        <xsl:when test="$position = 'first'">
          <xsl:text> seealsolink-first</xsl:text>
        </xsl:when>
        <xsl:when test="$position = 'last'">
          <xsl:text> seealsolink-last</xsl:text>
        </xsl:when>
      </xsl:choose>
    </xsl:attribute>
    <a>
      <xsl:attribute name="href">
        <xsl:call-template name="mal.link.target">
          <xsl:with-param name="xref" select="$xref"/>
        </xsl:call-template>
      </xsl:attribute>
      <xsl:call-template name="mal.link.content">
        <xsl:with-param name="node" select="."/>
        <xsl:with-param name="xref" select="$xref"/>
      </xsl:call-template>
    </a>
  </div>
</xsl:template>


<!--**==========================================================================
mal2html.page.sidebar
Outputs the sidebar for a structural element
$node: A #{topic}, #{guide}, or #{section} element

REMARK: Describe this template
-->
<xsl:template name="mal2html.page.sidebar">
  <xsl:param name="node" select="."/>
  <xsl:variable name="guidelinks">
    <xsl:call-template name="mal2html.page.guidelinks">
      <xsl:with-param name="node" select="$node"/>
    </xsl:call-template>
  </xsl:variable>
  <xsl:variable name="seealsolinks">
    <xsl:call-template name="mal2html.page.seealsolinks">
      <xsl:with-param name="node" select="$node"/>
    </xsl:call-template>
  </xsl:variable>
  <xsl:if test="$guidelinks or $seealsolinks">
    <div class="sidebar">
      <xsl:copy-of select="$guidelinks"/>
      <xsl:copy-of select="$seealsolinks"/>
    </div>
  </xsl:if>
</xsl:template>


<!--**==========================================================================
mal2html.page.css
Outputs CSS that controls the appearance of page elements

REMARK: Describe this template
-->
<xsl:template name="mal2html.page.css">
<xsl:text>
html { height: 100%; }
body {
  direction: </xsl:text><xsl:call-template name="l10n.direction"/><xsl:text>;
  margin: 0px;
  background-color: </xsl:text>
  <xsl:call-template name="theme.get_color">
    <xsl:with-param name="id" select="'gray-background'"/>
  </xsl:call-template>
  <xsl:text>;
  padding: 12px;
  min-height: 100%;
}
<!-- FIXME: only in editor mode & better colors -->
<!--
body.status-stub { background-color: #ffedc9; }
body.status-draft { background-color: #ffedc9; }
body.status-incomplete { background-color: #ffedc9; }
body.status-review { background-color: #ffedc9; }
-->
div.version {
  margin: 0 0 1em 0;
  padding: 0.5em 1em 0.5em 1em;
  max-width: 60em;
  border: solid 1px </xsl:text>
  <xsl:call-template name="theme.get_color">
    <xsl:with-param name="id" select="'gray-border'"/>
  </xsl:call-template>
  <xsl:text>;
  background-color: </xsl:text>
  <xsl:call-template name="theme.get_color">
    <xsl:with-param name="id" select="'yellow-background'"/>
  </xsl:call-template>
  <xsl:text>;
}
div.version p.version {
  margin-top: 0.2em;
}
div.body {
  margin: 0;
  padding: 1em;
  max-width: 60em;
  min-height: 20em;
  border: solid 1px </xsl:text>
  <xsl:call-template name="theme.get_color">
    <xsl:with-param name="id" select="'gray-border'"/>
  </xsl:call-template>
  <xsl:text>;
  background-color: </xsl:text>
  <xsl:call-template name="theme.get_color">
    <xsl:with-param name="id" select="'background'"/>
  </xsl:call-template>
  <xsl:text>;
}
div.copyrights {
  text-align: center;
  color: </xsl:text>
  <xsl:call-template name="theme.get_color">
    <xsl:with-param name="id" select="'text-light'"/>
  </xsl:call-template>
  <xsl:text>;
}
div.section { margin-top: 2em; clear: both; }
div.section div.section { margin-top: 1.72em; margin-left: 1.72em; }
div.section div.section div.section { margin-top: 1.44em; }
div.header {
  margin: 0;
  color: </xsl:text>
  <xsl:call-template name="theme.get_color">
    <xsl:with-param name="id" select="'text-light'"/>
  </xsl:call-template>
  <xsl:text>;
  border-bottom: solid 1px </xsl:text>
  <xsl:call-template name="theme.get_color">
    <xsl:with-param name="id" select="'gray-border'"/>
  </xsl:call-template>
  <xsl:text>;
}
div.section div.section div.header { border: none; }
h1, h2, h3, h4, h5, h6, h7 { margin: 0; }
h1.title { font-size: 1.72em; }
h2.title { font-size: 1.44em; }
h3.title { font-size: 1.2em; }
h4.title { font-size: 1em; }
h5.title { font-size: 1em; }
h6.title { font-size: 1em; }
h7.title { font-size: 1em; }

div.pagelink div.title {
  font-size: 1em;
  color: inherit;
}
div.pagelink div.desc {
  margin-top: 0.2em;
  color: </xsl:text>
  <xsl:call-template name="theme.get_color">
    <xsl:with-param name="id" select="'text-light'"/>
  </xsl:call-template>
  <xsl:text>;
}
div.pagelink {
  margin: 0;
  padding: 0.5em;
  border: solid 1px </xsl:text>
  <xsl:call-template name="theme.get_color">
    <xsl:with-param name="id" select="'background'"/>
  </xsl:call-template>
  <xsl:text>;
}
div.pagelink:hover {
  border-color: </xsl:text>
  <xsl:call-template name="theme.get_color">
    <xsl:with-param name="id" select="'blue-medium'"/>
  </xsl:call-template>
  <xsl:text>;
  background-color: </xsl:text>
  <xsl:call-template name="theme.get_color">
    <xsl:with-param name="id" select="'blue-light'"/>
  </xsl:call-template>
  <xsl:text>;
}
div.sidebar { margin: 0; }
ul.guidelinks {
  display: block;
  margin: 0;
  text-align: right;
}
li.guidelink { display: inline; }
li.guidelink::before {
  content: ' • ';
  color: </xsl:text>
  <xsl:call-template name="theme.get_color">
    <xsl:with-param name="id" select="'gray-dark'"/>
  </xsl:call-template>
  <xsl:text>;
}
li.guidelink-first::before, li.guidelink-only::before {
  content: '';
}


div.sidebar div.title {
  font-size: 1em;
  font-weight: normal;
  display: inline;
}
div.seealsolinks { margin: 0; }
div.seealsolink {
  display: inline;
}
div.seealsolink::before {
  content: ' • ';
  color: </xsl:text>
  <xsl:call-template name="theme.get_color">
    <xsl:with-param name="id" select="'gray-dark'"/>
  </xsl:call-template>
  <xsl:text>;
}
div.seealsolink-first::before, div.seealsolink-only::before {
  content: ' : ';
}
</xsl:text>
</xsl:template>


<!-- == Matched Templates == -->

<!-- = / = -->
<xsl:template match="/">
  <!-- FIXME: find a way to just select the version element -->
  <xsl:variable name="date">
    <xsl:for-each select="*/mal:info/mal:version">
      <xsl:sort select="@date" data-type="text" order="descending"/>
      <xsl:if test="position() = 1">
        <xsl:value-of select="@date"/>
      </xsl:if>
    </xsl:for-each>
  </xsl:variable>
  <xsl:variable name="version"
                select="*/mal:info/mal:version[@date = $date][last()]"/>
  <html>
    <head>
      <title>
        <xsl:value-of select="/*/mal:title"/>
      </title>
      <xsl:call-template name="mal2html.css"/>
    </head>
    <body>
      <!-- FIXME: only in editor mode -->
      <xsl:if test="$version/@status != ''">
        <xsl:attribute name="class">
          <xsl:value-of select="concat(' status-', $version/@status)"/>
        </xsl:attribute>
        <div class="version">
          <!-- FIXME: i18n -->
          <div class="title">Version Information</div>
          <p class="version">
            <xsl:text>Version </xsl:text>
            <xsl:value-of select="$version/@number"/>
            <xsl:text> on </xsl:text>
            <xsl:value-of select="$version/@date"/>
            <xsl:text> (</xsl:text>
            <xsl:choose>
              <xsl:when test="$version/@status = 'stub'">
                <xsl:text>Stub</xsl:text>
              </xsl:when>
              <xsl:when test="$version/@status = 'incomplete'">
                <xsl:text>Incomplete</xsl:text>
              </xsl:when>
              <xsl:when test="$version/@status = 'draft'">
                <xsl:text>Draft</xsl:text>
              </xsl:when>
              <xsl:when test="$version/@status = 'review'">
                <xsl:text>Ready for review</xsl:text>
              </xsl:when>
              <xsl:when test="$version/@status = 'final'">
                <xsl:text>Final</xsl:text>
              </xsl:when>
            </xsl:choose>
            <xsl:text>)</xsl:text>
          </p>
          <xsl:apply-templates mode="mal2html.block.mode" select="$version/*"/>
        </div>
      </xsl:if>
      <div class="body">
        <xsl:apply-templates/>
      </div>
      <xsl:call-template name="db2html.page.copyrights">
        <xsl:with-param name="node" select="mal:topic | mal:guide"/>
      </xsl:call-template>
    </body>
  </html>
</xsl:template>

<!-- = guide = -->
<xsl:template match="mal:guide">
  <div class="header">
    <xsl:apply-templates mode="mal2html.block.mode"
                         select="mal:title | mal:subtitle"/>
  </div>
  <xsl:call-template name="mal2html.page.sidebar"/>
  <div class="contents">
    <xsl:apply-templates
        mode="mal2html.block.mode"
        select="*[not(self::mal:section | self::mal:title | self::mal:subtitle)]"/>
    <xsl:call-template name="mal2html.page.pagelinks"/>
  </div>
  <xsl:apply-templates select="mal:section"/>
</xsl:template>

<!-- = topic = -->
<xsl:template match="mal:topic">
  <div class="header">
    <xsl:apply-templates mode="mal2html.block.mode"
                         select="mal:title | mal:subtitle"/>
  </div>
  <xsl:call-template name="mal2html.page.sidebar"/>
  <div class="contents">
    <xsl:apply-templates
        mode="mal2html.block.mode"
        select="*[not(self::mal:section | self::mal:title | self::mal:subtitle)]"/>
  </div>
  <xsl:apply-templates select="mal:section"/>
</xsl:template>

<!-- = section = -->
<xsl:template match="mal:section">
  <div class="section" id="{@id}">
    <div class="header">
      <xsl:apply-templates mode="mal2html.block.mode"
                           select="mal:title | mal:subtitle"/>
    </div>
    <xsl:call-template name="mal2html.page.sidebar"/>
    <div class="contents">
      <xsl:apply-templates
          mode="mal2html.block.mode"
          select="*[not(self::mal:section | self::mal:title | self::mal:subtitle)]"/>
      <xsl:if test="ancestor::mal:guide">
        <xsl:call-template name="mal2html.page.pagelinks"/>
      </xsl:if>
    </div>
    <xsl:apply-templates select="mal:section"/>
  </div>
</xsl:template>

<!-- = title = -->
<xsl:template mode="mal2html.block.mode" match="mal:title">
  <xsl:variable name="depth"
                select="count(ancestor::mal:section) + 1"/>
  <xsl:element name="{concat('h', $depth)}">
    <xsl:attribute name="class">
      <xsl:text>title</xsl:text>
    </xsl:attribute>
    <xsl:apply-templates mode="mal2html.inline.mode"/>
  </xsl:element>
</xsl:template>

</xsl:stylesheet>
