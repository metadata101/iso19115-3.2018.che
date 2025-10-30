<xsl:stylesheet version="2.0"
                xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
                xmlns:mmi="http://standards.iso.org/iso/19115/-3/mmi/1.0"
                xmlns:gco="http://standards.iso.org/iso/19115/-3/gco/1.0"
                xmlns:mcc="http://standards.iso.org/iso/19115/-3/mcc/1.0"
                xmlns:gmd="http://www.isotc211.org/2005/gmd"
                xmlns:che="http://geocat.ch/che"
                xmlns:oldche="http://www.geocat.ch/2008/che"
                xmlns:cit="http://standards.iso.org/iso/19115/-3/cit/2.0"
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
                    <cit:CI_Date>
                        <cit:date>
                            <xsl:apply-templates  select="./*" mode="from19139to19115-3.2018"/>
                        </cit:date>
                        <cit:dateType>
                            <cit:CI_DateTypeCode codeList="https://standards.iso.org/iso/19115/resources/Codelists/cat/codelists.xml#CI_DateTypeCode" codeListValue="nextUpdate ">nextUpdate</cit:CI_DateTypeCode>
                        </cit:dateType>
                    </cit:CI_Date>
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
            <xsl:attribute name="codeList">appraisalOfArchivalValueCode</xsl:attribute>
            <xsl:attribute name="codeListValue" select="@codeListValue"/>
        </xsl:element>
    </xsl:template>

    <xsl:template match="oldche:CHE_ReasonForArchivingValueCode" mode="from19139to19115-3.2018">
        <xsl:element name="che:CHE_ReasonForArchivingValueCode">
            <xsl:attribute name="codeList">reasonForArchivingValueCode</xsl:attribute>
            <xsl:attribute name="codeListValue" select="@codeListValue"/>
        </xsl:element>
    </xsl:template>

</xsl:stylesheet>