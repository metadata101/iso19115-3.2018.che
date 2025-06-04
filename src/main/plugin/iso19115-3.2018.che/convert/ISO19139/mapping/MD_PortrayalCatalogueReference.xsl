<xsl:stylesheet version="2.0"
                xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
                xmlns:gco="http://standards.iso.org/iso/19115/-3/gco/1.0"
                xmlns:mpc="http://standards.iso.org/iso/19115/-3/mpc/1.0"
                xmlns:cit="http://standards.iso.org/iso/19115/-3/cit/2.0"
                xmlns:oldche="http://www.geocat.ch/2008/che"
                xmlns:gmd="http://www.isotc211.org/2005/gmd"
                xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"
                exclude-result-prefixes="#all">

    <xsl:template match="oldche:CHE_MD_PortrayalCatalogueReference" mode="from19139to19115-3.2018">
        <xsl:element name="mpc:MD_PortrayalCatalogueReference">
            <xsl:if test="gmd:portrayalCatalogueCitation|oldche:portrayalCatalogueURL">
                <xsl:element name="mpc:portrayalCatalogueCitation">
                    <xsl:element name="cit:CI_Citation">
                        <xsl:apply-templates select="gmd:portrayalCatalogueCitation/*/*" mode="from19139to19115-3.2018"/>
                        <xsl:if test="oldche:portrayalCatalogueURL">
                            <xsl:element name="cit:onlineResource">
                                <xsl:element name="cit:CI_OnlineResource">
                                    <xsl:element name="cit:linkage">
                                        <xsl:attribute name="xsi:type" select="'lan:PT_FreeText_PropertyType'"/>
                                        <gco:CharacterString><xsl:value-of select="oldche:portrayalCatalogueURL/gmd:URL" /></gco:CharacterString>
                                        <xsl:apply-templates select="oldche:portrayalCatalogueURL/oldche:PT_FreeURL" mode="from19139to19115-3.2018"/>
                                    </xsl:element>
                                </xsl:element>
                            </xsl:element>
                        </xsl:if>
                    </xsl:element>
                </xsl:element>
            </xsl:if>
        </xsl:element>
    </xsl:template>
</xsl:stylesheet>