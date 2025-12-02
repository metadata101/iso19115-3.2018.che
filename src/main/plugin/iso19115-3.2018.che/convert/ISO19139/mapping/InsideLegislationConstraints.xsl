<xsl:stylesheet version="2.0"
                xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
                xmlns:gmd="http://www.isotc211.org/2005/gmd"
                xmlns:lan="http://standards.iso.org/iso/19115/-3/lan/1.0"
                xmlns:che="http://geocat.ch/che"
                xmlns:oldche="http://www.geocat.ch/2008/che"
                exclude-result-prefixes="#all">

    <xsl:template match="gmd:Country" mode="from19139to19115-3.2018">
        <lan:CountryCode>
            <xsl:apply-templates select="@*" mode="from19139to19115-3.2018"/>
        </lan:CountryCode>
    </xsl:template>
    <xsl:template match="gmd:LanguageCode" mode="from19139to19115-3.2018">
        <lan:LanguageCode>
            <xsl:apply-templates select="@*" mode="from19139to19115-3.2018"/>
        </lan:LanguageCode>
    </xsl:template>
    <xsl:template match="oldche:legislationType" mode="from19139to19115-3.2018">
        <xsl:choose>
            <xsl:when test="oldche:CHE_CI_LegislationCode/@codeListValue='nationalDecree'">
                <xsl:element name="che:legislationType">
                    <xsl:element name="che:CHE_CI_LegislationTypeCode">
                        <xsl:attribute name="codeList">legislationType</xsl:attribute>
                        <xsl:attribute name="codeListValue" select="'ordinance'"/>
                    </xsl:element>
                </xsl:element>
                <xsl:element name="che:legislationLevel">
                    <xsl:element name="che:CHE_MD_LevelCode">
                        <xsl:attribute name="codeList">mdLevelCode</xsl:attribute>
                        <xsl:attribute name="codeListValue" select="'national'"/>
                    </xsl:element>
                </xsl:element>
            </xsl:when>
            <xsl:otherwise>
                <xsl:element name="che:legislationType">
                    <xsl:element name="che:CHE_CI_LegislationTypeCode">
                        <xsl:attribute name="codeList">legislationCode</xsl:attribute>
                        <xsl:attribute name="codeListValue" select="oldche:CHE_CI_LegislationCode/@codeListValue"/>
                    </xsl:element>
                </xsl:element>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:template>
    <xsl:template match="oldche:title" mode="from19139to19115-3.2018">
        <che:legislationCitation>
            <xsl:apply-templates select="@*" mode="from19139to19115-3.2018"/>
        </che:legislationCitation>
    </xsl:template>

</xsl:stylesheet>