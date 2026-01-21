<xsl:stylesheet version="2.0"
                xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
                xmlns:gmd="http://www.isotc211.org/2005/gmd"
                xmlns:mrd="http://standards.iso.org/iso/19115/-3/mrd/1.0"
                exclude-result-prefixes="#all">

    <xsl:template match="gmd:transferOptions" mode="from19139to19115-3.2018">
        <xsl:for-each select="gmd:MD_DigitalTransferOptions/gmd:onLine">
            <xsl:element name ="mrd:transferOptions">
                <xsl:element name ="mrd:MD_DigitalTransferOptions">
                    <xsl:apply-templates select="../*[not(self::gmd:onLine or self::gmd:offLine)]" mode="from19139to19115-3.2018"/>
                    <xsl:element name="mrd:onLine">
                        <xsl:apply-templates select="./*" mode="from19139to19115-3.2018"/>
                    </xsl:element>
                </xsl:element>
            </xsl:element>
        </xsl:for-each>
        <xsl:for-each select="gmd:MD_DigitalTransferOptions/gmd:offLine">
            <xsl:element name ="mrd:transferOptions">
                <xsl:element name ="mrd:MD_DigitalTransferOptions">
                    <xsl:apply-templates select="../*[not(self::gmd:onLine or self::gmd:offLine)]" mode="from19139to19115-3.2018"/>
                    <xsl:element name="mrd:offLine">
                        <xsl:apply-templates select="./*" mode="from19139to19115-3.2018"/>
                    </xsl:element>
                </xsl:element>
            </xsl:element>
        </xsl:for-each>
        <xsl:for-each select="gmd:MD_DigitalTransferOptions[count(gmd:onLine) = 0]">
            <xsl:element name ="mrd:transferOptions">
                <xsl:apply-templates select="." mode="from19139to19115-3.2018"/>
            </xsl:element>
        </xsl:for-each>
    </xsl:template>
</xsl:stylesheet>