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
Output an HTML `div` element.
@revision[version=3.8 date=2012-10-04 status=incomplete]

[xsl:params]
$node: The source element to output a `div` for.
$class: The value of the HTML `class` attribute.

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
Output an HTML `p` element.
@revision[version=3.8 date=2012-10-04 status=incomplete]

[xsl:params]
$node: The source element to output a `p` for.
$class: The value of the HTML `class` attribute.

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
Output an HTML `pre` element.
@revision[version=3.8 date=2012-10-05 status=incomplete]

[xsl:params]
$node: The source element to output a `pre` for.
$class: The value of the HTML `class` attribute.

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
    <pre class="contents"><code>
      <xsl:if test="$html.syntax.highlight">
        <xsl:attribute name="class">
          <xsl:call-template name="html.syntax.class">
            <xsl:with-param name="node" select="$node"/>
          </xsl:call-template>
        </xsl:attribute>
      </xsl:if>
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
      <xsl:apply-templates mode="dita2html.topic.mode"
                           select="$children[not(position() = 1 and self::text())]"/>
    </code></pre>
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

<xsl:template mode="html.syntax.class.mode" match="&topic_codeblock; | &topic_screen;">
  <xsl:param name="language" select="translate(@outputclass,
                                     'ABCDEFGHIJKLMNOPQRSTUVWXYX',
                                     'abcdefghijklmnopqrstuvwxyz')"/>
  <xsl:choose>
    <!-- ActionScript -->
    <xsl:when test="$language = 'actionscript'">
      <xsl:text>actionscript</xsl:text>
    </xsl:when>
    <!-- Apache -->
    <xsl:when test="$language = 'apache'">
      <xsl:text>apache</xsl:text>
    </xsl:when>
    <!-- AsciiDoc -->
    <xsl:when test="$language = 'asciidoc' or $language = 'adoc'">
      <xsl:text>asciidoc</xsl:text>
    </xsl:when>
    <!-- Awk -->
    <xsl:when test="$language = 'awk'">
      <xsl:text>awk</xsl:text>
    </xsl:when>
    <!-- Bash -->
    <xsl:when test="$language = 'sh' or $language = 'bash' or
                    $language = 'csh' or $language = 'bourne'">
      <xsl:text>bash</xsl:text>
    </xsl:when>
    <!-- C -->
    <xsl:when test="$language = 'c'">
      <xsl:text>c</xsl:text>
    </xsl:when>
    <!-- C# -->
    <xsl:when test="$language = 'cs' or $language = 'csharp'">
      <xsl:text>csharp</xsl:text>
    </xsl:when>
    <!-- C++ -->
    <xsl:when test="$language = 'cpp' or $language = 'c++'">
      <xsl:text>cpp</xsl:text>
    </xsl:when>
    <!-- Clojure -->
    <xsl:when test="$language = 'clojure' or $language = 'clj'">
      <xsl:text>clojure</xsl:text>
    </xsl:when>
    <!-- CMake -->
    <xsl:when test="$language = 'cmake'">
      <xsl:text>cmake</xsl:text>
    </xsl:when>
    <!-- CSS -->
    <xsl:when test="$language = 'css' or $language = 'css21'">
      <xsl:text>css</xsl:text>
    </xsl:when>
    <!-- D -->
    <xsl:when test="$language = 'd'">
      <xsl:text>d</xsl:text>
    </xsl:when>
    <!-- Diff -->
    <xsl:when test="$language = 'diff' or $language = 'patch'">
      <xsl:text>diff</xsl:text>
    </xsl:when>
    <!-- Django -->
    <xsl:when test="$language = 'django'">
      <xsl:text>django</xsl:text>
    </xsl:when>
    <!-- Dockerfile -->
    <xsl:when test="$language = 'dockerfile'">
      <xsl:text>dockerfile</xsl:text>
    </xsl:when>
    <!-- DOS -->
    <xsl:when test="$language = 'dos'">
      <xsl:text>dos</xsl:text>
    </xsl:when>
    <!-- Ducktype -->
    <xsl:when test="$language = 'ducktype'">
      <xsl:text>ducktype</xsl:text>
    </xsl:when>
    <!-- Embedded Ruby -->
    <xsl:when test="$language = 'erb'">
      <xsl:text>erb</xsl:text>
    </xsl:when>
    <!-- F# -->
    <xsl:when test="$language = 'fsharp'">
      <xsl:text>fsharp</xsl:text>
    </xsl:when>
    <!-- Go -->
    <xsl:when test="$language = 'go'">
      <xsl:text>go</xsl:text>
    </xsl:when>
    <!-- Haml -->
    <xsl:when test="$language = 'haml'">
      <xsl:text>haml</xsl:text>
    </xsl:when>
    <!-- Haskell -->
    <xsl:when test="$language = 'haskell' or $language = 'hs'">
      <xsl:text>hs</xsl:text>
    </xsl:when>
    <!-- HTML -->
    <xsl:when test="$language = 'html' or $language = 'xhtml'">
      <xsl:text>html</xsl:text>
    </xsl:when>
    <!-- HTTP -->
    <xsl:when test="$language = 'http'">
      <xsl:text>http</xsl:text>
    </xsl:when>
    <!-- INI -->
    <xsl:when test="$language = 'ini'">
      <xsl:text>ini</xsl:text>
    </xsl:when>
    <!-- Java -->
    <xsl:when test="$language = 'java'">
      <xsl:text>java</xsl:text>
    </xsl:when>
    <!-- Javascript -->
    <xsl:when test="$language = 'js' or $language = 'javascript'">
      <xsl:text>javascript</xsl:text>
    </xsl:when>
    <!-- JSON -->
    <xsl:when test="$language = 'json'">
      <xsl:text>json</xsl:text>
    </xsl:when>
    <!-- LISP -->
    <xsl:when test="$language = 'lisp' or $language = 'el' or
                    $language = 'cl' or $language = 'lsp'">
      <xsl:text>lisp</xsl:text>
    </xsl:when>
    <!-- Lua -->
    <xsl:when test="$language = 'lua'">
      <xsl:text>lua</xsl:text>
    </xsl:when>
    <!-- Makefile -->
    <xsl:when test="$language = 'makefile' or $language = 'make'">
      <xsl:text>makefile</xsl:text>
    </xsl:when>
    <!-- Markdown -->
    <xsl:when test="$language = 'markdown' or $language = 'md'">
      <xsl:text>markdown</xsl:text>
    </xsl:when>
    <!-- MATLAB/Octave -->
    <xsl:when test="$language = 'matlab' or $language = 'octave'">
      <xsl:text>matlab</xsl:text>
    </xsl:when>
    <!-- Nginx -->
    <xsl:when test="$language = 'nginx'">
      <xsl:text>nginx</xsl:text>
    </xsl:when>
    <!-- Objective C -->
    <xsl:when test="$language = 'objc' or $language = 'm'">
      <xsl:text>objectivec</xsl:text>
    </xsl:when>
    <!-- Perl -->
    <xsl:when test="$language = 'perl' or
                    $language = 'pl' or $language = 'pm'">
      <xsl:text>perl</xsl:text>
    </xsl:when>
    <!-- PHP -->
    <xsl:when test="$language = 'php'">
      <xsl:text>php</xsl:text>
    </xsl:when>
    <!-- Python -->
    <xsl:when test="$language = 'py' or $language = 'python'">
      <xsl:text>python</xsl:text>
    </xsl:when>
    <!-- R/S -->
    <xsl:when test="$language = 'r' or $language = 's'">
      <xsl:text>r</xsl:text>
    </xsl:when>
    <!-- Ruby -->
    <xsl:when test="$language = 'ruby' or $language = 'rb'">
      <xsl:text>ruby</xsl:text>
    </xsl:when>
    <!-- Rust -->
    <xsl:when test="$language = 'rust'">
      <xsl:text>rust</xsl:text>
    </xsl:when>
    <!-- Scala -->
    <xsl:when test="$language = 'scala'">
      <xsl:text>scala</xsl:text>
    </xsl:when>
    <!-- Scheme -->
    <xsl:when test="$language = 'scheme' or $language = 'scm'">
      <xsl:text>scheme</xsl:text>
    </xsl:when>
    <!-- Shell -->
    <xsl:when test="$language = 'shell'">
      <xsl:text>shell</xsl:text>
    </xsl:when>
    <!-- Smalltalk -->
    <xsl:when test="$language = 'smalltalk'">
      <xsl:text>smalltalk</xsl:text>
    </xsl:when>
    <!-- SML -->
    <xsl:when test="$language = 'sml'">
      <xsl:text>sml</xsl:text>
    </xsl:when>
    <!-- SQL -->
    <xsl:when test="$language = 'sql' or $language = 'sql92' or
                    $language = 'sql1999' or $language = 'sql2003'">
      <xsl:text>sql</xsl:text>
    </xsl:when>
    <!-- TCL -->
    <xsl:when test="$language = 'tcl'">
      <xsl:text>tcl</xsl:text>
    </xsl:when>
    <!-- TeX -->
    <xsl:when test="$language = 'tex' or $language = 'latex'">
      <xsl:text>latex</xsl:text>
    </xsl:when>
    <!-- Vala -->
    <xsl:when test="$language = 'vala'">
      <xsl:text>vala</xsl:text>
    </xsl:when>
    <!-- XML -->
    <xsl:when test="$language = 'xml' or $language = 'myxml'">
      <xsl:text>xml</xsl:text>
    </xsl:when>
    <!-- XQuery -->
    <xsl:when test="$language = 'xq' or $language = 'xquery'">
      <xsl:text>xquery</xsl:text>
    </xsl:when>
    <!-- YAML -->
    <xsl:when test="$language = 'yaml'">
      <xsl:text>yaml</xsl:text>
    </xsl:when>
  </xsl:choose>
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
      <xsl:if test="$style = 'figure'">
        <a href="#" class="figure-zoom">
          <xsl:attribute name="data-zoom-in-title">
            <xsl:call-template name="l10n.gettext">
              <xsl:with-param name="msgid" select="'View images at normal size'"/>
            </xsl:call-template>
          </xsl:attribute>
          <xsl:attribute name="data-zoom-out-title">
            <xsl:call-template name="l10n.gettext">
              <xsl:with-param name="msgid" select="'Scale images down'"/>
            </xsl:call-template>
          </xsl:attribute>
          <xsl:call-template name="icons.svg.figure.zoom.in"/>
          <xsl:call-template name="icons.svg.figure.zoom.out"/>
        </a>
      </xsl:if>
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
  <xsl:variable name="notetitle">
    <xsl:choose>
      <xsl:when test="$type = 'attention' or $type = 'important' or
                      $type = 'remember' or $type = 'restriction'">
        <xsl:text>Important</xsl:text>
      </xsl:when>
      <xsl:when test="$type = 'caution' or $type = 'notice'">
        <xsl:text>Caution</xsl:text>
      </xsl:when>
      <xsl:when test="$type = 'danger'">
        <xsl:text>Danger</xsl:text>
      </xsl:when>
      <xsl:when test="$type = 'warning'">
        <xsl:text>Warning</xsl:text>
      </xsl:when>
      <xsl:when test="$type = 'fastpath' or $type = 'tip'">
        <xsl:text>Tip</xsl:text>
      </xsl:when>
      <xsl:otherwise>
        <xsl:text>Note</xsl:text>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:variable>
  <xsl:variable name="notetype">
    <xsl:value-of select="translate($notetitle,
                          'ABCDEFGHIJKLMNOPQRSTUVWXYZ',
                          'abcdefghijklmnopqrstuvwxyz')"/>
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
    <xsl:attribute name="title">
      <xsl:call-template name="l10n.gettext">
        <xsl:with-param name="msgid" select="$notetitle"/>
      </xsl:call-template>
    </xsl:attribute>
    <xsl:call-template name="icons.svg.note">
      <xsl:with-param name="style" select="$notetype"/>
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
      <div class="contents">
        <xsl:apply-templates mode="dita2html.topic.mode" select="$conref/node()[not(self::&topic_title_all;)]"/>
      </div>
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
