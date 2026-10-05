<?xml version="1.0" encoding="UTF-8"?>
<!-- eCH-0271 → ISO 19115-3:2018 CHE: CI_Date mapping
     Handles date information for citations, extent, etc.
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
       CI_Date: Extract date and type from eCH0271 structure
       Handles both dated element references and direct date processing
       ================================================================ -->
  <xsl:template match="eCH0271_1:CI_Date" mode="date">
    <xsl:call-template name="format-ci-date">
      <xsl:with-param name="dateObj" select="."/>
    </xsl:call-template>
  </xsl:template>

  <!-- Named template to format CI_Date element -->
  <xsl:template name="format-ci-date">
    <xsl:param name="dateObj" as="element()"/>
    
    <cit:CI_Date>
      <xsl:if test="$dateObj/eCH0271_1:date">
        <cit:date>
          <xsl:variable name="dateValue" select="normalize-space($dateObj/eCH0271_1:date)"/>
          <!-- Handle both date and datetime formats -->
          <xsl:choose>
            <xsl:when test="contains($dateValue, 'T')">
              <!-- DateTime format (ISO 8601) -->
              <gco:DateTime>
                <xsl:value-of select="substring($dateValue, 1, 19)"/>
              </gco:DateTime>
            </xsl:when>
            <xsl:otherwise>
              <!-- Date format (YYYY-MM-DD) -->
              <gco:Date>
                <xsl:value-of select="$dateValue"/>
              </gco:Date>
            </xsl:otherwise>
          </xsl:choose>
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
  </xsl:template>

</xsl:stylesheet>
