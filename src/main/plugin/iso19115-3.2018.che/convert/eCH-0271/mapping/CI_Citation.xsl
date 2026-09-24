<?xml version="1.0" encoding="UTF-8"?>
<!-- eCH-0271 → ISO 19115-3:2018 CHE: CI_Citation mapping
     Handles citation (title + dates) transformation
     XSLT 2.0, Saxon HE 9.1+ compatible -->
<xsl:stylesheet version="2.0"
  xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
  xmlns:xs="http://www.w3.org/2001/XMLSchema"
  xmlns:ili="http://www.interlis.ch/xtf/2.4/INTERLIS"
  xmlns:eCH0271_1="http://www.interlis.ch/xtf/2.4/eCH0271_1"
  xmlns:cit="http://standards.iso.org/iso/19115/-3/cit/2.0"
  xmlns:gco="http://standards.iso.org/iso/19115/-3/gco/1.0"
  exclude-result-prefixes="#all">

  <!-- ================================================================
       citation: CI_Citation reference resolver
       Resolves eCH0271_1:citation[@ili:ref] to CI_Citation object
       ================================================================ -->
  <xsl:template match="eCH0271_1:citation[@ili:ref]" mode="citation">
    <xsl:variable name="citationId" select="@ili:ref"/>
    <xsl:variable name="citationObj" select="key('byTID', $citationId)"/>
    
    <xsl:if test="$citationObj/self::eCH0271_1:CI_Citation">
      <cit:CI_Citation>
        <xsl:if test="$citationObj/eCH0271_1:title">
          <cit:title>
            <xsl:apply-templates select="$citationObj/eCH0271_1:title" mode="multilingual-text"/>
          </cit:title>
        </xsl:if>
        <!-- Handle citation dates via absolute XPath lookup -->
        <xsl:if test="$citationObj/eCH0271_1:date[@ili:ref]">
          <xsl:variable name="dateRef" select="$citationObj/eCH0271_1:date/@ili:ref"/>
          <xsl:variable name="dateObj" select="/ili:transfer/ili:datasection/eCH0271_1:eCH0271/eCH0271_1:CI_Date[@ili:tid=$dateRef]"/>
          <xsl:if test="$dateObj/self::eCH0271_1:CI_Date">
            <cit:date>
              <cit:CI_Date>
                <xsl:if test="normalize-space($dateObj/eCH0271_1:date) != ''">
                  <cit:date>
                    <gco:Date>
                      <xsl:value-of select="substring(normalize-space($dateObj/eCH0271_1:date), 1, 10)"/>
                    </gco:Date>
                  </cit:date>
                </xsl:if>
                <xsl:if test="$dateObj/eCH0271_1:dateType">
                  <cit:dateType>
                    <xsl:call-template name="date-type-code">
                      <xsl:with-param name="value" select="normalize-space($dateObj/eCH0271_1:dateType)"/>
                    </xsl:call-template>
                  </cit:dateType>
                </xsl:if>
              </cit:CI_Date>
            </cit:date>
          </xsl:if>
        </xsl:if>
      </cit:CI_Citation>
    </xsl:if>
  </xsl:template>

  <!-- ================================================================
       citation: CI_Citation (direct - fallback for inline citations)
       ================================================================ -->
  <xsl:template match="eCH0271_1:CI_Citation" mode="citation">
    <cit:CI_Citation>
      <xsl:if test="eCH0271_1:title">
        <cit:title>
          <xsl:apply-templates select="eCH0271_1:title" mode="multilingual-text"/>
        </cit:title>
      </xsl:if>
      <!-- Handle citation dates via absolute XPath lookup -->
      <xsl:if test="eCH0271_1:date[@ili:ref]">
        <xsl:variable name="dateRef" select="eCH0271_1:date/@ili:ref"/>
        <xsl:variable name="dateObj" select="/ili:transfer/ili:datasection/eCH0271_1:eCH0271/eCH0271_1:CI_Date[@ili:tid=$dateRef]"/>
        <xsl:if test="$dateObj/self::eCH0271_1:CI_Date">
          <cit:date>
            <cit:CI_Date>
              <xsl:if test="normalize-space($dateObj/eCH0271_1:date) != ''">
                <cit:date>
                  <gco:Date>
                    <xsl:value-of select="substring(normalize-space($dateObj/eCH0271_1:date), 1, 10)"/>
                  </gco:Date>
                </cit:date>
              </xsl:if>
              <xsl:if test="$dateObj/eCH0271_1:dateType">
                <cit:dateType>
                  <xsl:call-template name="date-type-code">
                    <xsl:with-param name="value" select="normalize-space($dateObj/eCH0271_1:dateType)"/>
                  </xsl:call-template>
                </cit:dateType>
              </xsl:if>
            </cit:CI_Date>
          </cit:date>
        </xsl:if>
      </xsl:if>
    </cit:CI_Citation>
  </xsl:template>

</xsl:stylesheet>
