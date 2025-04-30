<xsl:stylesheet version="2.0"
                xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
                xmlns:mmi="http://standards.iso.org/iso/19115/-3/mmi/1.0"
                xmlns:gco="http://standards.iso.org/iso/19115/-3/gco/1.0"
                xmlns:mcc="http://standards.iso.org/iso/19115/-3/mcc/1.0"
                xmlns:gmd="http://www.isotc211.org/2005/gmd"
                xmlns:che="http://geocat.ch/che"
                xmlns:oldche="http://www.geocat.ch/2008/che"
                exclude-result-prefixes="#all">

    <xsl:template match="oldche:CHE_MD_MaintenanceInformation" mode="from19139to19115-3.2018">
        <xsl:element name="che:CHE_MD_MaintenanceInformation">
            <xsl:apply-templates select="@*" mode="from19139to19115-3.2018"/>
            <xsl:attribute name="gco:isoType">mmi:MD_MaintenanceInformation</xsl:attribute>

            <xsl:for-each select="gmd:maintenanceAndUpdateFrequency">
                <xsl:apply-templates select="." mode="from19139to19115-3.2018"/>
            </xsl:for-each>

            <xsl:for-each select="gmd:dateOfNextUpdate">
                <mmi:maintenanceDate>
                    <xsl:apply-templates  select="./*" mode="from19139to19115-3.2018"/>
                </mmi:maintenanceDate>
            </xsl:for-each>

            <xsl:for-each select="gmd:userDefinedMaintenanceFrequency">
                <xsl:apply-templates select="." mode="from19139to19115-3.2018"/>
            </xsl:for-each>

            <xsl:for-each select="gmd:updateScope">
                <mmi:maintenanceScope>
                    <mcc:MD_Scope>
                        <mcc:level>
                            <xsl:apply-templates  select="./*" mode="from19139to19115-3.2018"/>
                        </mcc:level>
                    </mcc:MD_Scope>
                </mmi:maintenanceScope>
            </xsl:for-each>

            <xsl:for-each select="gmd:maintenanceNote">
                <xsl:apply-templates  select="." mode="from19139to19115-3.2018"/>
            </xsl:for-each>

            <xsl:for-each select="gmd:contact">
                <xsl:apply-templates  select="." mode="from19139to19115-3.2018"/>
            </xsl:for-each>

            <xsl:for-each select="oldche:appraisal">
                <xsl:apply-templates  select="." mode="from19139to19115-3.2018"/>
            </xsl:for-each>
        </xsl:element>
    </xsl:template>

    <xsl:template match="oldche:CHE_AppraisalOfArchivalValueCode" mode="from19139to19115-3.2018">
        <xsl:element name="che:CHE_AppraisalOfArchivalValueCode">
            <xsl:attribute name="codeList">#CHE_AppraisalOfArchivalValueCode</xsl:attribute>
            <xsl:attribute name="codeListValue" select="oldche:CHE_AppraisalOfArchivalValueCode/@codeListValue"/>
        </xsl:element>
    </xsl:template>

    <xsl:template match="oldche:CHE_ReasonForArchivingValueCode" mode="from19139to19115-3.2018">
        <xsl:element name="che:CHE_ReasonForArchivingValueCode">
            <xsl:attribute name="codeList">#CHE_ReasonForArchivingValueCode</xsl:attribute>
            <xsl:attribute name="codeListValue" select="oldche:CHE_ReasonForArchivingValueCode/@codeListValue"/>
        </xsl:element>
    </xsl:template>

</xsl:stylesheet>