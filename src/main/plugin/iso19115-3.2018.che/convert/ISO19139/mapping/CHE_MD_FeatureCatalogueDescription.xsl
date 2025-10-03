<xsl:stylesheet version="2.0"
                xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
                xmlns:oldche="http://www.geocat.ch/2008/che"
                xmlns:mrc="http://standards.iso.org/iso/19115/-3/mrc/2.0"
                xmlns:gco="http://standards.iso.org/iso/19115/-3/gco/1.0"
                xmlns:gfc="http://standards.iso.org/iso/19110/gfc/1.1"
                xmlns:gcoold="http://www.isotc211.org/2005/gco"
                xmlns:gmd="http://www.isotc211.org/2005/gmd"
                xmlns:cat="http://standards.iso.org/iso/19115/-3/cat/1.0"
                xmlns:mdb="http://standards.iso.org/iso/19115/-3/mdb/2.0"
                exclude-result-prefixes="#all">

    <!-- no need for gfc:FC_FeatureCatalogue, mrc:MD_FeatureCatalogueDescription is enough -->
    <xsl:template match="oldche:CHE_MD_FeatureCatalogueDescription" mode="from19139to19115-3.2018">
        <xsl:element name="mrc:MD_FeatureCatalogueDescription">
            <xsl:apply-templates mode="from19139to19115-3.2018"/>
        </xsl:element>
    </xsl:template>

    <xsl:template match="oldche:class" mode="from19139to19115-3.2018"/>
    <xsl:template match="oldche:dataModel" mode="from19139to19115-3.2018"/>
    <xsl:template match="oldche:modelType" mode="from19139to19115-3.2018"/>

    <!-- need for gfc:FC_FeatureCatalogue -->
    <xsl:template match="oldche:CHE_MD_FeatureCatalogueDescription" mode="from19139to19115-3.2018-catalog">
        <xsl:element name="mdb:contentInfo">
            <xsl:element name="mrc:MD_FeatureCatalogue">
                <xsl:element name="mrc:featureCatalogue">
                    <xsl:element name="gfc:FC_FeatureCatalogue">
                        <xsl:choose>
                            <xsl:when test="./gmd:featureCatalogueCitation/gmd:CI_Citation/gmd:title">
                                <xsl:call-template name="writeCharacterStringElement">
                                    <xsl:with-param name="elementName" select="'cat:name'"/>
                                    <xsl:with-param name="nodeWithStringToWrite" select="./gmd:featureCatalogueCitation/gmd:CI_Citation/gmd:title"/>
                                </xsl:call-template>
                            </xsl:when>
                            <xsl:otherwise>
                                <xsl:element name="cat:name">
                                    <xsl:attribute name="gco:nilReason">missing</xsl:attribute>
                                </xsl:element>
                            </xsl:otherwise>
                        </xsl:choose>
                        <xsl:element name="cat:scope">
                            <xsl:attribute name="gco:nilReason">missing</xsl:attribute>
                        </xsl:element>
                        <xsl:element name="cat:versionNumber">
                            <xsl:attribute name="gco:nilReason">missing</xsl:attribute>
                        </xsl:element>
                        <xsl:choose>
                            <xsl:when test="./gmd:featureCatalogueCitation/gmd:CI_Citation/gmd:date/gmd:CI_Date/gmd:date/gcoold:Date">
                                <xsl:element name="cat:versionDate">
                                    <xsl:element name="gco:Date">
                                        <xsl:copy-of select="./gmd:featureCatalogueCitation/gmd:CI_Citation/gmd:date/gmd:CI_Date/gmd:date/gcoold:Date/text()" />
                                    </xsl:element>
                                </xsl:element>
                            </xsl:when>
                            <xsl:otherwise>
                                <xsl:element name="cat:versionDate">
                                    <xsl:attribute name="gco:nilReason">missing</xsl:attribute>
                                </xsl:element>
                            </xsl:otherwise>
                        </xsl:choose>
                        <xsl:element name="gfc:producer" >
                            <xsl:attribute name="gco:nilReason">missing</xsl:attribute>
                        </xsl:element>
                        <xsl:apply-templates select="oldche:class/oldche:CHE_MD_Class" mode="from19139to19115-3.2018-catalog"/>
                    </xsl:element>
                </xsl:element>
            </xsl:element>
        </xsl:element>
    </xsl:template>

    <xsl:template match="oldche:CHE_MD_Class" mode="from19139to19115-3.2018-catalog">
        <xsl:element name="gfc:featureType">
            <xsl:element name="gfc:FC_FeatureType">
                <xsl:element name="gfc:typeName">
                    <xsl:copy-of select="./oldche:name/gcoold:CharacterString/text()" />
                </xsl:element>
                <xsl:call-template name="writeCharacterStringElement">
                    <xsl:with-param name="elementName" select="'gfc:definition'"/>
                    <xsl:with-param name="nodeWithStringToWrite" select="./oldche:description"/>
                </xsl:call-template>
                <xsl:element name="gfc:isAbstract" >
                    <xsl:attribute name="gco:nilReason">missing</xsl:attribute>
                </xsl:element>
                <xsl:apply-templates select="./oldche:attribute" mode="from19139to19115-3.2018-catalog" />
                <xsl:element name="gfc:featureCatalogue" >
                    <xsl:attribute name="gco:nilReason">missing</xsl:attribute>
                </xsl:element>
            </xsl:element>
        </xsl:element>
    </xsl:template>

    <xsl:template match="oldche:attribute" mode="from19139to19115-3.2018-catalog">
        <xsl:element name="gfc:carrierOfCharacteristics">
            <xsl:element name="gfc:FC_FeatureAttribute">
                <xsl:element name="gfc:memberName">
                    <xsl:copy-of select="./oldche:name/gcoold:CharacterString/text()" />
                </xsl:element>
                <xsl:call-template name="writeCharacterStringElement">
                    <xsl:with-param name="elementName" select="'gfc:definition'"/>
                    <xsl:with-param name="nodeWithStringToWrite" select="./oldche:description"/>
                </xsl:call-template>
                <xsl:element name="gfc:cardinality">
                    <xsl:attribute name="gco:nilReason">missing</xsl:attribute>
                </xsl:element>
                <xsl:if test="./oldche:anonymousType/oldche:CHE_MD_Type/oldche:type/gcoold:CharacterString/text()">
                    <xsl:element name="gfc:valueType">
                        <xsl:element name="gco:TypeName">
                            <xsl:element name="gco:aName">
                                <xsl:element name="gco:CharacterString">
                                    <xsl:copy-of select="./oldche:anonymousType/oldche:CHE_MD_Type/oldche:type/gcoold:CharacterString/text()" />
                                </xsl:element>
                            </xsl:element>
                        </xsl:element>
                    </xsl:element>
                </xsl:if>
            </xsl:element>
        </xsl:element>
    </xsl:template>

</xsl:stylesheet>