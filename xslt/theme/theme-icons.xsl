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
                version="1.0">

<!--!!==========================================================================
Theme Icons
:Requires: gettext

This module provides a common interface to specify icons for transformations
to presentation-oreinted formats.  This allows similar output for different
types of input documents.

Icons are divided into two groups: emblems and watermarks.  Emblems are placed
next to text content, and are generally smaller and more colorful.  Watermarks
may be used as a background, and are generally larger and without color.
-->

<!--@@==========================================================================
theme.icons.base_url
The default URL prefix for all icons.
:Revision:version="1.0" date="2010-01-26"

This parameter provides a default URL prefix.  All icon locations in this
stylesheet reference files directly under this URL prefix by default.  If
you override the individual icon parameters in this stylesheet, this parameter
has no effect.  This parameter should end with a trailing slash.
-->
<xsl:param name="theme.icons.base_url" select="''"/>


<!--@@==========================================================================
theme.icons.emblem.size
The size of the emblem icons.
:Revision:version="1.0" date="2010-01-26"

This parameter specifies the size of the emblem icons.  Use an integer giving
the width of the image files in pixels.  Icons are assumed to be square, and all
emblem icons are assumed to have the same size.
-->
<xsl:param name="theme.icons.emblem.size" select="24"/>


<!--@@==========================================================================
theme.icons.watermark.size
The size of the emblem icons.
:Revision:version="1.0" date="2010-01-26"

This parameter specifies the size of the watermark icons.  Use an integer giving
the width of the image files in pixels.  Icons are assumed to be square, and all
watermark icons are assumed to have the same size.
-->
<xsl:param name="theme.icons.watermark.size" select="72"/>


<!--@@==========================================================================
theme.icons.emblem.note
The URL for the note emblem.
:Revision:version="1.0" date="2010-01-26"

This parameter specifies the URL for emblem icon used for regular notes.
-->
<xsl:param name="theme.icons.emblem.note"
           select="concat($theme.icons.base_url, 'yelp-note.png')"/>


<!--@@==========================================================================
theme.icons.emblem.note.bug
The URL for the bug note emblem.
:Revision:version="1.0" date="2010-01-26"

This parameter specifies the URL for emblem icon used for bug notes.
-->
<xsl:param name="theme.icons.emblem.note.bug"
           select="concat($theme.icons.base_url, 'yelp-note-bug.png')"/>


<!--@@==========================================================================
theme.icons.emblem.note.important
The URL for the important note emblem.
:Revision:version="1.0" date="2010-01-26"

This parameter specifies the URL for emblem icon used for important notes.
-->
<xsl:param name="theme.icons.emblem.note.important"
           select="concat($theme.icons.base_url, 'yelp-note-important.png')"/>


<!--@@==========================================================================
theme.icons.emblem.note.tip
The URL for the tip note emblem.
:Revision:version="1.0" date="2010-01-26"

This parameter specifies the URL for emblem icon used for tip notes.
-->
<xsl:param name="theme.icons.emblem.note.tip"
           select="concat($theme.icons.base_url, 'yelp-note-tip.png')"/>


<!--@@==========================================================================
theme.icons.emblem.note.warning
The URL for the warning note emblem.
:Revision:version="1.0" date="2010-01-26"

This parameter specifies the URL for emblem icon used for warning notes.
-->
<xsl:param name="theme.icons.emblem.note.warning"
           select="concat($theme.icons.base_url, 'yelp-note-warning.png')"/>


<!--@@==========================================================================
theme.icons.watermark.quote
The URL for the block quote watermark.
:Revision:version="1.0" date="2010-01-26"

This parameter specifies the URL for the watermark for block quotes.  The
default name of the image file is translatable.  If you set this parameter,
you should ensure that your graphic uses a suitable quote character for the
language your document is written in.
-->
<xsl:param name="theme.icons.watermark.quote">
  <xsl:value-of select="$theme.icons.base_url"/>
  <xsl:call-template name="l10n.gettext">
    <xsl:with-param name="msgid" select="'yelp-watermark-quote-201C.png'"/>
  </xsl:call-template>
</xsl:param>


<!--@@==========================================================================
theme.icons.watermark.code
The URL for the block code watermark.
:Revision:version="1.0" date="2010-01-26"

This parameter specifies the URL for the watermark for block code.
-->
<xsl:param name="theme.icons.watermark.code">
  <xsl:value-of select="$theme.icons.base_url"/>
  <xsl:text>yelp-watermark-code.png</xsl:text>
</xsl:param>

</xsl:stylesheet>
