<xsl:stylesheet version="2.0"
                xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
                xmlns:mmi="http://standards.iso.org/iso/19115/-3/mmi/1.0"
                xmlns:gco="http://standards.iso.org/iso/19115/-3/gco/1.0"
                xmlns:che="http://geocat.ch/che"
                xmlns:oldche="http://www.geocat.ch/2008/che"
                exclude-result-prefixes="#all">

    <xsl:template match="oldche:CHE_MD_MaintenanceInformation" mode="from19139to19115-3.2018">
        <xsl:element name="che:CHE_MD_MaintenanceInformation">
            <xsl:apply-templates select="@*" mode="from19139to19115-3.2018"/>
            <xsl:attribute name="gco:isoType">mmi:MD_MaintenanceInformation</xsl:attribute>
            <xsl:apply-templates mode="from19139to19115-3.2018"/>
        </xsl:element>
    </xsl:template>
</xsl:stylesheet>