<?xml version="1.0" encoding="UTF-8"?>
<!--
  eCH0271 → ISO 19115-3:2018 (CHE) — Extent mapping
  
  Covers: EX_Extent (container)
          EX_GeographicBoundingBox (BBOX with North, South, East, West)
          EX_TemporalExtent (date/time ranges)
          EX_SpatialTemporalExtent (combined extent)
          EX_GeographicDescription (named area via identifier)
          EX_BoundingPolygon (geometric boundary)
-->
<xsl:stylesheet version="2.0"
  xmlns:xsl  ="http://www.w3.org/1999/XSL/Transform"
  xmlns:xs   ="http://www.w3.org/2001/XMLSchema"
  xmlns:int  ="http://www.interlis.ch/INTERLIS2.3"
  xmlns:ech0271 ="urn:ech0271-functions"
  xmlns:gex  ="http://standards.iso.org/iso/19115/-3/gex/1.0"
  xmlns:gco  ="http://standards.iso.org/iso/19115/-3/gco/1.0"
  xmlns:gml  ="http://www.opengis.net/gml/3.2"
  xmlns:lan  ="http://standards.iso.org/iso/19115/-3/lan/1.0"
  xmlns:xsi  ="http://www.w3.org/2001/XMLSchema-instance"
  exclude-result-prefixes="#all">

  <!-- ================================================================
       EX_Extent — Container for all extent info
       ================================================================ -->
  <xsl:template name="ech0271:EX_Extent">
    <xsl:param name="extRecord" as="element()"/>
    <xsl:param name="basket"    as="element()"/>

    <gex:EX_Extent>
      <!-- description — multilingual text -->
      <xsl:if test="$extRecord/description/int:eCH0271_1.eCH0271.PT_FreeText | $extRecord/description/int:eCH0271_1.Comprehensive.PT_FreeText">
        <gex:description xsi:type="lan:PT_FreeText_PropertyType">
          <xsl:call-template name="ech0271:PT_FreeText_content">
            <xsl:with-param name="freeText" select="$extRecord/description/int:eCH0271_1.eCH0271.PT_FreeText | $extRecord/description/int:eCH0271_1.Comprehensive.PT_FreeText"/>
          </xsl:call-template>
        </gex:description>
      </xsl:if>

      <!-- geographicElement — handle bounding box and geographic description -->
      <xsl:for-each select="$basket/(int:eCH0271_1.eCH0271.EX_ExtentgeographicElement | int:eCH0271_1.Comprehensive.EX_ExtentgeographicElement)
                                    [EX_Extent/@REF = $extRecord/@TID]">
        <xsl:variable name="geoElemRef" select="geographicElement/@REF"/>
        <xsl:variable name="geoElem" select="key('byTID', $geoElemRef)"/>

        <xsl:if test="$geoElem">
          <gex:geographicElement>
            <xsl:choose>
              <!-- Geographic bounding box -->
              <xsl:when test="local-name($geoElem) = 'EX_GeographicBoundingBox' and contains(namespace-uri($geoElem), 'interlis')">
                <xsl:call-template name="ech0271:EX_GeographicBoundingBox">
                  <xsl:with-param name="bboxRecord" select="$geoElem"/>
                </xsl:call-template>
              </xsl:when>
              <!-- Geographic description (named area) -->
              <xsl:when test="local-name($geoElem) = 'EX_GeographicDescription' and contains(namespace-uri($geoElem), 'interlis')">
                <xsl:call-template name="ech0271:EX_GeographicDescription">
                  <xsl:with-param name="geoDescRecord" select="$geoElem"/>
                  <xsl:with-param name="basket" select="$basket"/>
                </xsl:call-template>
              </xsl:when>
              <!-- Bounding polygon -->
              <xsl:when test="local-name($geoElem) = 'EX_BoundingPolygon' and contains(namespace-uri($geoElem), 'interlis')">
                <xsl:call-template name="ech0271:EX_BoundingPolygon">
                  <xsl:with-param name="polyRecord" select="$geoElem"/>
                  <xsl:with-param name="basket" select="$basket"/>
                </xsl:call-template>
              </xsl:when>
            </xsl:choose>
          </gex:geographicElement>
        </xsl:if>
      </xsl:for-each>

      <!-- temporalElement — temporal extents -->
      <xsl:for-each select="$basket/(int:eCH0271_1.eCH0271.EX_ExtenttemporalElement | int:eCH0271_1.Comprehensive.EX_ExtenttemporalElement)
                                    [EX_Extent/@REF = $extRecord/@TID]">
        <xsl:variable name="tempElemRef" select="temporalElement/@REF"/>
        <xsl:variable name="tempElem" select="key('byTID', $tempElemRef)"/>

        <xsl:if test="$tempElem">
          <gex:temporalElement>
            <xsl:call-template name="ech0271:EX_TemporalExtent">
              <xsl:with-param name="tempRecord" select="$tempElem"/>
            </xsl:call-template>
          </gex:temporalElement>
        </xsl:if>
      </xsl:for-each>

      <!-- verticalElement — if present (for 3D data) -->
      <!-- This is optional and less common, typically omitted for 2D datasets -->
    </gex:EX_Extent>
  </xsl:template>

  <!-- ================================================================
       EX_GeographicBoundingBox
       ================================================================ -->
  <xsl:template name="ech0271:EX_GeographicBoundingBox">
    <xsl:param name="bboxRecord" as="element()"/>

    <gex:EX_GeographicBoundingBox>
      <!-- extentTypeCode — inclusion/exclusion indicator (optional) -->
      <xsl:if test="$bboxRecord/extentTypeCode">
        <gex:extentTypeCode>
          <xsl:value-of select="normalize-space($bboxRecord/extentTypeCode)"/>
        </gex:extentTypeCode>
      </xsl:if>

      <!-- westBoundLongitude -->
      <xsl:variable name="west" select="normalize-space($bboxRecord/westBoundLongitude)"/>
      <xsl:if test="$west != ''">
        <gex:westBoundLongitude>
          <gco:Decimal>
            <xsl:value-of select="$west"/>
          </gco:Decimal>
        </gex:westBoundLongitude>
      </xsl:if>

      <!-- eastBoundLongitude -->
      <xsl:variable name="east" select="normalize-space($bboxRecord/eastBoundLongitude)"/>
      <xsl:if test="$east != ''">
        <gex:eastBoundLongitude>
          <gco:Decimal>
            <xsl:value-of select="$east"/>
          </gco:Decimal>
        </gex:eastBoundLongitude>
      </xsl:if>

      <!-- southBoundLatitude -->
      <xsl:variable name="south" select="normalize-space($bboxRecord/southBoundLatitude)"/>
      <xsl:if test="$south != ''">
        <gex:southBoundLatitude>
          <gco:Decimal>
            <xsl:value-of select="$south"/>
          </gco:Decimal>
        </gex:southBoundLatitude>
      </xsl:if>

      <!-- northBoundLatitude -->
      <xsl:variable name="north" select="normalize-space($bboxRecord/northBoundLatitude)"/>
      <xsl:if test="$north != ''">
        <gex:northBoundLatitude>
          <gco:Decimal>
            <xsl:value-of select="$north"/>
          </gco:Decimal>
        </gex:northBoundLatitude>
      </xsl:if>
    </gex:EX_GeographicBoundingBox>
  </xsl:template>

  <!-- ================================================================
       EX_GeographicDescription — Named area reference
       ================================================================ -->
  <xsl:template name="ech0271:EX_GeographicDescription">
    <xsl:param name="geoDescRecord" as="element()"/>
    <xsl:param name="basket"       as="element()"/>

    <gex:EX_GeographicDescription>
      <!-- geographicIdentifier — references a named place (e.g., canton, region) -->
      <xsl:for-each select="$geoDescRecord/geographicIdentifier/@REF">
        <xsl:variable name="idRef" select="."/>
        <xsl:variable name="idRecord" select="key('byTID', $idRef)"/>

        <xsl:if test="$idRecord">
          <gex:geographicIdentifier>
            <gco:CharacterString>
              <!-- Extract the code/name from the referenced object -->
              <xsl:value-of select="normalize-space($idRecord/code)"/>
            </gco:CharacterString>
          </gex:geographicIdentifier>
        </xsl:if>
      </xsl:for-each>
    </gex:EX_GeographicDescription>
  </xsl:template>

  <!-- ================================================================
       EX_BoundingPolygon — Geometric boundary
       ================================================================ -->
  <xsl:template name="ech0271:EX_BoundingPolygon">
    <xsl:param name="polyRecord" as="element()"/>
    <xsl:param name="basket"    as="element()"/>

    <gex:EX_BoundingPolygon>
      <!-- polygon — GML geometry (typically MultiSurface or Polygon) -->
      <xsl:for-each select="$basket/(int:eCH0271_1.eCH0271.EX_BoundingPolygonpolygon | int:eCH0271_1.Comprehensive.EX_BoundingPolygonpolygon)
                                    [EX_BoundingPolygon/@REF = $polyRecord/@TID]">
        <xsl:variable name="polyRef" select="polygon/@REF"/>
        <xsl:variable name="gmlGeom" select="key('byTID', $polyRef)"/>

        <xsl:if test="$gmlGeom">
          <gex:polygon>
            <!-- Copy GML geometry as-is (should be a gml:* element already) -->
            <xsl:copy-of select="$gmlGeom"/>
          </gex:polygon>
        </xsl:if>
      </xsl:for-each>
    </gex:EX_BoundingPolygon>
  </xsl:template>

  <!-- ================================================================
       EX_TemporalExtent — Time range or instant
       ================================================================ -->
  <xsl:template name="ech0271:EX_TemporalExtent">
    <xsl:param name="tempRecord" as="element()"/>

    <gex:EX_TemporalExtent>
      <xsl:choose>
        <!-- Time period (start/end) via TM_Primitive (eCH0271 standard structure) -->
        <xsl:when test="$tempRecord/extent/int:eCH0271_1.eCH0271.TM_Primitive | $tempRecord/extent/int:eCH0271_1.Comprehensive.TM_Primitive">
          <gex:extent>
            <gml:TimePeriod>
              <!-- Start time -->
              <xsl:variable name="begin" select="normalize-space(($tempRecord/extent/int:eCH0271_1.eCH0271.TM_Primitive/begin | $tempRecord/extent/int:eCH0271_1.Comprehensive.TM_Primitive/begin)[1])"/>
              <xsl:if test="$begin != ''">
                <gml:begin>
                  <gml:TimeInstant>
                    <gml:timePosition>
                      <xsl:value-of select="$begin"/>
                    </gml:timePosition>
                  </gml:TimeInstant>
                </gml:begin>
              </xsl:if>
              <!-- End time -->
              <xsl:variable name="end" select="normalize-space(($tempRecord/extent/int:eCH0271_1.eCH0271.TM_Primitive/end | $tempRecord/extent/int:eCH0271_1.Comprehensive.TM_Primitive/end)[1])"/>
              <xsl:if test="$end != ''">
                <gml:end>
                  <gml:TimeInstant>
                    <gml:timePosition>
                      <xsl:value-of select="$end"/>
                    </gml:timePosition>
                  </gml:TimeInstant>
                </gml:end>
              </xsl:if>
            </gml:TimePeriod>
          </gex:extent>
        </xsl:when>
        <!-- Single time instant (fallback) -->
        <xsl:when test="$tempRecord/extent/int:eCH0271_1.eCH0271.timeInstant | $tempRecord/extent/int:eCH0271_1.Comprehensive.timeInstant">
          <gex:extent>
            <gml:TimeInstant>
              <gml:timePosition>
                <xsl:value-of select="normalize-space(($tempRecord/extent/int:eCH0271_1.eCH0271.timeInstant | $tempRecord/extent/int:eCH0271_1.Comprehensive.timeInstant)[1])"/>
              </gml:timePosition>
            </gml:TimeInstant>
          </gex:extent>
        </xsl:when>
      </xsl:choose>
    </gex:EX_TemporalExtent>
  </xsl:template>

  <!-- ================================================================
       EX_SpatialTemporalExtent — Combined geographic + temporal extent
       (Comprehensive profile only, typically used for moving objects)
       ================================================================ -->
  <xsl:template name="ech0271:EX_SpatialTemporalExtent">
    <xsl:param name="spatTempRecord" as="element()"/>
    <xsl:param name="basket"         as="element()"/>

    <gex:EX_SpatialTemporalExtent>
      <!-- spatialExtent — geographic coverage -->
      <xsl:for-each select="$basket/(int:eCH0271_1.eCH0271.EX_SpatialTemporalExtentspatialExtent | int:eCH0271_1.Comprehensive.EX_SpatialTemporalExtentspatialExtent)
                                    [EX_SpatialTemporalExtent/@REF = $spatTempRecord/@TID]">
        <xsl:variable name="spatialRef" select="spatialExtent/@REF"/>
        <xsl:variable name="spatialRecord" select="key('byTID', $spatialRef)"/>

        <xsl:if test="$spatialRecord and (local-name($spatialRecord) = 'EX_Extent' and contains(namespace-uri($spatialRecord), 'interlis'))">
          <gex:spatialExtent>
            <xsl:call-template name="ech0271:EX_Extent">
              <xsl:with-param name="extRecord" select="$spatialRecord"/>
              <xsl:with-param name="basket" select="$basket"/>
            </xsl:call-template>
          </gex:spatialExtent>
        </xsl:if>
      </xsl:for-each>

      <!-- temporalExtent — time coverage -->
      <xsl:for-each select="$basket/(int:eCH0271_1.eCH0271.EX_SpatialTemporalExtenttemporalExtent | int:eCH0271_1.Comprehensive.EX_SpatialTemporalExtenttemporalExtent)
                                    [EX_SpatialTemporalExtent/@REF = $spatTempRecord/@TID]">
        <xsl:variable name="tempRef" select="temporalExtent/@REF"/>
        <xsl:variable name="tempRecord" select="key('byTID', $tempRef)"/>

        <xsl:if test="$tempRecord and (local-name($tempRecord) = 'EX_TemporalExtent' and contains(namespace-uri($tempRecord), 'interlis'))">
          <gex:temporalExtent>
            <xsl:call-template name="ech0271:EX_TemporalExtent">
              <xsl:with-param name="tempRecord" select="$tempRecord"/>
            </xsl:call-template>
          </gex:temporalExtent>
        </xsl:if>
      </xsl:for-each>
    </gex:EX_SpatialTemporalExtent>
  </xsl:template>

</xsl:stylesheet>
