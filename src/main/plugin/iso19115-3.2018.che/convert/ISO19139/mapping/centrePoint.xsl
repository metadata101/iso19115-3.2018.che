<xsl:stylesheet version="2.0"
                xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
                xmlns:gmd="http://www.isotc211.org/2005/gmd"
                xmlns:msr="http://standards.iso.org/iso/19115/-3/msr/2.0"
                exclude-result-prefixes="#all">


    <xsl:template match="gmd:centerPoint" mode="from19139to19115-3.2018">
        <msr:centrePoint>
                <xsl:copy-of select="./*" copy-namespaces="no"/>
        </msr:centrePoint>
    </xsl:template>
</xsl:stylesheet>