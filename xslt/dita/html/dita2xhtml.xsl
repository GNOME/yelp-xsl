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
                xmlns="http://www.w3.org/1999/xhtml"
                version="1.0">


<!--!!==========================================================================
DITA to XHTML

REMARK: Describe this module
-->

<xsl:import href="../../common/l10n.xsl"/>
<xsl:import href="../../common/color.xsl"/>
<xsl:import href="../../common/icons.xsl"/>
<xsl:import href="../../common/html.xsl"/>
<xsl:import href="../../common/ttml.xsl"/>
<xsl:import href="../../common/tmpl.xsl"/>
<xsl:import href="../../common/utils.xsl"/>

<xsl:import href="../common/dita-map.xsl"/>
<xsl:import href="../common/dita-ref.xsl"/>

<xsl:param name="dita.ref.extension" select="$html.extension"/>

<xsl:include href="dita2html-block.xsl"/>
<xsl:include href="dita2html-inline.xsl"/>
<xsl:include href="dita2html-list.xsl"/>
<xsl:include href="dita2html-media.xsl"/>
<xsl:include href="dita2html-table.xsl"/>
<xsl:include href="dita2html-topic.xsl"/>

</xsl:stylesheet>
