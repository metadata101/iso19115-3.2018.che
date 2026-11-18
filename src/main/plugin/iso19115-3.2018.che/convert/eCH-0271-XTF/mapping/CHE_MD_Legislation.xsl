<?xml version="1.0" encoding="UTF-8"?>
<!-- eCH0271 → ISO 19115-3:2018 CHE legislation mapping
     Swiss-specific: CHE_MD_Legislation (legal framework), country, type, language, title, internalReference -->
<xsl:stylesheet version="2.0"
  xmlns:xsl  ="http://www.w3.org/1999/XSL/Transform"
  xmlns:xs   ="http://www.w3.org/2001/XMLSchema"
  xmlns:ili  ="http://www.interlis.ch/xtf/2.4/INTERLIS"
  xmlns:eCH0271="http://www.interlis.ch/xtf/2.4/eCH0271"
  xmlns:f271 ="urn:ech0271-functions"
  xmlns:che  ="http://geocat.ch/che"
  xmlns:cit  ="http://standards.iso.org/iso/19115/-3/cit/2.0"
  xmlns:gco  ="http://standards.iso.org/iso/19115/-3/gco/1.0"
  xmlns:lan  ="http://standards.iso.org/iso/19115/-3/lan/1.0"
  xmlns:mcc  ="http://standards.iso.org/iso/19115/-3/mcc/1.0"
  xmlns:xsi  ="http://www.w3.org/2001/XMLSchema-instance"
  exclude-result-prefixes="#all">

  <!-- NOTE: $CL variable is defined in the parent stylesheet (fromECH0271-XTF.xsl) -->
  <!-- Do not redefine it here to avoid XSLT duplicate global variable error -->

  <!-- CHE_MD_Legislation -->
  <xsl:template name="f271:CHE_MD_Legislation">
    <xsl:param name="legisRecord" as="element()"/>
    <xsl:param name="basket"      as="element()"/>

    <che:CHE_MD_Legislation>
      <!-- country (ISO 3166) -->
      <xsl:if test="normalize-space($legisRecord/eCH0271:country) != ''">
        <che:country>
          <lan:CountryCode codeList="{$CL}CountryCode" codeListValue="{normalize-space($legisRecord/eCH0271:country)}"/>
        </che:country>
      </xsl:if>

      <!-- legislationType (cantonal, federal, international) -->
      <xsl:if test="normalize-space($legisRecord/eCH0271:legislationType) != ''">
        <che:legislationType>
          <che:CHE_CI_LegislationTypeCode codeList="legislationCode" codeListValue="{normalize-space($legisRecord/eCH0271:legislationType)}"/>
        </che:legislationType>
      </xsl:if>

      <!-- internalReference (e.g., BLV 740.24) -->
      <xsl:if test="normalize-space($legisRecord/eCH0271:internalReference) != ''">
        <che:internalReference>
          <gco:CharacterString>
            <xsl:value-of select="normalize-space($legisRecord/eCH0271:internalReference)"/>
          </gco:CharacterString>
        </che:internalReference>
      </xsl:if>

      <!-- language (ISO 639-2/T) -->
      <xsl:if test="normalize-space($legisRecord/eCH0271:language) != ''">
        <che:language>
          <mcc:MD_LanguageCode codeList="{$CL}MD_LanguageCode"
            codeListValue="{normalize-space($legisRecord/eCH0271:language)}">
            <xsl:value-of select="normalize-space($legisRecord/eCH0271:language)"/>
          </mcc:MD_LanguageCode>
        </che:language>
      </xsl:if>

      <!-- legislationCitation via CHE_MD_LegislationlegislationCitation association -->
      <xsl:variable name="legTID" select="$legisRecord/@ili:tid"/>
      <!-- Priority 1: Check association table -->
      <xsl:variable name="citAssoc" select="/ili:transfer/ili:datasection/eCH0271:eCH0271/eCH0271:CHE_MD_LegislationlegislationCitation
                                           [eCH0271:CHE_MD_Legislation/@ili:ref = $legTID]"/>
      <xsl:choose>
        <xsl:when test="$citAssoc">
          <xsl:variable name="citRef" select="$citAssoc/eCH0271:legislationCitation/@ili:ref"/>
          <xsl:variable name="citRecord" select="key('byTID', $citRef)"/>
          <xsl:if test="$citRecord/self::eCH0271:CI_Citation">
            <che:legislationCitation>
              <xsl:apply-templates select="$citRecord" mode="citation"/>
            </che:legislationCitation>
          </xsl:if>
        </xsl:when>
        <!-- Priority 2: Direct TID search (commented reference case) -->
        <xsl:when test="//eCH0271:CI_Citation[@ili:tid='legislation-citation-001']">
          <xsl:variable name="citRecord" select="//eCH0271:CI_Citation[@ili:tid='legislation-citation-001']"/>
          <che:legislationCitation>
            <xsl:apply-templates select="$citRecord" mode="citation"/>
          </che:legislationCitation>
        </xsl:when>
      </xsl:choose>
    </che:CHE_MD_Legislation>
  </xsl:template>

</xsl:stylesheet>
