<xsl:stylesheet version="2.0"
                xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
                xmlns:xlink="http://www.w3.org/1999/xlink"
                exclude-result-prefixes="#all">

<xsl:template match="@xlink:href" mode="from19139to19115-3.2018">
    <xsl:variable name="xlink">
        <xsl:value-of select="replace(.,'process=.*/gmd:CI_RoleCode', 'process=cit:role/cit:CI_RoleCode')"/>
    </xsl:variable>
    <xsl:attribute name="xlink:href">
        <xsl:choose>
            <xsl:when test="starts-with(., 'local://srv/api/registries/entries')">
                <xsl:choose>
                    <xsl:when test="contains($xlink, 'schema=')">
                        <xsl:copy-of select="replace($xlink, 'schema=.*', 'schema=iso19115-3.2018.che')"/>
                    </xsl:when>
                    <xsl:when test="contains($xlink, '?')">
                        <xsl:copy-of select="replace(concat($xlink, '&amp;schema=iso19115-3.2018.che'), '&amp;&amp;', '&amp;')"/>
                    </xsl:when>
                    <xsl:otherwise>
                        <xsl:copy-of select="concat($xlink, '?schema=iso19115-3.2018.che')"/>
                    </xsl:otherwise>
                </xsl:choose>
            </xsl:when>
            <xsl:otherwise>
                    <xsl:copy-of select="$xlink"/>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:attribute>
</xsl:template>

</xsl:stylesheet>