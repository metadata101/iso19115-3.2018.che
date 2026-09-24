<?xml version="1.0" encoding="UTF-8"?>
<!-- eCH0271 → ISO 19115-3:2018 CHE legislation mapping
     Swiss-specific: CHE_MD_Legislation (legal framework), country, type, language, title, internalReference -->
<xsl:stylesheet version="2.0"
  xmlns:xsl  ="http://www.w3.org/1999/XSL/Transform"
  xmlns:xs   ="http://www.w3.org/2001/XMLSchema"
  xmlns:ili  ="http://www.interlis.ch/xtf/2.4/INTERLIS"
  xmlns:eCH0271_1="http://www.interlis.ch/xtf/2.4/eCH0271_1"
  xmlns:ech0271 ="urn:ech0271-functions"
  xmlns:che  ="http://geocat.ch/che"
  xmlns:cit  ="http://standards.iso.org/iso/19115/-3/cit/2.0"
  xmlns:gco  ="http://standards.iso.org/iso/19115/-3/gco/1.0"
  xmlns:lan  ="http://standards.iso.org/iso/19115/-3/lan/1.0"
  xmlns:mcc  ="http://standards.iso.org/iso/19115/-3/mcc/1.0"
  xmlns:xsi  ="http://www.w3.org/2001/XMLSchema-instance"
  exclude-result-prefixes="#all">

  <!-- NOTE: $CL variable is defined in the parent stylesheet (fromGM03.xsl) -->
  <!-- Do not redefine it here to avoid XSLT duplicate global variable error -->

  <!-- CHE_MD_Legislation -->
  <xsl:template name="ech0271:CHE_MD_Legislation">
    <xsl:param name="legisRecord" as="element()"/>
    <xsl:param name="basket"      as="element()"/>

    <che:CHE_MD_Legislation>
      <!-- country (ISO 3166) -->
      <xsl:if test="normalize-space($legisRecord/eCH0271_1:country) != ''">
        <che:country>
          <lan:CountryCode codeList="http://standards.iso.org/iso/19139/resources/gmxCodelists.xml#Country" codeListValue="{normalize-space($legisRecord/eCH0271_1:country)}"/>
        </che:country>
      </xsl:if>

      <!-- legislationType (cantonal, federal, international) -->
      <xsl:if test="normalize-space($legisRecord/eCH0271_1:legislationType) != ''">
        <che:legislationType>
          <che:CHE_CI_LegislationTypeCode codeList="legislationCode" codeListValue="{normalize-space($legisRecord/eCH0271_1:legislationType)}"/>
        </che:legislationType>
      </xsl:if>

      <!-- language (ISO 639-2/T) -->
      <xsl:if test="normalize-space($legisRecord/eCH0271_1:language) != ''">
        <che:language>
          <mcc:MD_LanguageCode codeList="{$CL}MD_LanguageCode"
            codeListValue="{normalize-space($legisRecord/eCH0271_1:language)}">
            <xsl:value-of select="normalize-space($legisRecord/eCH0271_1:language)"/>
          </mcc:MD_LanguageCode>
        </che:language>
      </xsl:if>

      <!-- legislationCitation -->
      <xsl:if test="$legisRecord/eCH0271_1:legislationCitation[@ili:ref]">
        <xsl:variable name="citRef" select="$legisRecord/eCH0271_1:legislationCitation/@ili:ref"/>
        <xsl:variable name="citRecord" select="key('byTID', $citRef)"/>

        <xsl:if test="$citRecord/self::eCH0271_1:CI_Citation">
          <che:legislationCitation>
            <xsl:apply-templates select="$citRecord" mode="citation"/>
          </che:legislationCitation>
        </xsl:if>
      </xsl:if>
    </che:CHE_MD_Legislation>
  </xsl:template>

</xsl:stylesheet>
