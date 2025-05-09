<xsl:stylesheet version="2.0"
                xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
                xmlns:gmd="http://www.isotc211.org/2005/gmd"
                xmlns:gcoold="http://www.isotc211.org/2005/gco"
                xmlns:cit="http://standards.iso.org/iso/19115/-3/cit/2.0"
                exclude-result-prefixes="#all">

    <xsl:template match="gcoold:Binary[(ancestor-or-self::*/name())[2] = 'gmd:applicationSchemaInfo']" mode="from19139to19115-3.2018">
        <cit:CI_OnlineResource>
            <cit:linkage>
                <xsl:copy-of select="./*" copy-namespaces="no"/>
            </cit:linkage>
        </cit:CI_OnlineResource>
    </xsl:template>
</xsl:stylesheet>