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
:Revision:version="1.0" date="2010-05-25" status="final"

This stylesheet provides a common interface to specify icons for transformations
to presentation-oreinted formats. This allows similar output for different
types of input documents.
-->


<!--@@==========================================================================
icons.base_url
The default URL prefix for all icons.
:Revision:version="1.0" date="2010-01-26" status="final"

This parameter provides a default URL prefix. All icon locations in this
stylesheet reference files directly under this URL prefix by default. If
you override the individual icon parameters in this stylesheet, this parameter
has no effect. This parameter should end with a trailing slash.
-->
<xsl:param name="icons.base_url" select="''"/>


<!--@@==========================================================================
icons.size.note
The size of the note icons.
:Revision:version="1.0" date="2010-03-05" status="final"

This parameter specifies the size of the note icons. Use an integer giving
the width of the image files in pixels. Icons are assumed to be square, and
all note icons are assumed to have the same size.
-->
<xsl:param name="icons.size.note" select="24"/>


<!--@@==========================================================================
icons.note
The URL for the note icon.
:Revision:version="1.0" date="2010-05-03" status="final"

This parameter specifies the URL for the icon used for regular notes.
-->
<xsl:param name="icons.note"
           select="concat($icons.base_url, 'yelp-note.png')"/>


<!--@@==========================================================================
icons.note.bug
The URL for the bug note icon.
:Revision:version="1.0" date="2010-05-03" status="final"

This parameter specifies the URL for the icon used for bug notes.
-->
<xsl:param name="icons.note.bug"
           select="concat($icons.base_url, 'yelp-note-bug.png')"/>


<!--@@==========================================================================
icons.note.important
The URL for the important note icon.
:Revision:version="1.0" date="2010-05-03" status="final"

This parameter specifies the URL for the icon used for important notes.
-->
<xsl:param name="icons.note.important"
           select="concat($icons.base_url, 'yelp-note-important.png')"/>


<!--@@==========================================================================
icons.note.tip
The URL for the tip note icon.
:Revision:version="1.0" date="2010-05-03" status="final"

This parameter specifies the URL for the icon used for tip notes.
-->
<xsl:param name="icons.note.tip"
           select="concat($icons.base_url, 'yelp-note-tip.png')"/>


<!--@@==========================================================================
icons.note.warning
The URL for the warning note icon.
:Revision:version="1.0" date="2010-05-03" status="final"

This parameter specifies the URL for the icon used for warning notes.
-->
<xsl:param name="icons.note.warning"
           select="concat($icons.base_url, 'yelp-note-warning.png')"/>


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
:Revision: version="3.22" date="2016-02-11" status="final"

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
:Revision: version="3.22" date="2016-02-11" status="final"

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
:Revision: version="3.22" date="2016-02-12" status="final"

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
:Revision: version="3.22" date="2016-02-12" status="final"

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
