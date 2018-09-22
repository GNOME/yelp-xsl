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
                xmlns:html="http://www.w3.org/1999/xhtml"
                xmlns:mml="http://www.w3.org/1998/Math/MathML"
                xmlns:svg="http://www.w3.org/2000/svg"
                exclude-result-prefixes="html mml svg"
                version="1.0">

<!--!!==========================================================================
DITA to HTML

REMARK: Describe this module
-->

<xsl:import href="dita2xhtml.xsl"><?xsldoc.passthrough?></xsl:import>

<xsl:param name="html.xhtml" select="false()"/>

<xsl:namespace-alias stylesheet-prefix="html" result-prefix="#default"/>
<xsl:namespace-alias stylesheet-prefix="mml" result-prefix="#default"/>
<xsl:namespace-alias stylesheet-prefix="svg" result-prefix="#default"/>

</xsl:stylesheet>
