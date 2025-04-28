<xsl:stylesheet version="2.0"
                xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
                xmlns:gmd="http://www.isotc211.org/2005/gmd"
                xmlns:mco="http://standards.iso.org/iso/19115/-3/mco/1.0"
                xmlns:gco="http://standards.iso.org/iso/19115/-3/gco/1.0"
                xmlns:che="http://geocat.ch/che"
                xmlns:oldche="http://www.geocat.ch/2008/che"
                exclude-result-prefixes="#all">

    <xsl:template match="gmd:MD_LegalConstraints|oldche:CHE_MD_LegalConstraints" mode="from19139to19115-3.2018">
        <xsl:element name="che:CHE_MD_LegalConstraints">
            <xsl:attribute name="gco:isoType" select="'mco:MD_LegalConstraints'"/>
            <xsl:apply-templates mode="from19139to19115-3.2018"/>
        </xsl:element>
    </xsl:template>
</xsl:stylesheet>