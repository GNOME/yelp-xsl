<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
                version="1.0">

<xsl:output method="html"/>

<xsl:include href="../gettext/gettext.xsl"/>
<xsl:include href="theme-colors.xsl"/>

<xsl:template match="/">
  <html>
    <head>
      <style type="text/css">
<xsl:text>
body {
  background-color: </xsl:text><xsl:value-of select="$theme.color.background"/><xsl:text>;
}
h1 {
  margin: 0;
  font-size: 1.44em;
  color:  </xsl:text><xsl:value-of select="$theme.color.text_light"/><xsl:text>;
}
h2 {
  margin: 2em 0 0 0;
  font-size: 1.2em;
  color:  </xsl:text><xsl:value-of select="$theme.color.text_light"/><xsl:text>;
}
div {
  min-height: 4em;
  min-width: 6em;
  margin: 1em 0.5em 0 0.5em;
  padding: 2px;
}
p { margin: 0.5em 0 0.5em 0; }
td { text-align: center; }
p.text {
  color:  </xsl:text><xsl:value-of select="$theme.color.text"/><xsl:text>;
}
p.light {
  color:  </xsl:text><xsl:value-of select="$theme.color.text_light"/><xsl:text>;
}
p.error {
  color:  </xsl:text><xsl:value-of select="$theme.color.text_error"/><xsl:text>;
}
p.link {
  color:  </xsl:text><xsl:value-of select="$theme.color.link"/><xsl:text>;
}
p.visited {
  color:  </xsl:text><xsl:value-of select="$theme.color.link_visited"/><xsl:text>;
}
div.graybg {
  background-color: </xsl:text><xsl:value-of select="$theme.color.gray_background"/><xsl:text>;
}
div.darkbg {
  background-color: </xsl:text><xsl:value-of select="$theme.color.dark_background"/><xsl:text>;
}
div.bluebg {
  background-color: </xsl:text><xsl:value-of select="$theme.color.blue_background"/><xsl:text>;
}
div.redbg {
  background-color: </xsl:text><xsl:value-of select="$theme.color.red_background"/><xsl:text>;
}
div.yellowbg {
  background-color: </xsl:text><xsl:value-of select="$theme.color.yellow_background"/><xsl:text>;
}
div.graybr {
  border: solid 2px </xsl:text><xsl:value-of select="$theme.color.gray_border"/><xsl:text>;
}
div.bluebr {
  border: solid 2px </xsl:text><xsl:value-of select="$theme.color.blue_border"/><xsl:text>;
}
div.redbr {
  border: solid 2px </xsl:text><xsl:value-of select="$theme.color.red_border"/><xsl:text>;
}
div.yellowbr {
  border: solid 2px </xsl:text><xsl:value-of select="$theme.color.yellow_border"/><xsl:text>;
}
</xsl:text>
      </style>
    </head>
    <body>
      <h1>Yelp Theme Test</h1>
      <xsl:call-template name="boxes"/>
      <xsl:call-template name="texts"/>
    </body>
  </html>
</xsl:template>

<xsl:template name="boxes">
  <h2>Backgrounds and Borders</h2>
  <table>
    <tr>
      <td></td>
      <td style="color: {$theme.color.gray_border}"><xsl:value-of select="$theme.color.gray_border"/></td>
      <td style="color: {$theme.color.blue_border}"><xsl:value-of select="$theme.color.blue_border"/></td>
      <td style="color: {$theme.color.red_border}"><xsl:value-of select="$theme.color.red_border"/></td>
      <td style="color: {$theme.color.yellow_border}"><xsl:value-of select="$theme.color.yellow_border"/></td>
    </tr>
    <tr>
      <td><div><xsl:value-of select="$theme.color.background"/></div></td>
      <td><div class="graybr"/></td>
      <td><div class="bluebr"/></td>
      <td><div class="redbr"/></td>
      <td><div class="yellowbr"/></td>
    </tr>
    <tr>
      <td><div class="graybg"><xsl:value-of select="$theme.color.gray_background"/></div></td>
      <td><div class="graybg graybr"/></td>
      <td><div class="graybg bluebr"/></td>
      <td><div class="graybg redbr"/></td>
      <td><div class="graybg yellowbr"/></td>
    </tr>
    <tr>
      <td><div class="darkbg"><xsl:value-of select="$theme.color.dark_background"/></div></td>
      <td><div class="darkbg graybr"/></td>
      <td><div class="darkbg bluebr"/></td>
      <td><div class="darkbg redbr"/></td>
      <td><div class="darkbg yellowbr"/></td>
    </tr>
    <tr>
      <td><div class="bluebg"><xsl:value-of select="$theme.color.blue_background"/></div></td>
      <td><div class="bluebg graybr"/></td>
      <td><div class="bluebg bluebr"/></td>
      <td><div class="bluebg redbr"/></td>
      <td><div class="bluebg yellowbr"/></td>
    </tr>
    <tr>
      <td><div class="redbg"><xsl:value-of select="$theme.color.red_background"/></div></td>
      <td><div class="redbg graybr"/></td>
      <td><div class="redbg bluebr"/></td>
      <td><div class="redbg redbr"/></td>
      <td><div class="redbg yellowbr"/></td>
    </tr>
    <tr>
      <td><div class="yellowbg"><xsl:value-of select="$theme.color.yellow_background"/></div></td>
      <td><div class="yellowbg graybr"/></td>
      <td><div class="yellowbg bluebr"/></td>
      <td><div class="yellowbg redbr"/></td>
      <td><div class="yellowbg yellowbr"/></td>
    </tr>
  </table>
</xsl:template>

<xsl:template name="texts">
  <h2>Text Colors</h2>
  <table>
    <tr>
      <td><div>
        <p class="text"><xsl:value-of select="$theme.color.text"/></p>
        <p class="light"><xsl:value-of select="$theme.color.text_light"/></p>
        <p class="error"><xsl:value-of select="$theme.color.text_error"/></p>
        <p class="link"><xsl:value-of select="$theme.color.link"/></p>
        <p class="visited"><xsl:value-of select="$theme.color.link_visited"/></p>
      </div></td>
      <td><div class="graybg">
        <p class="text">text</p>
        <p class="light">light</p>
        <p class="error">error</p>
        <p class="link">link</p>
        <p class="visited">visited</p>
      </div></td>
      <td><div class="darkbg">
        <p class="text">text</p>
        <p class="light">light</p>
        <p class="error">error</p>
        <p class="link">link</p>
        <p class="visited">visited</p>
      </div></td>
      <td><div class="bluebg">
        <p class="text">text</p>
        <p class="light">light</p>
        <p class="error">error</p>
        <p class="link">link</p>
        <p class="visited">visited</p>
      </div></td>
      <td><div class="redbg">
        <p class="text">text</p>
        <p class="light">light</p>
        <p class="error">error</p>
        <p class="link">link</p>
        <p class="visited">visited</p>
      </div></td>
      <td><div class="yellowbg">
        <p class="text">text</p>
        <p class="light">light</p>
        <p class="error">error</p>
        <p class="link">link</p>
        <p class="visited">visited</p>
      </div></td>
    </tr>
  </table>
</xsl:template>

</xsl:stylesheet>
