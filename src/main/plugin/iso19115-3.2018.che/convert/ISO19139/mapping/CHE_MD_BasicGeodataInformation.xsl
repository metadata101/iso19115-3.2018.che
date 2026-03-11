<xsl:stylesheet version="2.0"
                xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
                xmlns:gco="http://standards.iso.org/iso/19115/-3/gco/1.0"
                xmlns:che="http://geocat.ch/che"
                xmlns:gcoold="http://www.isotc211.org/2005/gco"
                xmlns:oldche="http://www.geocat.ch/2008/che"
                xmlns:gmd="http://www.isotc211.org/2005/gmd"
                exclude-result-prefixes="#all">

    <xsl:template match="*" mode="from19139to19115-3.2018-CHE_MD_BasicGeodataInformation">
        <xsl:variable name="hasBasicGeodataID"
                      select="some $id in oldche:basicGeodataID/gcoold:CharacterString satisfies normalize-space($id) != ''"/>
        <xsl:variable name="hasGeobasisdatenKeyword"
                      select="gmd:descriptiveKeywords/gmd:MD_Keywords/gmd:keyword/gcoold:CharacterString[normalize-space(.) = 'Geobasisdaten']"/>
        <xsl:element name="che:basicGeodata">
            <xsl:choose>
                <xsl:when test="$hasBasicGeodataID or $hasGeobasisdatenKeyword">
                    <gco:Boolean>true</gco:Boolean>
                </xsl:when>
                <xsl:otherwise>
                    <gco:Boolean>false</gco:Boolean>
                </xsl:otherwise>
            </xsl:choose>
        </xsl:element>
        <xsl:element name="che:basicGeodataInformation">
            <xsl:element name="che:CHE_MD_BasicGeodataInformation">
                <xsl:choose>
                    <xsl:when test="oldche:basicGeodataID">
                        <xsl:for-each select="oldche:basicGeodataID">
                            <che:basicGeodataID>
                                <xsl:apply-templates select="gcoold:CharacterString" mode="from19139to19115-3.2018"/>
                            </che:basicGeodataID>
                        </xsl:for-each>
                    </xsl:when>
                    <xsl:otherwise>
                        <xsl:element name="che:basicGeodataID">
                            <xsl:attribute name="gco:nilReason">missing</xsl:attribute>
                        </xsl:element>
                    </xsl:otherwise>
                </xsl:choose>

                <xsl:if test="oldche:basicGeodataIDType/oldche:basicGeodataIDTypeCode/@codeListValue">
                    <che:basicGeodataLegalLevel>
                        <xsl:element name="che:CHE_MD_LevelCode">
                            <xsl:attribute name="codeList">mdLevelCode</xsl:attribute>
                            <xsl:attribute name="codeListValue" select="oldche:basicGeodataIDType/oldche:basicGeodataIDTypeCode/@codeListValue"/>
                        </xsl:element>
                    </che:basicGeodataLegalLevel>
                </xsl:if>

                <xsl:if test="oldche:geodataType/oldche:MD_geodataTypeCode/@codeListValue">
                    <che:basicGeodataType>
                        <xsl:element name="che:CHE_MD_BasicGeodataTypeCode">
                            <xsl:attribute name="codeList">geodataType</xsl:attribute>
                            <xsl:attribute name="codeListValue" select="oldche:geodataType/oldche:MD_geodataTypeCode/@codeListValue"/>
                        </xsl:element>
                    </che:basicGeodataType>
                </xsl:if>

            </xsl:element>
        </xsl:element>
    </xsl:template>
</xsl:stylesheet>