<xsl:stylesheet version="2.0"
                xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
                xmlns:xlink="http://www.w3.org/1999/xlink"
                exclude-result-prefixes="#all">

<xsl:template match="@xlink:href" mode="from19139to19115-3.2018">
    <xsl:attribute name="xlink:href">
        <xsl:copy-of select="replace(.,'process=.*/gmd:CI_RoleCode', 'process=cit:role/cit:CI_RoleCode')"/>
    </xsl:attribute>
</xsl:template>

</xsl:stylesheet>