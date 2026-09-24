<?xml version="1.0" encoding="UTF-8"?>
<!-- eCH-0271 → ISO 19115-3:2018 CHE: Multilingual text handling utilities
     Converts MultilingualMText and PT_FreeText structures
     XSLT 2.0, Saxon HE 9.1+ compatible -->
<xsl:stylesheet version="2.0"
  xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
  xmlns:xs="http://www.w3.org/2001/XMLSchema"
  xmlns:ili="http://www.interlis.ch/xtf/2.4/INTERLIS"
  xmlns:eCH0271_1="http://www.interlis.ch/xtf/2.4/eCH0271_1"
  xmlns:Localisation_V2="http://www.interlis.ch/xtf/2.4/Localisation_V2"
  xmlns:LocalisationCH_V2="http://www.interlis.ch/xtf/2.4/LocalisationCH_V2"
  xmlns:gco="http://standards.iso.org/iso/19115/-3/gco/1.0"
  xmlns:lan="http://standards.iso.org/iso/19115/-3/lan/1.0"
  exclude-result-prefixes="#all">

  <!-- ================================================================
       Multilingual text mode template
       Handles both simple strings and MultilingualMText structures
       Outputs gco:CharacterString or (future) lan:PT_FreeText
       ================================================================ -->
  <xsl:template match="*" mode="multilingual-text">
    <xsl:choose>
      <!-- eCH0271 MultilingualMText structure -->
      <xsl:when test="eCH0271_1:MultilingualMText">
        <gco:CharacterString>
          <xsl:value-of select="normalize-space(eCH0271_1:MultilingualMText)"/>
        </gco:CharacterString>
      </xsl:when>
      <!-- ISO 19115-3 PT_FreeText structure with LocalisedText (future support) -->
      <xsl:when test="Localisation_V2:MultilingualMText | LocalisationCH_V2:MultilingualMText">
        <!-- Has multi-language content -->
        <xsl:variable name="primary"
          select="(Localisation_V2:MultilingualMText/Localisation_V2:LocalisedText[1] |
                   LocalisationCH_V2:MultilingualMText/LocalisationCH_V2:LocalisedText[1])/
                  (Localisation_V2:LocalisedMText/Localisation_V2:Text |
                   LocalisationCH_V2:LocalisedMText/LocalisationCH_V2:Text)"/>
        <gco:CharacterString>
          <xsl:value-of select="$primary[1]"/>
        </gco:CharacterString>
        <!-- TODO: Add lan:PT_FreeText for additional languages -->
      </xsl:when>
      <xsl:otherwise>
        <!-- Plain text element or attribute -->
        <gco:CharacterString>
          <xsl:value-of select="normalize-space(.)"/>
        </gco:CharacterString>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:template>

  <!-- ================================================================
       Multilingual text mode template - text node variant
       Direct handling of text nodes and string values
       ================================================================ -->
  <xsl:template match="text()" mode="multilingual-text">
    <gco:CharacterString>
      <xsl:value-of select="normalize-space(.)"/>
    </gco:CharacterString>
  </xsl:template>

</xsl:stylesheet>
