<?xml version="1.0" encoding="UTF-8"?>
<!--
  eCH0271 → ISO 19115-3:2018 (CHE) — Legislation mapping
  
  Swiss-specific extension. Covers:
  - CHE_MD_Legislation (container for legal framework)
  - country (ISO 3166 country code)
  - legislationType (CHE_CI_LegislationCode: cantonal, federal, international)
  - internalReference (reference to legal document)
  - language (ISO 639-2/T language code)
  - title (CI_Citation of the legislation)
  
  Used in metadata constraints to specify applicable laws/regulations.
-->
<xsl:stylesheet version="2.0"
  xmlns:xsl  ="http://www.w3.org/1999/XSL/Transform"
  xmlns:xs   ="http://www.w3.org/2001/XMLSchema"
  xmlns:int  ="http://www.interlis.ch/INTERLIS2.3"
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

  <!-- ================================================================
       CHE_MD_Legislation — Swiss legal framework container
       ================================================================ -->
  <xsl:template name="ech0271:CHE_MD_Legislation">
    <xsl:param name="legisRecord" as="element()"/>
    <xsl:param name="basket"      as="element()"/>

    <che:CHE_MD_Legislation gco:isoType="mcc:MD_LegalConstraints">
      <!-- country — jurisdiction (ISO 3166 country code) -->
      <xsl:for-each select="$legisRecord/int:country/int:CodeISO.CountryCodeISO_[1]/int:value">
        <xsl:variable name="countryCode" select="normalize-space(.)"/>
        <xsl:if test="$countryCode != ''">
          <che:country>
            <mcc:MD_CountryCode codeList="{$CL}MD_CountryCode"
              codeListValue="{$countryCode}">
              <xsl:value-of select="$countryCode"/>
            </mcc:MD_CountryCode>
          </che:country>
        </xsl:if>
      </xsl:for-each>

      <!-- legislationType — type of legislation (cantonal, federal, international) -->
      <xsl:for-each select="$legisRecord/int:legislationType/int:value">
        <xsl:variable name="legisType" select="normalize-space(.)"/>
        <xsl:if test="$legisType != ''">
          <che:legislationType>
            <!-- CHE_CI_LegislationCode is a CHE-specific codelist -->
            <che:CHE_CI_LegislationCode codeList="./resources/codeList.xml#LegislationCode"
              codeListValue="{$legisType}">
              <xsl:value-of select="$legisType"/>
            </che:CHE_CI_LegislationCode>
          </che:legislationType>
        </xsl:if>
      </xsl:for-each>

      <!-- language — language of the legislation -->
      <xsl:for-each select="$legisRecord/int:language/int:CodeISO.LanguageCodeISO_[1]/int:value">
        <xsl:variable name="langCode" select="normalize-space(.)"/>
        <xsl:if test="$langCode != ''">
          <che:language>
            <mcc:MD_LanguageCode codeList="{$CL}MD_LanguageCode"
              codeListValue="{$langCode}">
              <xsl:value-of select="$langCode"/>
            </mcc:MD_LanguageCode>
          </che:language>
        </xsl:if>
      </xsl:for-each>

      <!-- title — citation of the legislative act/regulation -->
      <xsl:for-each select="$legisRecord/int:title/@REF">
        <xsl:variable name="citRef" select="."/>
        <xsl:variable name="citRecord" select="key('byTID', $citRef)"/>

        <xsl:if test="$citRecord">
          <che:title>
            <xsl:call-template name="ech0271:CI_Citation">
              <xsl:with-param name="citTID" select="$citRef"/>
              <xsl:with-param name="basket" select="$basket"/>
            </xsl:call-template>
          </che:title>
        </xsl:if>
      </xsl:for-each>

      <!-- internalReference — optional: reference to internal document ID -->
      <xsl:for-each select="$legisRecord/int:internalReference[normalize-space(.) != '']">
        <che:internalReference>
          <gco:CharacterString>
            <xsl:value-of select="normalize-space(.)"/>
          </gco:CharacterString>
        </che:internalReference>
      </xsl:for-each>
    </che:CHE_MD_Legislation>
  </xsl:template>

</xsl:stylesheet>
