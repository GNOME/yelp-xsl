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
                xmlns:svg="http://www.w3.org/2000/svg"
                version="1.0">

<!--!!==========================================================================
Icons
Specify common named icons to style output.
:Revision:version="3.28" date="2017-05-24" status="final"

This stylesheet provides a common interface to specify icons for transformations
to presentation-oreinted formats. This allows similar output for different
types of input documents.

Many of the icons are output as SVG elements that can be embedded directly
into an HTML document. These icons use class names like #{yelp-svg-fill} and
#{yelp-svg-stroke}, allowing you to style them with colors from the !{colors}
module.

Some SVG icons are read from separate source SVG files. When this is done, the
%{icons.svg.mode} mode is applied to reduce the SVG to the minimal form needed
for proper presentation.
-->


<!--%%==========================================================================
icons.svg.mode
Reduce SVG icons to elements needed for presentation.
:Revision:version="3.28" date="2017-05-24" status="final"

This mode matches SVG elements and outputs only the SVG needed for presentation.
It strips out metadata and other elements and attributes used primarily by
authoring tools. It also uses the @{html.svg.namespace} parameter to output SVG
with or without namespace information, compatible with the dual HTML/XHTML
output of these stylesheets.
-->
<xsl:template mode="icons.svg.mode" match="svg:title"/>
<xsl:template mode="icons.svg.mode" match="svg:metadata"/>
<xsl:template mode="icons.svg.mode" match="svg:*">
  <xsl:element name="{local-name(.)}" namespace="{$html.svg.namespace}">
    <xsl:for-each select="@*">
      <xsl:choose>
        <xsl:when test="local-name(.) = 'id'"/>
        <xsl:when test="namespace-uri(.) = 'http://www.inkscape.org/namespaces/inkscape'"/>
        <xsl:when test="namespace-uri(.) = 'http://sodipodi.sourceforge.net/DTD/sodipodi-0.dtd'"/>
        <xsl:otherwise>
          <xsl:copy-of select="."/>
        </xsl:otherwise>
      </xsl:choose>
    </xsl:for-each>
    <xsl:apply-templates mode="icons.svg.mode" select="node()"/>
  </xsl:element>
</xsl:template>
<xsl:template mode="icons.svg.mode" match="text()">
  <xsl:copy-of select="."/>
</xsl:template>
<xsl:template mode="icons.svg.mode" match="*"/>


<!--**==========================================================================
icons.svg.note
Output an #{svg} element for a note icon.
:Revision:version="3.28" date="2017-05-24" status="final"
$style: The style of the note.

This template outputs an SVG #{svg} element with an icon suitable for notes
and other types of admonitions. It takes a ${style} parameter specifying a
note style. The default style is #{"note"}. This template uses the ${style}
parameter to determine which specific template to call to output the SVG
content.

SVG icons can use CSS class names to pick up colors from the !{colors} module.
-->
<xsl:template name="icons.svg.note">
  <xsl:param name="style"/>
  <xsl:choose>
    <xsl:when test="$style = 'advanced'">
      <xsl:call-template name="icons.svg.note.advanced"/>
    </xsl:when>
    <xsl:when test="$style = 'bug'">
      <xsl:call-template name="icons.svg.note.bug"/>
    </xsl:when>
    <xsl:when test="$style = 'caution'">
      <xsl:call-template name="icons.svg.note.caution"/>
    </xsl:when>
    <xsl:when test="$style = 'danger'">
      <xsl:call-template name="icons.svg.note.danger"/>
    </xsl:when>
    <xsl:when test="$style = 'important'">
      <xsl:call-template name="icons.svg.note.important"/>
    </xsl:when>
    <xsl:when test="$style = 'package'">
      <xsl:call-template name="icons.svg.note.package"/>
    </xsl:when>
    <xsl:when test="$style = 'tip'">
      <xsl:call-template name="icons.svg.note.tip"/>
    </xsl:when>
    <xsl:when test="$style = 'warning'">
      <xsl:call-template name="icons.svg.note.warning"/>
    </xsl:when>
    <xsl:otherwise test="$style = 'note'">
      <xsl:call-template name="icons.svg.note.note"/>
    </xsl:otherwise>
  </xsl:choose>
</xsl:template>


<!--**==========================================================================
icons.svg.note.advanced
Output an #{svg} element for an advanced note icon.
:Revision:version="3.28" date="2017-05-24" status="final"

This template outputs an SVG #{svg} element with an icon suitable for notes
with advanced information.

SVG icons can use CSS class names to pick up colors from the !{colors} module.
By default, this icon uses the #{yelp-svg-fill} class name.
-->
<xsl:template name="icons.svg.note.advanced">
  <xsl:apply-templates mode="icons.svg.mode"
                       select="document('icons/yelp-note-advanced.svg')"/>
</xsl:template>


<!--**==========================================================================
icons.svg.note.bug
Output an #{svg} element for a bug note icon.
:Revision:version="3.28" date="2017-05-24" status="final"

This template outputs an SVG #{svg} element with an icon suitable for notes
about known bugs.

SVG icons can use CSS class names to pick up colors from the !{colors} module.
By default, this icon uses the #{yelp-svg-fill} class name.
-->
<xsl:template name="icons.svg.note.bug">
  <xsl:apply-templates mode="icons.svg.mode"
                       select="document('icons/yelp-note-bug.svg')"/>
</xsl:template>


<!--**==========================================================================
icons.svg.note.caution
Output an #{svg} element for a caution note icon.
:Revision:version="3.28" date="2017-05-24" status="final"

This template outputs an SVG #{svg} element with an icon suitable for notes
with cautionary information.

SVG icons can use CSS class names to pick up colors from the !{colors} module.
By default, this icon uses the #{yelp-svg-fill} class name.
-->
<xsl:template name="icons.svg.note.caution">
  <xsl:apply-templates mode="icons.svg.mode"
                       select="document('icons/yelp-note-warning.svg')"/>
</xsl:template>


<!--**==========================================================================
icons.svg.note.danger
Output an #{svg} element for a danger note icon.
:Revision:version="3.28" date="2017-05-24" status="final"

This template outputs an SVG #{svg} element with an icon suitable for notes
about dangerous situations.

SVG icons can use CSS class names to pick up colors from the !{colors} module.
By default, this icon uses the #{yelp-svg-fill} class name.
-->
<xsl:template name="icons.svg.note.danger">
  <xsl:apply-templates mode="icons.svg.mode"
                       select="document('icons/yelp-note-warning.svg')"/>
</xsl:template>


<!--**==========================================================================
icons.svg.note.important
Output an #{svg} element for an important note icon.
:Revision:version="3.28" date="2017-05-24" status="final"

This template outputs an SVG #{svg} element with an icon suitable for notes
with important information.

SVG icons can use CSS class names to pick up colors from the !{colors} module.
By default, this icon uses the #{yelp-svg-fill} class name.
-->
<xsl:template name="icons.svg.note.important">
  <xsl:apply-templates mode="icons.svg.mode"
                       select="document('icons/yelp-note-important.svg')"/>
</xsl:template>


<!--**==========================================================================
icons.svg.note.note
Output an #{svg} element for a note icon.
:Revision:version="3.28" date="2017-05-24" status="final"

This template outputs an SVG #{svg} element with an icon suitable for notes
with general information.

SVG icons can use CSS class names to pick up colors from the !{colors} module.
By default, this icon uses the #{yelp-svg-fill} class name.
-->
<xsl:template name="icons.svg.note.note">
  <xsl:apply-templates mode="icons.svg.mode"
                       select="document('icons/yelp-note-note.svg')"/>
</xsl:template>


<!--**==========================================================================
icons.svg.note.package
Output an #{svg} element for a package note icon.
:Revision:version="3.28" date="2017-05-24" status="final"

This template outputs an SVG #{svg} element with an icon suitable for notes
about packages the user may need to install.

SVG icons can use CSS class names to pick up colors from the !{colors} module.
By default, this icon uses the #{yelp-svg-fill} class name.
-->
<xsl:template name="icons.svg.note.package">
  <xsl:apply-templates mode="icons.svg.mode"
                       select="document('icons/yelp-note-package.svg')"/>
</xsl:template>


<!--**==========================================================================
icons.svg.note.tip
Output an #{svg} element for a tip note icon.
:Revision:version="3.28" date="2017-05-24" status="final"

This template outputs an SVG #{svg} element with an icon suitable for notes
with tips.

SVG icons can use CSS class names to pick up colors from the !{colors} module.
By default, this icon uses the #{yelp-svg-fill} class name.
-->
<xsl:template name="icons.svg.note.tip">
  <xsl:apply-templates mode="icons.svg.mode"
                       select="document('icons/yelp-note-tip.svg')"/>
</xsl:template>


<!--**==========================================================================
icons.svg.note.warning
Output an #{svg} element for a warning note icon.
:Revision:version="3.28" date="2017-05-24" status="final"

This template outputs an SVG #{svg} element with an icon suitable for notes
with warnings.

SVG icons can use CSS class names to pick up colors from the !{colors} module.
By default, this icon uses the #{yelp-svg-fill} class name.
-->
<xsl:template name="icons.svg.note.warning">
  <xsl:apply-templates mode="icons.svg.mode"
                       select="document('icons/yelp-note-warning.svg')"/>
</xsl:template>


<!--@@==========================================================================
icons.size.quote
The size of the quote icons.
:Revision:version="3.8" date="2012-09-29" status="final"

This parameter specifies the size of the block quote icon. Use an integer giving
the width of the image files in pixels. Icons are assumed to be square, and all
quote icons are assumed to have the same size.

As of version 3.8, there is no longer an actual image file for the quote icon.
Instead, a language-appropriate quotation character is placed in the margin.
This parameters still affects the size of that character.
-->
<xsl:param name="icons.size.quote" select="48"/>




<!--**==========================================================================
icons.svg.figure.zoom.in
Output an #{svg} element for a figure zoom-in icon.
:Revision: version="3.28" date="2017-05-24" status="final"

This template outputs an SVG #{svg} element with the zoom-in icon for figures.
Figures automatically scale images down. This icon shows them at their original
size.

SVG icons can use CSS class names to pick up colors from the !{colors} module.
By default, this icon uses the #{yelp-svg-stroke} and #{yelp-svg-fill} class
names.
-->
<xsl:template name="icons.svg.figure.zoom.in">
  <svg:svg width="10" height="10" class="figure-zoom-in">
    <svg:rect x="0.5" y="0.5" width="9" height="9"
              class="yelp-svg-stroke" stroke-width="1" fill="none"/>
    <svg:rect x="0" y="5" width="5" height="5"
              class="yelp-svg-fill"/>
  </svg:svg>
</xsl:template>


<!--**==========================================================================
icons.svg.figure.zoom.out
Output an #{svg} element for a figure zoom-out icon.
:Revision: version="3.28" date="2017-05-24" status="final"

This template outputs an SVG #{svg} element with the zoom-in icon for figures.
Figures automatically scale images down. This icon scales them back down after
they have been zoomed.

SVG icons can use CSS class names to pick up colors from the !{colors} module.
By default, this icon uses the #{yelp-svg-stroke} and #{yelp-svg-fill} class
names.
-->
<xsl:template name="icons.svg.figure.zoom.out">
  <svg:svg width="10" height="10" class="figure-zoom-out">
    <svg:rect x="0.5" y="0.5" width="9" height="9"
              class="yelp-svg-stroke" stroke-width="1" fill="none"/>
    <svg:polygon points="0,0 10,0 10,10 5,10 5,5 10,5 0,5"
                 class="yelp-svg-fill"/>
  </svg:svg>
</xsl:template>


<!--**==========================================================================
icons.svg.media.play
Output an #{svg} element for a figure zoom-out icon.
:Revision: version="3.28" date="2017-05-24" status="final"

This template outputs an SVG #{svg} element with a play icon for media controls.

SVG icons can use CSS class names to pick up colors from the !{colors} module.
By default, this icon uses the #{yelp-svg-fill} class name.
-->
<xsl:template name="icons.svg.media.play">
  <svg:svg width="20" height="20" class="media-play">
    <svg:polygon points="5,4 5,16 15,10" class="yelp-svg-fill"/>
  </svg:svg>
</xsl:template>


<!--**==========================================================================
icons.svg.media.pause
Output an #{svg} element for a figure zoom-out icon.
:Revision: version="3.28" date="2017-05-24" status="final"

This template outputs an SVG #{svg} element with a pause icon for media controls.

SVG icons can use CSS class names to pick up colors from the !{colors} module.
By default, this icon uses the #{yelp-svg-fill} class name.
-->
<xsl:template name="icons.svg.media.pause">
  <svg:svg width="20" height="20" class="media-pause">
    <svg:rect x="4" y="4" width="4" height="12" class="yelp-svg-fill"/>
    <svg:rect x="12" y="4" width="4" height="12" class="yelp-svg-fill"/>
  </svg:svg>
</xsl:template>

</xsl:stylesheet>
