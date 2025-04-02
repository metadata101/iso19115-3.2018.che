<xsl:stylesheet version="2.0"
                xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
                xmlns:gmd="http://www.isotc211.org/2005/gmd"
                xmlns:che="http://geocat.ch/che"
                exclude-result-prefixes="#all">

    <xsl:template match="gmd:topicCategory[.//gmd:MD_TopicCategoryCode[contains(.,'_')]]" mode="from19139to19115-3.2018">
        <xsl:element name="che:subTopicCategory">
            <xsl:element name="che:CHE_MD_SubTopicCategoryCode">
                <xsl:attribute name="codeList">subTopicCategory</xsl:attribute>
                <xsl:attribute name="codeListValue" select="."/>
            </xsl:element>
        </xsl:element>
    </xsl:template>
</xsl:stylesheet>