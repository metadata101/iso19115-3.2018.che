<?xml version="1.0" encoding="UTF-8"?>
<!-- eCH0271 → ISO 19115-3:2018 CHE extent mapping
     Transforms: EX_Extent, EX_GeographicBoundingBox -->
<xsl:stylesheet version="2.0"
  xmlns:xsl  ="http://www.w3.org/1999/XSL/Transform"
  xmlns:xs   ="http://www.w3.org/2001/XMLSchema"
  xmlns:ili  ="http://www.interlis.ch/xtf/2.4/INTERLIS"
  xmlns:eCH0271="http://www.interlis.ch/xtf/2.4/eCH0271"
  xmlns:Localisation_V2="http://www.interlis.ch/xtf/2.4/Localisation_V2"
  xmlns:f271 ="urn:ech0271-functions"
  xmlns:gex  ="http://standards.iso.org/iso/19115/-3/gex/1.0"
  xmlns:gco  ="http://standards.iso.org/iso/19115/-3/gco/1.0"
  xmlns:xsi  ="http://www.w3.org/2001/XMLSchema-instance"
  exclude-result-prefixes="#all">

  <!-- ================================================================
       Mode-based EX_Extent template for CHE_MD_DataIdentification
       Direct processing of EX_Extent element
       ================================================================ -->
  <xsl:template match="eCH0271:EX_Extent" mode="extent">
    <gex:EX_Extent>
      <!-- description -->
      <xsl:if test="eCH0271:description">
        <gex:description>
          <xsl:apply-templates select="eCH0271:description" mode="multilingual-text"/>
        </gex:description>
      </xsl:if>

      <!-- geographicElement -->
      <xsl:for-each select="f271:related(., 'EX_GeographicBoundingBox', 'geographicElement', 'EX_Extent')">
        <gex:geographicElement>
          <xsl:apply-templates select="." mode="geographic-bbox"/>
        </gex:geographicElement>
      </xsl:for-each>
    </gex:EX_Extent>
  </xsl:template>

  <!-- ================================================================
       EX_GeographicBoundingBox element processing
       ================================================================ -->
  <xsl:template match="eCH0271:EX_GeographicBoundingBox" mode="geographic-bbox">
    <gex:EX_GeographicBoundingBox>
      <!-- extentTypeCode (optional) -->
      <xsl:if test="normalize-space(eCH0271:extentTypeCode) != ''">
        <gex:extentTypeCode>
          <gco:Boolean>
            <xsl:value-of select="normalize-space(eCH0271:extentTypeCode)"/>
          </gco:Boolean>
        </gex:extentTypeCode>
      </xsl:if>

      <!-- westBoundLongitude -->
      <xsl:variable name="west" select="normalize-space(eCH0271:westBoundLongitude)"/>
      <xsl:if test="$west != ''">
        <gex:westBoundLongitude>
          <gco:Decimal>
            <xsl:value-of select="$west"/>
          </gco:Decimal>
        </gex:westBoundLongitude>
      </xsl:if>

      <!-- eastBoundLongitude -->
      <xsl:variable name="east" select="normalize-space(eCH0271:eastBoundLongitude)"/>
      <xsl:if test="$east != ''">
        <gex:eastBoundLongitude>
          <gco:Decimal>
            <xsl:value-of select="$east"/>
          </gco:Decimal>
        </gex:eastBoundLongitude>
      </xsl:if>

      <!-- southBoundLatitude -->
      <xsl:variable name="south" select="normalize-space(eCH0271:southBoundLatitude)"/>
      <xsl:if test="$south != ''">
        <gex:southBoundLatitude>
          <gco:Decimal>
            <xsl:value-of select="$south"/>
          </gco:Decimal>
        </gex:southBoundLatitude>
      </xsl:if>

      <!-- northBoundLatitude -->
      <xsl:variable name="north" select="normalize-space(eCH0271:northBoundLatitude)"/>
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
