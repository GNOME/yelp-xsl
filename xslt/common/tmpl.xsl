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
along with this program; see the file COPYING.LGPL. If not, see
<http://www.gnu.org/licenses/>.
-->

<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
                xmlns:dyn="http://exslt.org/dynamic"
                xmlns:str="http://exslt.org/strings"
                exclude-result-prefixes="dyn str"
                version="1.0">

<!--!!==========================================================================
Text Templates
Perform simple substitutions in text files.
@revision[version=40 date=2020-10-16 status=final]

This stylesheet contains templates to perform simple substitutions on text
and files containing text. The primary purpose of these templates is to allow
CSS and JavaScript to be maintained in separate files outside the XSLT, but
still allow those files to reference variables for things like color themes
and text directionality.

The substitution evaluates anything between `{{` and `}}`. Usually, this will
be a reference to a parameter or variable, but it can be any XPath expression.
For example, `{{$color.fg}}` will be replaced with the primary text color.

This syntax is similar to XSLT attribute value templates, except that it uses
double curly braces to avoid conflicts with the many curly braces used in CSS
and JavaScript files.

[note .plain]
This stylesheet was added in version 40.
-->


<!--**==========================================================================
tmpl.file
Perform text substitutions on a file.
@revision[version=40 date=2020-10-16 status=final]

[xsl:params]
$file: The filename of the file to process for substitutions.
$node: The node to create CSS for.
$direction: The directionality of the text, either `ltr` or `rtl`.
$left: The starting alignment, either `left` or `right`.
$right: The ending alignment, either `left` or `right`.

This template reads the file specified by the $file parameter and performs
text substitutions. Due to XSLT limitations, the file must be a well-formed
XML document. However, this template simply takes the string value of the
document, so it is sufficient to wrap the text in a dummy element and ensure
any `<` and `&` characters are escaped.

See {tmpl} for information on the substitution syntax.

[note .plain]
This template was added in version 40.
-->
<xsl:template name="tmpl.file">
  <xsl:param name="file"/>
  <xsl:param name="node" select="."/>
  <xsl:param name="direction">
    <xsl:call-template name="l10n.direction"/>
  </xsl:param>
  <xsl:param name="left">
    <xsl:call-template name="l10n.align.start">
      <xsl:with-param name="direction" select="$direction"/>
    </xsl:call-template>
  </xsl:param>
  <xsl:param name="right">
    <xsl:call-template name="l10n.align.end">
      <xsl:with-param name="direction" select="$direction"/>
    </xsl:call-template>
  </xsl:param>

  <xsl:for-each select="document($file)">
    <xsl:call-template name="tmpl.text">
      <xsl:with-param name="text" select="string(.)"/>
      <xsl:with-param name="node" select="$node"/>
      <xsl:with-param name="direction" select="$direction"/>
      <xsl:with-param name="left" select="$left"/>
      <xsl:with-param name="right" select="$right"/>
    </xsl:call-template>
  </xsl:for-each>
</xsl:template>


<!--**==========================================================================
tmpl.text
Perform text substitutions on some text.
@revision[version=40 date=2020-10-16 status=final]

[xsl:params]
$text: The text to process for substitutions.
$node: The node to create CSS for.
$direction: The directionality of the text, either `ltr` or `rtl`.
$left: The starting alignment, either `left` or `right`.
$right: The ending alignment, either `left` or `right`.

This template performs text substitutions on the text in $text. It is called
by {tmpl.file}, and it calls itself recursively after each substitution.

See {tmpl} for information on the substitution syntax.

[note .plain]
This template was added in version 40.
-->
<xsl:template name="tmpl.text">
  <xsl:param name="text" select="''"/>
  <xsl:param name="node" select="."/>
  <xsl:param name="direction">
    <xsl:call-template name="l10n.direction"/>
  </xsl:param>
  <xsl:param name="left">
    <xsl:call-template name="l10n.align.start">
      <xsl:with-param name="direction" select="$direction"/>
    </xsl:call-template>
  </xsl:param>
  <xsl:param name="right">
    <xsl:call-template name="l10n.align.end">
      <xsl:with-param name="direction" select="$direction"/>
    </xsl:call-template>
  </xsl:param>
  <xsl:choose>
    <xsl:when test="contains($text, '{{')">
      <xsl:variable name="aft" select="substring-after($text, '{{')"/>
      <xsl:choose>
        <xsl:when test="contains($aft, '}}')">
          <xsl:value-of select="substring-before($text, '{{')"/>
          <xsl:value-of select="dyn:evaluate(substring-before($aft, '}}'))"/>
          <xsl:call-template name="tmpl.text">
            <xsl:with-param name="text" select="substring-after($aft, '}}')"/>
            <xsl:with-param name="node" select="$node"/>
            <xsl:with-param name="direction" select="$direction"/>
            <xsl:with-param name="left" select="$left"/>
            <xsl:with-param name="right" select="$right"/>
          </xsl:call-template>
        </xsl:when>
        <xsl:otherwise>
          <xsl:value-of select="$text"/>
        </xsl:otherwise>
      </xsl:choose>
    </xsl:when>
    <xsl:otherwise>
      <xsl:value-of select="$text"/>
    </xsl:otherwise>
  </xsl:choose>
</xsl:template>

</xsl:stylesheet>
