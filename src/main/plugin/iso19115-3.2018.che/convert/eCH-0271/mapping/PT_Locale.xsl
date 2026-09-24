<?xml version="1.0" encoding="UTF-8"?>
<!-- eCH-0271 → ISO 19115-3:2018 CHE: PT_Locale mapping
     Handles language and character encoding information
     XSLT 2.0, Saxon HE 9.1+ compatible -->
<xsl:stylesheet version="2.0"
  xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
  xmlns:xs="http://www.w3.org/2001/XMLSchema"
  xmlns:ili="http://www.interlis.ch/xtf/2.4/INTERLIS"
  xmlns:eCH0271_1="http://www.interlis.ch/xtf/2.4/eCH0271_1"
  xmlns:lan="http://standards.iso.org/iso/19115/-3/lan/1.0"
  xmlns:gco="http://standards.iso.org/iso/19115/-3/gco/1.0"
  exclude-result-prefixes="#all">

  <!-- ================================================================
       defaultLocale processor (metadata level)
       Converts eCH0271_1:PT_Locale to lan:PT_Locale within mdb:defaultLocale
       ================================================================ -->
  <xsl:template match="eCH0271_1:PT_Locale" mode="locale">
    <mdb:defaultLocale xmlns:mdb="http://standards.iso.org/iso/19115/-3/mdb/2.0">
      <lan:PT_Locale>
        <lan:language>
          <xsl:call-template name="language-code">
            <xsl:with-param name="value" select="normalize-space(eCH0271_1:language)"/>
          </xsl:call-template>
        </lan:language>
        <xsl:if test="eCH0271_1:country">
          <lan:country>
            <gco:CharacterString>
              <xsl:value-of select="eCH0271_1:country"/>
            </gco:CharacterString>
          </lan:country>
        </xsl:if>
        <!-- Character encoding: must be present (with nilReason if missing) -->
        <xsl:choose>
          <xsl:when test="eCH0271_1:characterEncoding">
            <lan:characterEncoding>
              <xsl:call-template name="character-set-code">
                <xsl:with-param name="value" select="normalize-space(eCH0271_1:characterEncoding)"/>
              </xsl:call-template>
            </lan:characterEncoding>
          </xsl:when>
          <xsl:otherwise>
            <lan:characterEncoding gco:nilReason="unknown" />
          </xsl:otherwise>
        </xsl:choose>
      </lan:PT_Locale>
    </mdb:defaultLocale>
  </xsl:template>

  <!-- ================================================================
       dataDefaultLocale processor (dataset level - without mdb:defaultLocale wrapper)
       Used within mri:defaultLocale context
       ================================================================ -->
  <xsl:template match="eCH0271_1:PT_Locale" mode="data-locale">
    <lan:PT_Locale>
      <lan:language>
        <xsl:call-template name="language-code">
          <xsl:with-param name="value" select="normalize-space(eCH0271_1:language)"/>
        </xsl:call-template>
      </lan:language>
      <xsl:if test="eCH0271_1:country">
        <lan:country>
          <gco:CharacterString>
            <xsl:value-of select="eCH0271_1:country"/>
          </gco:CharacterString>
        </lan:country>
      </xsl:if>
      <!-- Character encoding: must be present (with nilReason if missing) -->
      <xsl:choose>
        <xsl:when test="eCH0271_1:characterEncoding">
          <lan:characterEncoding>
            <xsl:call-template name="character-set-code">
              <xsl:with-param name="value" select="normalize-space(eCH0271_1:characterEncoding)"/>
            </xsl:call-template>
          </lan:characterEncoding>
        </xsl:when>
        <xsl:otherwise>
          <lan:characterEncoding gco:nilReason="unknown" />
        </xsl:otherwise>
      </xsl:choose>
    </lan:PT_Locale>
  </xsl:template>

</xsl:stylesheet>
