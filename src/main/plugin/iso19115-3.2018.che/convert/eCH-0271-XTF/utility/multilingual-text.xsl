<?xml version="1.0" encoding="UTF-8"?>
<!-- eCH-0271-XTF → ISO 19115-3:2018 CHE: Multilingual text handling utilities
     Converts INTERLIS Multilingual(M)Text / MultilingualUri structures to
     gco:CharacterString + lan:PT_FreeText
     XSLT 2.0, Saxon HE 9.1+ compatible -->
<xsl:stylesheet version="2.0"
  xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
  xmlns:xs="http://www.w3.org/2001/XMLSchema"
  xmlns:ili="http://www.interlis.ch/xtf/2.4/INTERLIS"
  xmlns:eCH0271_1="http://www.interlis.ch/xtf/2.4/eCH0271_1"
  xmlns:gco="http://standards.iso.org/iso/19115/-3/gco/1.0"
  xmlns:lan="http://standards.iso.org/iso/19115/-3/lan/1.0"
  xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"
  exclude-result-prefixes="#all">

  <!-- Metadata default language (e.g. 'de'), used to fill gco:CharacterString -->
  <xsl:variable name="mdDefaultLanguage" as="xs:string"
    select="lower-case(normalize-space((/ili:transfer/ili:datasection/eCH0271_1:eCH0271/
      eCH0271_1:CHE_MD_Metadata/eCH0271_1:defaultLocale/eCH0271_1:PT_Locale/eCH0271_1:language)[1]))"/>

  <!-- ================================================================
       Multilingual text mode template
       Localised entries are matched by structure (an element holding a
       Language and a Text child) whatever their namespace (Localisation_V2,
       LocalisationCH_V2, ...) or wrapper (MultilingualText, MultilingualMText,
       MultilingualUri, eCH0271_1:MultilingualMText).
       - no localised entry: plain gco:CharacterString
       - only the default language: plain gco:CharacterString
       - otherwise: gco:CharacterString (default language) + lan:PT_FreeText
       Must be applied first inside the ISO property element, since it may
       add the xsi:type attribute to it.
       ================================================================ -->
  <xsl:template match="*" mode="multilingual-text">
    <xsl:variable name="entries"
      select=".//*[*[local-name() = 'Language'] and *[local-name() = 'Text']]
                  [normalize-space(*[local-name() = 'Text']) != '']"/>
    <xsl:variable name="defaultEntry"
      select="($entries[lower-case(normalize-space(*[local-name() = 'Language'])) = $mdDefaultLanguage],
               $entries)[1]"/>

    <xsl:choose>
      <xsl:when test="not($entries)">
        <gco:CharacterString>
          <xsl:value-of select="normalize-space(.)"/>
        </gco:CharacterString>
      </xsl:when>
      <xsl:otherwise>
        <xsl:variable name="isMultilingual"
          select="exists($entries[lower-case(normalize-space(*[local-name() = 'Language'])) != $mdDefaultLanguage])"/>
        <xsl:if test="$isMultilingual">
          <!-- lan prefix must be in scope where the xsi:type QName is used -->
          <xsl:namespace name="lan" select="'http://standards.iso.org/iso/19115/-3/lan/1.0'"/>
          <xsl:attribute name="xsi:type" select="'lan:PT_FreeText_PropertyType'"/>
        </xsl:if>
        <gco:CharacterString>
          <xsl:value-of select="normalize-space($defaultEntry/*[local-name() = 'Text'])"/>
        </gco:CharacterString>
        <xsl:if test="$isMultilingual">
          <lan:PT_FreeText>
            <xsl:for-each select="$entries">
              <lan:textGroup>
                <lan:LocalisedCharacterString
                  locale="#{upper-case(normalize-space(*[local-name() = 'Language']))}">
                  <xsl:value-of select="normalize-space(*[local-name() = 'Text'])"/>
                </lan:LocalisedCharacterString>
              </lan:textGroup>
            </xsl:for-each>
          </lan:PT_FreeText>
        </xsl:if>
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
