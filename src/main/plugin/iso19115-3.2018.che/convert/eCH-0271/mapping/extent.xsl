<?xml version="1.0" encoding="UTF-8"?>
<!-- eCH0271 → ISO 19115-3:2018 CHE extent mapping
     Transforms: EX_Extent, EX_GeographicBoundingBox -->
<xsl:stylesheet version="2.0"
  xmlns:xsl  ="http://www.w3.org/1999/XSL/Transform"
  xmlns:xs   ="http://www.w3.org/2001/XMLSchema"
  xmlns:ili  ="http://www.interlis.ch/xtf/2.4/INTERLIS"
  xmlns:eCH0271_1="http://www.interlis.ch/xtf/2.4/eCH0271_1"
  xmlns:ech0271 ="urn:ech0271-functions"
  xmlns:gex  ="http://standards.iso.org/iso/19115/-3/gex/1.0"
  xmlns:gco  ="http://standards.iso.org/iso/19115/-3/gco/1.0"
  xmlns:xsi  ="http://www.w3.org/2001/XMLSchema-instance"
  exclude-result-prefixes="#all">

  <!-- EX_Extent -->
  <xsl:template name="ech0271:EX_Extent">
    <xsl:param name="extRecord" as="element()"/>
    <xsl:param name="basket"    as="element()"/>

    <gex:EX_Extent>
      <!-- description -->
      <xsl:if test="normalize-space($extRecord/eCH0271_1:description) != ''">
        <gex:description>
          <gco:CharacterString>
            <xsl:value-of select="normalize-space($extRecord/eCH0271_1:description)"/>
          </gco:CharacterString>
        </gex:description>
      </xsl:if>

      <!-- geographicElement (bounding box references) -->
      <xsl:for-each select="$extRecord/eCH0271_1:geographicElement[@ili:ref]">
        <xsl:variable name="geoElemRef" select="@ili:ref"/>
        <xsl:variable name="geoElem" select="key('byTID', $geoElemRef)"/>

        <xsl:if test="$geoElem/self::eCH0271_1:EX_GeographicBoundingBox">
          <gex:geographicElement>
            <xsl:call-template name="ech0271:EX_GeographicBoundingBox">
              <xsl:with-param name="bboxRecord" select="$geoElem"/>
            </xsl:call-template>
          </gex:geographicElement>
        </xsl:if>
      </xsl:for-each>
    </gex:EX_Extent>
  </xsl:template>

  <!-- EX_GeographicBoundingBox -->
  <xsl:template name="ech0271:EX_GeographicBoundingBox">
    <xsl:param name="bboxRecord" as="element()"/>

    <gex:EX_GeographicBoundingBox>
      <!-- extentTypeCode (optional) -->
      <xsl:if test="normalize-space($bboxRecord/eCH0271_1:extentTypeCode) != ''">
        <gex:extentTypeCode>
          <xsl:value-of select="normalize-space($bboxRecord/eCH0271_1:extentTypeCode)"/>
        </gex:extentTypeCode>
      </xsl:if>

      <!-- westBoundLongitude -->
      <xsl:variable name="west" select="normalize-space($bboxRecord/eCH0271_1:westBoundLongitude)"/>
      <xsl:if test="$west != ''">
        <gex:westBoundLongitude>
          <gco:Decimal>
            <xsl:value-of select="$west"/>
          </gco:Decimal>
        </gex:westBoundLongitude>
      </xsl:if>

      <!-- eastBoundLongitude -->
      <xsl:variable name="east" select="normalize-space($bboxRecord/eCH0271_1:eastBoundLongitude)"/>
      <xsl:if test="$east != ''">
        <gex:eastBoundLongitude>
          <gco:Decimal>
            <xsl:value-of select="$east"/>
          </gco:Decimal>
        </gex:eastBoundLongitude>
      </xsl:if>

      <!-- southBoundLatitude -->
      <xsl:variable name="south" select="normalize-space($bboxRecord/eCH0271_1:southBoundLatitude)"/>
      <xsl:if test="$south != ''">
        <gex:southBoundLatitude>
          <gco:Decimal>
            <xsl:value-of select="$south"/>
          </gco:Decimal>
        </gex:southBoundLatitude>
      </xsl:if>

      <!-- northBoundLatitude -->
      <xsl:variable name="north" select="normalize-space($bboxRecord/eCH0271_1:northBoundLatitude)"/>
      <xsl:if test="$north != ''">
        <gex:northBoundLatitude>
          <gco:Decimal>
            <xsl:value-of select="$north"/>
          </gco:Decimal>
        </gex:northBoundLatitude>
      </xsl:if>
    </gex:EX_GeographicBoundingBox>
  </xsl:template>

</xsl:stylesheet>
