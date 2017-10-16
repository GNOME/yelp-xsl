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
                xmlns:math="http://exslt.org/math"
                exclude-result-prefixes="math"
                version="1.0">

<!--!!==========================================================================
Colors
Common named colors and color utilities for output styling.
:Revision:version="3.28" date="2016-01-03" status="final"

This stylesheet provides a common interface to specify custom colors for
transformations to presentation-oreinted formats.  This allows similar
output for different types of input documents.

This stylesheet also provides a number of templates for manipulating colors
and extracting information about colors.
-->


<!--**==========================================================================
color.hex2dec
Convert a hexidecimal number to decimal.
:Revision: version="3.28" date="2016-01-03" status="final"
$hex: The hexidecimal number to convert to decimal.

This template converts a hexidecimal number to decimal. It's useful for getting
the numeric values of color components in a hexidecimal color code.
-->
<xsl:template name="color.hex2dec">
  <xsl:param name="hex"/>
  <xsl:variable name="char" select="substring($hex, string-length($hex))"/>
  <xsl:variable name="dec">
    <xsl:choose>
      <xsl:when test="$char = 'a' or $char = 'A'">10</xsl:when>
      <xsl:when test="$char = 'b' or $char = 'B'">11</xsl:when>
      <xsl:when test="$char = 'c' or $char = 'C'">12</xsl:when>
      <xsl:when test="$char = 'd' or $char = 'D'">13</xsl:when>
      <xsl:when test="$char = 'e' or $char = 'E'">14</xsl:when>
      <xsl:when test="$char = 'f' or $char = 'F'">15</xsl:when>
      <xsl:otherwise><xsl:value-of select="$char"/></xsl:otherwise>
    </xsl:choose>
  </xsl:variable>
  <xsl:choose>
    <xsl:when test="string-length($hex) = 1">
      <xsl:value-of select="number($dec)"/>
    </xsl:when>
    <xsl:otherwise>
      <xsl:variable name="tens">
        <xsl:call-template name="color.hex2dec">
          <xsl:with-param name="hex" select="substring($hex, 1, string-length($hex) - 1)"/>
        </xsl:call-template>
      </xsl:variable>
      <xsl:value-of select="$dec + 16 * $tens"/>
    </xsl:otherwise>
  </xsl:choose>
</xsl:template>


<!--**==========================================================================
color.r
Extract the red component of a color.
:Revision: version="3.28" date="2016-01-03" status="final"
$color: A color specified in hexidecimal, #{rgb()}, or #{rgba()}.

This template extracts the red portion of a color, returning a number between
0 and 255. It accepts six-digit and three-digit hexidecimal color codes,
colors specified with #{rgb()}, and colors specified with #{rgba()}. It does
not accept HSL or named HTML colors.
-->
<xsl:template name="color.r">
  <xsl:param name="color"/>
  <xsl:choose>
    <xsl:when test="starts-with($color, '#') and string-length($color) = 7">
      <xsl:call-template name="color.hex2dec">
        <xsl:with-param name="hex" select="substring($color, 2, 2)"/>
      </xsl:call-template>
    </xsl:when>
    <xsl:when test="starts-with($color, '#') and string-length($color) = 4">
      <xsl:call-template name="color.hex2dec">
        <xsl:with-param name="hex" select="concat(substring($color, 2, 1), substring($color, 2, 1))"/>
      </xsl:call-template>
    </xsl:when>
    <xsl:when test="starts-with($color, 'rgb(') or starts-with($color, 'rgba(')">
      <xsl:value-of select="substring-before(substring-after($color, '('), ',')"/>
    </xsl:when>
  </xsl:choose>
</xsl:template>


<!--**==========================================================================
color.g
Extract the green component of a color.
:Revision: version="3.28" date="2016-01-03" status="final"
$color: A color specified in hexidecimal, #{rgb()}, or #{rgba()}.

This template extracts the green portion of a color, returning a number between
0 and 255. It accepts six-digit and three-digit hexidecimal color codes,
colors specified with #{rgb()}, and colors specified with #{rgba()}. It does
not accept HSL or named HTML colors.
-->
<xsl:template name="color.g">
  <xsl:param name="color"/>
  <xsl:choose>
    <xsl:when test="starts-with($color, '#') and string-length($color) = 7">
      <xsl:call-template name="color.hex2dec">
        <xsl:with-param name="hex" select="substring($color, 4, 2)"/>
      </xsl:call-template>
    </xsl:when>
    <xsl:when test="starts-with($color, '#') and string-length($color) = 4">
      <xsl:call-template name="color.hex2dec">
        <xsl:with-param name="hex" select="concat(substring($color, 3, 1), substring($color, 3, 1))"/>
      </xsl:call-template>
    </xsl:when>
    <xsl:when test="starts-with($color, 'rgb(') or starts-with($color, 'rgba(')">
      <xsl:value-of select="substring-before(substring-after($color, ','), ',')"/>
    </xsl:when>
  </xsl:choose>
</xsl:template>


<!--**==========================================================================
color.b
Extract the blue component of a color.
:Revision: version="3.28" date="2016-01-03" status="final"
$color: A color specified in hexidecimal, #{rgb()}, or #{rgba()}.

This template extracts the blue portion of a color, returning a number between
0 and 255. It accepts six-digit and three-digit hexidecimal color codes,
colors specified with #{rgb()}, and colors specified with #{rgba()}. It does
not accept HSL or named HTML colors.
-->
<xsl:template name="color.b">
  <xsl:param name="color"/>
  <xsl:choose>
    <xsl:when test="starts-with($color, '#') and string-length($color) = 7">
      <xsl:call-template name="color.hex2dec">
        <xsl:with-param name="hex" select="substring($color, 6, 2)"/>
      </xsl:call-template>
    </xsl:when>
    <xsl:when test="starts-with($color, '#') and string-length($color) = 4">
      <xsl:call-template name="color.hex2dec">
        <xsl:with-param name="hex" select="concat(substring($color, 4, 1), substring($color, 4, 1))"/>
      </xsl:call-template>
    </xsl:when>
    <xsl:when test="starts-with($color, 'rgb(')">
      <xsl:value-of select="substring-before(
                              substring-after(substring-after($color, ','), ','),
                              ')')"/>
    </xsl:when>
    <xsl:when test="starts-with($color, 'rgba(')">
      <xsl:value-of select="substring-before(
                              substring-after(substring-after($color, ','), ','),
                              ',')"/>
    </xsl:when>
  </xsl:choose>
</xsl:template>


<!--**==========================================================================
color.a
Extract the alpha value of a color.
:Revision: version="3.28" date="2016-01-03" status="final"
$color: A color specified in hexidecimal, #{rgb()}, or #{rgba()}.

This template extracts the alpha, or opacity level, of a color. It returns a
number between 0.0 and 1.0. It accepts six-digit and three-digit hexidecimal
color codes, colors specified with #{rgb()}, and colors specified with
#{rgba()}. It does not accept HSL or named HTML colors. For colors specified
with anything other than #{rgba()}, it always returns 1.0.
-->
<xsl:template name="color.a">
  <xsl:param name="color"/>
  <xsl:choose>
    <xsl:when test="starts-with($color, 'rgba(')">
      <xsl:value-of select="number(substring-before(substring-after(
                            substring-after(substring-after($color, ','), ','), ','), ')'))"/>
    </xsl:when>
    <xsl:otherwise>
      <xsl:text>1.0</xsl:text>
    </xsl:otherwise>
  </xsl:choose>
</xsl:template>


<!--**==========================================================================
color.rl
Get the relative luminance of a color.
:Revision: version="3.28" date="2016-01-03" status="final"
$color: A color specified in hexidecimal, #{rgb()}, or #{rgba()}.

This template calculates the relative luminance of a color, returning a number
between 0.0 and 1.0. The relative luminance is used when calculating color
contrast. The relative luminance algorithm is defined by the WCAG:

http://www.w3.org/TR/2008/REC-WCAG20-20081211/#relativeluminancedef

This template accepts six-digit and three-digit hexidecimal color codes, colors
specified with #{rgb()}, and colors specified with #{rgba()}. It does not accept
HSL or named HTML colors.
-->
<xsl:template name="color.rl">
  <xsl:param name="color"/>
  <xsl:variable name="r">
    <xsl:variable name="rsrgb_">
      <xsl:call-template name="color.r">
        <xsl:with-param name="color" select="$color"/>
      </xsl:call-template>
    </xsl:variable>
    <xsl:variable name="rsrgb" select="$rsrgb_ div 255"/>
    <xsl:choose>
      <xsl:when test="$rsrgb &gt; 0.03928">
        <xsl:value-of select="math:power(($rsrgb + 0.055) div 1.055, 2.4)"/>
      </xsl:when>
      <xsl:otherwise>
        <xsl:value-of select="$rsrgb div 12.92"/>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:variable>
  <xsl:variable name="g">
    <xsl:variable name="gsrgb_">
      <xsl:call-template name="color.g">
        <xsl:with-param name="color" select="$color"/>
      </xsl:call-template>
    </xsl:variable>
    <xsl:variable name="gsrgb" select="$gsrgb_ div 255"/>
    <xsl:choose>
      <xsl:when test="$gsrgb &gt; 0.03928">
        <xsl:value-of select="math:power(($gsrgb + 0.055) div 1.055, 2.4)"/>
      </xsl:when>
      <xsl:otherwise>
        <xsl:value-of select="$gsrgb div 12.92"/>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:variable> 
  <xsl:variable name="b">
    <xsl:variable name="bsrgb_">
      <xsl:call-template name="color.b">
        <xsl:with-param name="color" select="$color"/>
      </xsl:call-template>
    </xsl:variable>
    <xsl:variable name="bsrgb" select="$bsrgb_ div 255"/>
    <xsl:choose>
      <xsl:when test="$bsrgb &gt; 0.03928">
        <xsl:value-of select="math:power(($bsrgb + 0.055) div 1.055, 2.4)"/>
      </xsl:when>
      <xsl:otherwise>
        <xsl:value-of select="$bsrgb div 12.92"/>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:variable> 
  <xsl:value-of select="(0.2126 * $r) + (0.0722 * $b) + (0.7152 * $g)"/>
</xsl:template>


<!--**==========================================================================
color.contrast
Get the contrast between two colors.
:Revision: version="3.28" date="2016-01-03" status="final"
$bg: A color specified in hexidecimal, #{rgb()}, or #{rgba()}.
$fg: A color specified in hexidecimal, #{rgb()}, or #{rgba()}.

This template calculates the contrast ratio between colors. The contrast ratio
is a number between 1 and 21. The algorithm is defined by the WCAG:

http://www.w3.org/TR/2008/REC-WCAG20-20081211/#contrast-ratiodef

This template calls *{color.rl} to get the relative luminance of ${bg} and ${fg}.
It accepts six-digit and three-digit hexidecimal color codes, colors specified
with #{rgb()}, and colors specified with #{rgba()}. It does not accept HSL or
named HTML colors. Note that it does not take the alpha value into account when
calculating the contrast ratio. Semi-transparent colors will have a lower
actual contrast ratio than what is reported by this template.

The WCAG recommends a contrast ratio of at least 4.5 for normal text, and a
ratio of at least 3.0 for large-scale text.
-->
<xsl:template name="color.contrast">
  <xsl:param name="bg"/>
  <xsl:param name="fg"/>
  <xsl:variable name="bg.rl">
    <xsl:call-template name="color.rl">
      <xsl:with-param name="color" select="$bg"/>
    </xsl:call-template>
  </xsl:variable>
  <xsl:variable name="fg.rl">
    <xsl:call-template name="color.rl">
      <xsl:with-param name="color" select="$fg"/>
    </xsl:call-template>
  </xsl:variable>
  <xsl:choose>
    <xsl:when test="$bg.rl > $fg.rl">
      <xsl:value-of select="round(100 * (($bg.rl + 0.05) div ($fg.rl + 0.05))) div 100"/>
    </xsl:when>
    <xsl:otherwise>
      <xsl:value-of select="round(100 * (($fg.rl + 0.05) div ($bg.rl + 0.05))) div 100"/>
    </xsl:otherwise>
  </xsl:choose>
</xsl:template>


<!--**==========================================================================
color.blend
Blend two colors together at a specified mix level.
:Revision: version="3.28" date="2016-01-03" status="final"
$bg: A color specified in hexidecimal, #{rgb()}, or #{rgba()}.
$fg: A color specified in hexidecimal, #{rgb()}, or #{rgba()}.
$mix: The mix level, between 0.0 and 1.0.

This template calculates a color by selecting a midpoint between ${bg} and
${fg}, where the ${mix} parameter specifies how far to move from ${bg} to
${fg}. For opaque colors, setting ${mix} to 0.0 will result in ${bg}, and
setting ${mix} to 1.0 will result in ${fg}.

This template takes the alpha values of ${bg} and ${fg} into account, so
that specifying 1.0 for ${mix} will result in a color that is the result
of overlaying ${fg} on top of ${bg}. In effect, ${mix} acts as a multiplier
on the alpha channels of the colors.

This template calls *{color.r}, *{color.g}, *{color.b}, and *{color.a} to get
the components of ${bg} and ${fg}. It accepts six-digit and three-digit
hexidecimal color codes, colors specified with #{rgb()}, and colors specified
with #{rgba()}. It does not accept HSL or named HTML colors.

If the return color is fully opaque, this template returns the color using
the #{rgb()} scheme. Otherwise, it uses the #{rgba()} scheme.
-->
<xsl:template name="color.blend">
  <xsl:param name="bg" select="'#ffffff'"/>
  <xsl:param name="fg" select="'#000000'"/>
  <xsl:param name="mix" select="0.5"/>

  <xsl:variable name="fgr">
    <xsl:call-template name="color.r">
      <xsl:with-param name="color" select="$fg"/>
    </xsl:call-template>
  </xsl:variable>
  <xsl:variable name="fgb">
    <xsl:call-template name="color.b">
      <xsl:with-param name="color" select="$fg"/>
    </xsl:call-template>
  </xsl:variable>
  <xsl:variable name="fgg">
    <xsl:call-template name="color.g">
      <xsl:with-param name="color" select="$fg"/>
    </xsl:call-template>
  </xsl:variable>
  <xsl:variable name="fga">
    <xsl:call-template name="color.a">
      <xsl:with-param name="color" select="$fg"/>
    </xsl:call-template>
  </xsl:variable>
  <xsl:variable name="bgr">
    <xsl:call-template name="color.r">
      <xsl:with-param name="color" select="$bg"/>
    </xsl:call-template>
  </xsl:variable>
  <xsl:variable name="bgb">
    <xsl:call-template name="color.b">
      <xsl:with-param name="color" select="$bg"/>
    </xsl:call-template>
  </xsl:variable>
  <xsl:variable name="bgg">
    <xsl:call-template name="color.g">
      <xsl:with-param name="color" select="$bg"/>
    </xsl:call-template>
  </xsl:variable>
  <xsl:variable name="bga">
    <xsl:call-template name="color.a">
      <xsl:with-param name="color" select="$bg"/>
    </xsl:call-template>
  </xsl:variable>

  <xsl:variable name="a" select="($fga * $mix) + ($bga * (1 - $mix))"/>
  <xsl:variable name="r" select="(($bgr * $bga * (1 - $mix)) +
                                  ($fgr * $fga * $mix)) div $a"/>
  <xsl:variable name="g" select="(($bgg * $bga * (1 - $mix)) +
                                  ($fgg * $fga * $mix)) div $a"/>
  <xsl:variable name="b" select="(($bgb * $bga * (1 - $mix)) +
                                  ($fgb * $fga * $mix)) div $a"/>
  <xsl:variable name="rgba" select="$a &lt; 1"/>
  <xsl:choose>
    <xsl:when test="$rgba">
      <xsl:text>rgba(</xsl:text>
    </xsl:when>
    <xsl:otherwise>
      <xsl:text>rgb(</xsl:text>
    </xsl:otherwise>
  </xsl:choose>
  <xsl:choose>
    <xsl:when test="$r &lt; 0">
      <xsl:text>0</xsl:text>
    </xsl:when>
    <xsl:when test="$r &gt; 255">
      <xsl:text>255</xsl:text>
    </xsl:when>
    <xsl:otherwise>
      <xsl:value-of select="round($r)"/>
    </xsl:otherwise>
  </xsl:choose>
  <xsl:text>,</xsl:text>
  <xsl:choose>
    <xsl:when test="$g &lt; 0">
      <xsl:text>0</xsl:text>
    </xsl:when>
    <xsl:when test="$g &gt; 255">
      <xsl:text>255</xsl:text>
    </xsl:when>
    <xsl:otherwise>
      <xsl:value-of select="round($g)"/>
    </xsl:otherwise>
  </xsl:choose>
  <xsl:text>,</xsl:text>
  <xsl:choose>
    <xsl:when test="$b &lt; 0">
      <xsl:text>0</xsl:text>
    </xsl:when>
    <xsl:when test="$b &gt; 255">
      <xsl:text>255</xsl:text>
    </xsl:when>
    <xsl:otherwise>
      <xsl:value-of select="round($b)"/>
    </xsl:otherwise>
  </xsl:choose>
  <xsl:if test="$rgba">
    <xsl:text>,</xsl:text>
    <xsl:choose>
      <xsl:when test="$a &lt; 0">
        <xsl:text>0</xsl:text>
      </xsl:when>
      <xsl:when test="$a &gt; 1.0">
        <xsl:text>1.0</xsl:text>
      </xsl:when>
      <xsl:otherwise>
        <xsl:value-of select="$a"/>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:if>
  <xsl:text>)</xsl:text>
</xsl:template>


<!--#* _color.fgify -->
<xsl:template name="_color.fgify">
  <xsl:param name="color"/>
  <xsl:param name="target" select="5"/>
  <xsl:param name="recdepth" select="0"/>
  <xsl:variable name="newcolor">
    <xsl:call-template name="color.blend">
      <xsl:with-param name="bg" select="$color"/>
      <xsl:with-param name="fg" select="$color.fg"/>
      <xsl:with-param name="mix" select="0.1"/>
    </xsl:call-template>
  </xsl:variable>
  <xsl:variable name="contrast">
    <xsl:call-template name="color.contrast">
      <xsl:with-param name="bg" select="$color.bg"/>
      <xsl:with-param name="fg" select="$newcolor"/>
    </xsl:call-template>
  </xsl:variable>
  <xsl:choose>
    <xsl:when test="$recdepth > 10">
      <xsl:message>
        <xsl:text>Recursion depth exceeded calculating fg color</xsl:text>
      </xsl:message>
      <xsl:value-of select="$newcolor"/>
    </xsl:when>
    <xsl:when test="$contrast >= $target">
      <xsl:value-of select="$newcolor"/>
    </xsl:when>
    <xsl:otherwise>
      <xsl:call-template name="_color.fgify">
        <xsl:with-param name="color" select="$newcolor"/>
        <xsl:with-param name="target" select="$target"/>
        <xsl:with-param name="recdepth" select="$recdepth + 1"/>
      </xsl:call-template>
    </xsl:otherwise>
  </xsl:choose>
</xsl:template>


<!--#* _color.bgify -->
<xsl:template name="_color.bgify">
  <xsl:param name="color"/>
  <xsl:param name="target" select="19"/>
  <xsl:param name="recdepth" select="0"/>
  <xsl:variable name="newcolor">
    <xsl:call-template name="color.blend">
      <xsl:with-param name="bg" select="$color"/>
      <xsl:with-param name="fg" select="$color.bg"/>
      <xsl:with-param name="mix" select="0.2"/>
    </xsl:call-template>
  </xsl:variable>
  <xsl:variable name="contrast">
    <xsl:call-template name="color.contrast">
      <xsl:with-param name="bg" select="$newcolor"/>
      <xsl:with-param name="fg" select="$color.fg"/>
    </xsl:call-template>
  </xsl:variable>
  <xsl:choose>
    <xsl:when test="$recdepth > 20">
      <xsl:message>
        <xsl:text>Recursion depth exceeded calculating bg color</xsl:text>
      </xsl:message>
      <xsl:value-of select="$newcolor"/>
    </xsl:when>
    <xsl:when test="$contrast >= $target">
      <xsl:value-of select="$newcolor"/>
    </xsl:when>
    <xsl:otherwise>
      <xsl:call-template name="_color.bgify">
        <xsl:with-param name="color" select="$newcolor"/>
        <xsl:with-param name="target" select="$target"/>
        <xsl:with-param name="recdepth" select="$recdepth + 1"/>
      </xsl:call-template>
    </xsl:otherwise>
  </xsl:choose>
</xsl:template>



<!--@@==========================================================================
color.fg
The primary text color.
:Revision:version="3.28" date="2016-01-03" status="final"

This parameters specifies the normal color of text. It should have a high color
contrast against @{color.bg}. Other text colors can be automatically computed
based on this color.
-->
<xsl:param name="color.fg" select="'#000000'"/>


<!--@@==========================================================================
color.bg
The normal background color.
:Revision:version="3.28" date="2016-01-03" status="final"

This parameters specifies the background color. It should have a high color
contrast against @{color.fg}. Other background colors can be automatically
computed based on this color.
-->
<xsl:param name="color.bg" select="'#ffffff'"/>


<!--@@==========================================================================
color.red
A red accent color.
:Revision:version="3.28" date="2016-01-03" status="final"

This parameter specifies a shade of red that is suitable for borders and
other accents. It should have some contrast against background colors, but it
does not need as high of a contrast as text colors.
-->
<xsl:param name="color.red" select="'#cc0000'"/>


<!--@@==========================================================================
color.fg.red
A red text color.
:Revision:version="3.28" date="2016-01-03" status="final"

This parameter specifies a shade of red that is suitable for text. It should
have a high color contrast against @{color.bg}. If not specified, it can be
automatically computed based on @{color.red} and @{color.fg}.
-->
<xsl:param name="color.fg.red">
  <xsl:call-template name="_color.fgify">
    <xsl:with-param name="color" select="$color.red"/>
  </xsl:call-template>
</xsl:param>


<!--@@==========================================================================
color.bg.red
A red background color.
:Revision:version="3.28" date="2016-01-03" status="final"

This parameter specifies a shade of red that is suitable for backgrounds.
It should have a high color contrast against @{color.fg}. If not specified,
it can be automatically computed based on @{color.red} and @{color.bg}.
-->
<xsl:param name="color.bg.red">
  <xsl:call-template name="_color.bgify">
    <xsl:with-param name="color" select="$color.red"/>
  </xsl:call-template>
</xsl:param>


<!--@@==========================================================================
color.orange
An orange accent color.
:Revision:version="3.28" date="2016-01-03" status="final"

This parameter specifies a shade of orange that is suitable for borders and
other accents. It should have some contrast against background colors, but it
does not need as high of a contrast as text colors.
-->
<xsl:param name="color.orange" select="'#f57900'"/>


<!--@@==========================================================================
color.fg.orange
An orange text color.
:Revision:version="3.28" date="2016-01-03" status="final"

This parameter specifies a shade of orange that is suitable for text. It should
have a high color contrast against @{color.bg}. If not specified, it can be
automatically computed based on @{color.orange} and @{color.fg}.
-->
<xsl:param name="color.fg.orange">
  <xsl:call-template name="_color.fgify">
    <xsl:with-param name="color" select="$color.orange"/>
  </xsl:call-template>
</xsl:param>


<!--@@==========================================================================
color.bg.orange
An orange background color.
:Revision:version="3.28" date="2016-01-03" status="final"

This parameter specifies a shade of orange that is suitable for backgrounds.
It should have a high color contrast against @{color.fg}. If not specified,
it can be automatically computed based on @{color.orange} and @{color.bg}.
-->
<xsl:param name="color.bg.orange">
  <xsl:call-template name="_color.bgify">
    <xsl:with-param name="color" select="$color.orange"/>
  </xsl:call-template>
</xsl:param>


<!--@@==========================================================================
color.yellow
A yellow accent color.
:Revision:version="3.28" date="2016-01-03" status="final"

This parameter specifies a shade of yellow that is suitable for borders and
other accents. It should have some contrast against background colors, but it
does not need as high of a contrast as text colors.
-->
<xsl:param name="color.yellow" select="'#edd400'"/>


<!--@@==========================================================================
color.fg.yellow
A yellow text color.
:Revision:version="3.28" date="2016-01-03" status="final"

This parameter specifies a shade of yellow that is suitable for text. It should
have a high color contrast against @{color.bg}. If not specified, it can be
automatically computed based on @{color.yellow} and @{color.fg}.
-->
<xsl:param name="color.fg.yellow">
  <xsl:call-template name="_color.fgify">
    <xsl:with-param name="color" select="$color.yellow"/>
    <xsl:with-param name="target" select="5.5"/>
  </xsl:call-template>
</xsl:param>


<!--@@==========================================================================
color.bg.yellow
A yellow background color.
:Revision:version="3.28" date="2016-01-03" status="final"

This parameter specifies a shade of yellow that is suitable for backgrounds.
It should have a high color contrast against @{color.fg}. If not specified,
it can be automatically computed based on @{color.yellow} and @{color.bg}.
-->
<xsl:param name="color.bg.yellow">
  <xsl:call-template name="_color.bgify">
    <xsl:with-param name="color" select="$color.yellow"/>
    <xsl:with-param name="target" select="20"/>
  </xsl:call-template>
</xsl:param>


<!--@@==========================================================================
color.green
A green accent color.
:Revision:version="3.28" date="2016-01-03" status="final"

This parameter specifies a shade of green that is suitable for borders and
other accents. It should have some contrast against background colors, but it
does not need as high of a contrast as text colors.
-->
<xsl:param name="color.green" select="'#73d216'"/>


<!--@@==========================================================================
color.fg.green
A green text color.
:Revision:version="3.28" date="2016-01-03" status="final"

This parameter specifies a shade of green that is suitable for text. It should
have a high color contrast against @{color.bg}. If not specified, it can be
automatically computed based on @{color.green} and @{color.fg}.
-->
<xsl:param name="color.fg.green">
  <xsl:call-template name="_color.fgify">
    <xsl:with-param name="color" select="$color.green"/>
  </xsl:call-template>
</xsl:param>


<!--@@==========================================================================
color.bg.green
A green background color.
:Revision:version="3.28" date="2016-01-03" status="final"

This parameter specifies a shade of green that is suitable for backgrounds.
It should have a high color contrast against @{color.fg}. If not specified,
it can be automatically computed based on @{color.green} and @{color.bg}.
-->
<xsl:param name="color.bg.green">
  <xsl:call-template name="_color.bgify">
    <xsl:with-param name="color" select="$color.green"/>
  </xsl:call-template>
</xsl:param>


<!--@@==========================================================================
color.blue
A blue accent color.
:Revision:version="3.28" date="2016-01-03" status="final"

This parameter specifies a shade of blue that is suitable for borders and
other accents. It should have some contrast against background colors, but it
does not need as high of a contrast as text colors.
-->
<xsl:param name="color.blue" select="'#3465a4'"/>


<!--@@==========================================================================
color.fg.blue
A blue text color.
:Revision:version="3.28" date="2016-01-03" status="final"

This parameter specifies a shade of blue that is suitable for text. It should
have a high color contrast against @{color.bg}. If not specified, it can be
automatically computed based on @{color.blue} and @{color.fg}.
-->
<xsl:param name="color.fg.blue">
  <xsl:call-template name="_color.fgify">
    <xsl:with-param name="color" select="$color.blue"/>
  </xsl:call-template>
</xsl:param>

<!--@@==========================================================================
color.bg.blue
A blue background color.
:Revision:version="3.28" date="2016-01-03" status="final"

This parameter specifies a shade of blue that is suitable for backgrounds.
It should have a high color contrast against @{color.fg}. If not specified,
it can be automatically computed based on @{color.blue} and @{color.bg}.
-->
<xsl:param name="color.bg.blue">
  <xsl:call-template name="_color.bgify">
    <xsl:with-param name="color" select="$color.blue"/>
  </xsl:call-template>
</xsl:param>


<!--@@==========================================================================
color.purple
A purple accent color.
:Revision:version="3.28" date="2016-01-03" status="final"

This parameter specifies a shade of purple that is suitable for borders and
other accents. It should have some contrast against background colors, but it
does not need as high of a contrast as text colors.
-->
<xsl:param name="color.purple" select="'#75507b'"/>


<!--@@==========================================================================
color.fg.purple
A purple text color.
:Revision:version="3.28" date="2016-01-03" status="final"

This parameter specifies a shade of purple that is suitable for text. It should
have a high color contrast against @{color.bg}. If not specified, it can be
automatically computed based on @{color.purple} and @{color.fg}.
-->
<xsl:param name="color.fg.purple">
  <xsl:call-template name="_color.fgify">
    <xsl:with-param name="color" select="$color.purple"/>
  </xsl:call-template>
</xsl:param>


<!--@@==========================================================================
color.bg.purple
A purple background color.
:Revision:version="3.28" date="2016-01-03" status="final"

This parameter specifies a shade of purple that is suitable for backgrounds.
It should have a high color contrast against @{color.fg}. If not specified,
it can be automatically computed based on @{color.purple} and @{color.bg}.
-->
<xsl:param name="color.bg.purple">
  <xsl:call-template name="_color.bgify">
    <xsl:with-param name="color" select="$color.purple"/>
  </xsl:call-template>
</xsl:param>


<!--@@==========================================================================
color.gray
A gray accent color.
:Revision:version="3.28" date="2016-01-03" status="final"

This parameter specifies a shade of gray that is suitable for borders and
other accents. It should have some contrast against background colors, but it
does not need as high of a contrast as text colors.
-->
<xsl:param name="color.gray" select="'#babdb6'"/>


<!--@@==========================================================================
color.fg.gray
A gray text color.
:Revision:version="3.28" date="2016-01-03" status="final"

This parameter specifies a shade of gray that is suitable for text. It should
have a high color contrast against @{color.bg}. If not specified, it can be
automatically computed based on @{color.gray} and @{color.fg}.
-->
<xsl:param name="color.fg.gray">
  <xsl:call-template name="_color.fgify">
    <xsl:with-param name="color" select="$color.gray"/>
  </xsl:call-template>
</xsl:param>


<!--@@==========================================================================
color.bg.gray
A gray background color.
:Revision:version="3.28" date="2016-01-03" status="final"

This parameter specifies a shade of gray that is suitable for backgrounds.
It should have a high color contrast against @{color.fg}. If not specified,
it can be automatically computed based on @{color.gray} and @{color.bg}.
-->
<xsl:param name="color.bg.gray">
  <xsl:call-template name="_color.bgify">
    <xsl:with-param name="color" select="$color.gray"/>
  </xsl:call-template>
</xsl:param>


<!--@@==========================================================================
color.fg.dark
A dark gray text color.
:Revision:version="3.28" date="2016-01-03" status="final"

This parameter specifies a dark shade of gray that is suitable for text. It
should have a very high color contrast against @{color.bg}. It is typically
used to slightly reduce the visual weight of headers and bold text. If not
specified, it can be automatically computed based on @{color.gray} and
@{color.fg}.
-->
<xsl:param name="color.fg.dark">
  <xsl:call-template name="_color.fgify">
    <xsl:with-param name="color" select="$color.gray"/>
    <xsl:with-param name="target" select="8"/>
  </xsl:call-template>
</xsl:param>


<!--@@==========================================================================
color.bg.dark
A dark gray background color.
:Revision:version="3.28" date="2016-01-03" status="final"

This parameter specifies a shade of gray that is suitable for backgrounds,
and is darker than @{color.bg.gray}. It should have a high color contrast
against @{color.fg}. It is typically used at the intersection of shaded
rows and columns in a table, or as a very light gray accent color. If not
specified, it can be automatically computed based on @{color.gray} and
@{color.bg}.
-->
<xsl:param name="color.bg.dark">
  <xsl:call-template name="_color.bgify">
    <xsl:with-param name="color" select="$color.gray"/>
    <xsl:with-param name="target" select="17"/>
  </xsl:call-template>
</xsl:param>


<!--
Old color parameters below. Kept for compatibility with existing
customizations that reference these colors.
-->

<!--#@ color.background -->
<xsl:param name="color.background" select="$color.bg"/>

<!--#@ color.link -->
<xsl:param name="color.link" select="$color.fg.blue"/>

<!--#@ color.link_visited -->
<xsl:param name="color.link_visited" select="$color.fg.purple"/>

<!--#@ color.text -->
<xsl:param name="color.text" select="$color.fg"/>

<!--#@ color.text_light -->
<xsl:param name="color.text_light" select="$color.fg.dark"/>

<!--#@ color.text_error -->
<xsl:param name="color.text_error" select="$color.fg.red"/>

<!--#@ color.blue_background -->
<xsl:param name="color.blue_background" select="$color.bg.blue"/>

<!--#@ color.blue_border -->
<xsl:param name="color.blue_border" select="$color.blue"/>

<!--#@ color.gray_background -->
<xsl:param name="color.gray_background" select="$color.bg.gray"/>

<!--#@ color.dark_background -->
<xsl:param name="color.dark_background" select="$color.bg.dark"/>

<!--#@ color.gray_border -->
<xsl:param name="color.gray_border" select="$color.gray"/>

<!--#@ color.red_background -->
<xsl:param name="color.red_background" select="$color.bg.red"/>

<!--#@ color.red_border -->
<xsl:param name="color.red_border" select="$color.red"/>

<!--#@ color.yellow_background -->
<xsl:param name="color.yellow_background" select="$color.bg.yellow"/>

<!--#@ color.yellow_border -->
<xsl:param name="color.yellow_border" select="$color.yellow"/>


</xsl:stylesheet>
