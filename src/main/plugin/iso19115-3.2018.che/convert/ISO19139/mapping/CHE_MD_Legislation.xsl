<xsl:stylesheet version="2.0"
                xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
                xmlns:che="http://geocat.ch/che"
                xmlns:oldche="http://www.geocat.ch/2008/che"
                exclude-result-prefixes="#all">

    <xsl:template match="oldche:title" mode="from19139to19115-3.2018">
        <xsl:element name="che:legislationCitation">
            <xsl:apply-templates mode="from19139to19115-3.2018"/>
        </xsl:element>
    </xsl:template>
</xsl:stylesheet>