<?xml version="1.0" encoding="UTF-8"?>
<!-- eCH-0271-XTF → ISO 19115-3:2018 CHE: CI_Date mapping
     Handles date information for citations, extent, etc.
     XSLT 2.0, Saxon HE 9.1+ compatible -->
<xsl:stylesheet version="2.0"
  xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
  xmlns:xs="http://www.w3.org/2001/XMLSchema"
  xmlns:ili="http://www.interlis.ch/xtf/2.4/INTERLIS"
  xmlns:eCH0271="http://www.interlis.ch/xtf/2.4/eCH0271"
  xmlns:cit="http://standards.iso.org/iso/19115/-3/cit/2.0"
  xmlns:gco="http://standards.iso.org/iso/19115/-3/gco/1.0"
  exclude-result-prefixes="#all">

  <!-- ================================================================
       CI_Date: Extract date and type from eCH0271 structure
       Handles both dated element references and direct date processing
       ================================================================ -->
  <xsl:template match="eCH0271:CI_Date" mode="date">
    <xsl:call-template name="format-ci-date">
      <xsl:with-param name="dateObj" select="."/>
    </xsl:call-template>
  </xsl:template>

  <!-- Named template to format CI_Date element -->
  <xsl:template name="format-ci-date">
    <xsl:param name="dateObj" as="element()"/>
    
    <cit:CI_Date>
      <xsl:variable name="dateValue" select="normalize-space($dateObj/eCH0271:date)"/>
      <!-- INTERLIS XMLDateTime: a time at midnight (T00:00:00, T00:00:00.0)
           only pads a date, so output a gco:Date; keep a real time as
           gco:DateTime. cit:date is mandatory: an empty source date is
           marked as missing. -->
      <cit:date>
        <xsl:choose>
          <xsl:when test="$dateValue = ''">
            <xsl:attribute name="gco:nilReason" select="'missing'"/>
          </xsl:when>
          <xsl:when test="contains($dateValue, 'T')
                          and not(matches(substring-after($dateValue, 'T'), '^00:00:00(\.0+)?$'))">
            <gco:DateTime>
              <xsl:value-of select="substring($dateValue, 1, 19)"/>
            </gco:DateTime>
          </xsl:when>
          <xsl:otherwise>
            <gco:Date>
              <xsl:value-of select="substring($dateValue, 1, 10)"/>
            </gco:Date>
          </xsl:otherwise>
        </xsl:choose>
      </cit:date>
      <xsl:if test="$dateObj/eCH0271:dateType">
        <cit:dateType>
          <xsl:call-template name="date-type-code">
            <xsl:with-param name="value" select="normalize-space($dateObj/eCH0271:dateType)"/>
          </xsl:call-template>
        </cit:dateType>
      </xsl:if>
    </cit:CI_Date>
  </xsl:template>

</xsl:stylesheet>
