<?xml version="1.0" encoding="UTF-8"?>
<!-- eCH-0271 → ISO 19115-3:2018 CHE: CHE_MD_DataIdentification mapping
     Handles dataset identification: title, abstract, status, contacts, extent, maintenance
     XSLT 2.0, Saxon HE 9.1+ compatible -->
<xsl:stylesheet version="2.0"
  xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
  xmlns:xs="http://www.w3.org/2001/XMLSchema"
  xmlns:ili="http://www.interlis.ch/xtf/2.4/INTERLIS"
  xmlns:eCH0271_1="http://www.interlis.ch/xtf/2.4/eCH0271_1"
  xmlns:Localisation_V2="http://www.interlis.ch/xtf/2.4/Localisation_V2"
  xmlns:che="http://geocat.ch/che"
  xmlns:cit="http://standards.iso.org/iso/19115/-3/cit/2.0"
  xmlns:gco="http://standards.iso.org/iso/19115/-3/gco/1.0"
  xmlns:mcc="http://standards.iso.org/iso/19115/-3/mcc/1.0"
  xmlns:mco="http://standards.iso.org/iso/19115/-3/mco/1.0"
  xmlns:mdb="http://standards.iso.org/iso/19115/-3/mdb/2.0"
  xmlns:mri="http://standards.iso.org/iso/19115/-3/mri/1.0"
  exclude-result-prefixes="#all">

  <!-- ================================================================
       CHE_MD_DataIdentification processor
       Main dataset identification: title, abstract, contacts, extent, maintenance
       ================================================================ -->
  <xsl:template match="eCH0271_1:CHE_MD_DataIdentification" mode="data-id">
    <mdb:identificationInfo>
      <che:CHE_MD_DataIdentification gco:isoType="mri:MD_DataIdentification">
        <!-- Citation (with date resolution) -->
        <xsl:if test="eCH0271_1:citation[@ili:ref]">
          <mri:citation>
            <xsl:apply-templates select="eCH0271_1:citation[@ili:ref]" mode="citation"/>
          </mri:citation>
        </xsl:if>
        
        <!-- Abstract -->
        <xsl:if test="eCH0271_1:abstract">
          <mri:abstract>
            <xsl:apply-templates select="eCH0271_1:abstract" mode="multilingual-text"/>
          </mri:abstract>
        </xsl:if>
        
        <!-- Status -->
        <xsl:if test="eCH0271_1:status">
          <mri:status>
            <mcc:MD_ProgressCode codeList="https://www.isotc211.org/2005/resources/Codelist/gmxCodelists.xml#MD_ProgressCode" codeListValue="{normalize-space(eCH0271_1:status)}">
              <xsl:value-of select="normalize-space(eCH0271_1:status)"/>
            </mcc:MD_ProgressCode>
          </mri:status>
        </xsl:if>
        
        <!-- Point of Contact (dataset-level) - direct ref OR direct object OR via association -->
        <xsl:variable name="currentDataIdentId" select="@ili:tid"/>
        <xsl:choose>
          <!-- Priority 1: Direct reference -->
          <xsl:when test="eCH0271_1:pointOfContact[@ili:ref]">
            <xsl:variable name="pocRef" select="eCH0271_1:pointOfContact/@ili:ref"/>
            <xsl:variable name="pocObj" select="key('byTID', $pocRef)"/>
            <xsl:if test="$pocObj/self::eCH0271_1:CI_Responsibility">
              <mri:pointOfContact>
                <xsl:apply-templates select="$pocObj" mode="responsibility"/>
              </mri:pointOfContact>
            </xsl:if>
          </xsl:when>
          <!-- Priority 2: Direct CI_Responsibility object (commented reference case) -->
          <xsl:when test="//eCH0271_1:CI_Responsibility[@ili:tid='responsibility-001']">
            <xsl:variable name="pocObj" select="//eCH0271_1:CI_Responsibility[@ili:tid='responsibility-001']"/>
            <mri:pointOfContact>
              <xsl:apply-templates select="$pocObj" mode="responsibility"/>
            </mri:pointOfContact>
          </xsl:when>
          <!-- Priority 3: Via association MD_DataIdentificationpointOfContact -->
          <xsl:otherwise>
            <xsl:variable name="pocAssoc" select="/ili:transfer/ili:datasection/eCH0271_1:eCH0271/eCH0271_1:MD_DataIdentificationpointOfContact[@ili:from=$currentDataIdentId]"/>
            <xsl:if test="$pocAssoc">
              <xsl:variable name="pocRef" select="$pocAssoc/@ili:to"/>
              <xsl:variable name="pocObj" select="key('byTID', $pocRef)"/>
              <xsl:if test="$pocObj/self::eCH0271_1:CI_Responsibility">
                <mri:pointOfContact>
                  <xsl:apply-templates select="$pocObj" mode="responsibility"/>
                </mri:pointOfContact>
              </xsl:if>
            </xsl:if>
          </xsl:otherwise>
        </xsl:choose>
        
        <!-- Spatial Resolution (placeholder) -->
        <mri:spatialResolution/>
        
        <!-- Topic Category -->
        <xsl:if test="eCH0271_1:topicCategory">
          <mri:topicCategory>
            <mri:MD_TopicCategoryCode>
              <xsl:value-of select="normalize-space(eCH0271_1:topicCategory)"/>
            </mri:MD_TopicCategoryCode>
          </mri:topicCategory>
        </xsl:if>
        
        <!-- Extent (geographic/temporal) - direct ref OR direct object OR via association -->
        <xsl:choose>
          <!-- Priority 1: Direct reference -->
          <xsl:when test="eCH0271_1:extent[@ili:ref]">
            <mri:extent>
              <xsl:apply-templates select="eCH0271_1:extent[@ili:ref]" mode="extent"/>
            </mri:extent>
          </xsl:when>
          <!-- Priority 2: Direct EX_Extent object (commented reference case) -->
          <xsl:when test="//eCH0271_1:EX_Extent[@ili:tid='extent-001']">
            <xsl:variable name="extObj" select="//eCH0271_1:EX_Extent[@ili:tid='extent-001']"/>
            <mri:extent>
              <xsl:apply-templates select="$extObj" mode="extent"/>
            </mri:extent>
          </xsl:when>
          <!-- Priority 3: Via association MD_DataIdentificationExtentExtent -->
          <xsl:otherwise>
            <xsl:variable name="extAssoc" select="/ili:transfer/ili:datasection/eCH0271_1:eCH0271/eCH0271_1:MD_DataIdentificationExtentExtent[@ili:from=$currentDataIdentId]"/>
            <xsl:if test="$extAssoc">
              <xsl:variable name="extRef" select="$extAssoc/@ili:to"/>
              <xsl:variable name="extObj" select="key('byTID', $extRef)"/>
              <xsl:if test="$extObj">
                <mri:extent>
                  <xsl:apply-templates select="$extObj" mode="extent"/>
                </mri:extent>
              </xsl:if>
            </xsl:if>
          </xsl:otherwise>
        </xsl:choose>
        
        <!-- Resource Maintenance - Priority 1: direct ref, Priority 2: TID search -->
        <xsl:choose>
          <xsl:when test="eCH0271_1:resourceMaintenance[@ili:ref]">
            <mri:resourceMaintenance>
              <xsl:apply-templates select="eCH0271_1:resourceMaintenance[@ili:ref]" mode="resource-maintenance"/>
            </mri:resourceMaintenance>
          </xsl:when>
          <!-- Direct TID search (commented reference case) -->
          <xsl:when test="//eCH0271_1:CHE_MD_MaintenanceInformation[@ili:tid='maintenance-001']">
            <mri:resourceMaintenance>
              <xsl:apply-templates select="//eCH0271_1:CHE_MD_MaintenanceInformation[@ili:tid='maintenance-001']" mode="maintenance-object"/>
            </mri:resourceMaintenance>
          </xsl:when>
        </xsl:choose>
        
        <!-- Graphic Overview - Priority 1: direct ref (follow reference), Priority 2: TID search -->
        <xsl:choose>
          <xsl:when test="eCH0271_1:graphicOverview[@ili:ref]">
            <xsl:variable name="graphicRef" select="eCH0271_1:graphicOverview/@ili:ref"/>
            <xsl:variable name="graphicObj" select="key('byTID', $graphicRef)"/>
            <xsl:if test="$graphicObj/self::eCH0271_1:MD_BrowseGraphic">
              <mri:graphicOverview>
                <xsl:apply-templates select="$graphicObj" mode="browse-graphic"/>
              </mri:graphicOverview>
            </xsl:if>
          </xsl:when>
          <xsl:when test="//eCH0271_1:MD_BrowseGraphic[@ili:tid='browseGraphic-001']">
            <mri:graphicOverview>
              <xsl:apply-templates select="//eCH0271_1:MD_BrowseGraphic[@ili:tid='browseGraphic-001']" mode="browse-graphic"/>
            </mri:graphicOverview>
          </xsl:when>
        </xsl:choose>
        
        <!-- Resource Constraints - Priority 1: direct ref, Priority 2: TID search -->
        <xsl:choose>
          <xsl:when test="eCH0271_1:resourceConstraints[@ili:ref]">
            <xsl:variable name="constraintId" select="eCH0271_1:resourceConstraints/@ili:ref"/>
            <xsl:variable name="constraint" select="key('byTID', $constraintId)"/>
            <xsl:if test="$constraint/self::eCH0271_1:CHE_MD_LegalConstraints">
              <mri:resourceConstraints>
                <xsl:apply-templates select="$constraint" mode="legal-constraints"/>
              </mri:resourceConstraints>
            </xsl:if>
          </xsl:when>
          <xsl:when test="//eCH0271_1:CHE_MD_LegalConstraints[@ili:tid='legalConstraints-001']">
            <xsl:variable name="constraint" select="//eCH0271_1:CHE_MD_LegalConstraints[@ili:tid='legalConstraints-001']"/>
            <mri:resourceConstraints>
              <xsl:apply-templates select="$constraint" mode="legal-constraints"/>
            </mri:resourceConstraints>
          </xsl:when>
        </xsl:choose>
        
        <!-- Default Locale -->
        <xsl:if test="eCH0271_1:defaultLocale">
          <mri:defaultLocale>
            <xsl:apply-templates select="eCH0271_1:defaultLocale" mode="data-locale"/>
          </mri:defaultLocale>
        </xsl:if>
        
        <!-- CHE: Basic Geodata flag -->
        <xsl:if test="eCH0271_1:basicGeodata">
          <che:basicGeodata>
            <gco:Boolean>
              <xsl:value-of select="normalize-space(eCH0271_1:basicGeodata)"/>
            </gco:Boolean>
          </che:basicGeodata>
        </xsl:if>
        
        <!-- CHE: Basic Geodata Information -->
        <xsl:if test="eCH0271_1:basicGeodataInformation">
          <xsl:apply-templates select="eCH0271_1:basicGeodataInformation" mode="basic-geodata-info"/>
        </xsl:if>
      </che:CHE_MD_DataIdentification>
    </mdb:identificationInfo>
  </xsl:template>

  <!-- ================================================================
       MD_BrowseGraphic: filename (URL) for thumbnail/overview
       ================================================================ -->
  <xsl:template match="eCH0271_1:MD_BrowseGraphic" mode="browse-graphic">
    <mcc:MD_BrowseGraphic>
      <xsl:if test="eCH0271_1:fileName">
        <mcc:fileName>
          <gco:CharacterString>
            <xsl:value-of select="normalize-space(eCH0271_1:fileName)"/>
          </gco:CharacterString>
        </mcc:fileName>
      </xsl:if>
      <xsl:if test="eCH0271_1:fileDescription">
        <mcc:fileDescription>
          <gco:CharacterString>
            <xsl:value-of select="normalize-space(eCH0271_1:fileDescription)"/>
          </gco:CharacterString>
        </mcc:fileDescription>
      </xsl:if>
      <xsl:if test="eCH0271_1:fileType">
        <mcc:fileType>
          <gco:CharacterString>
            <xsl:value-of select="normalize-space(eCH0271_1:fileType)"/>
          </gco:CharacterString>
        </mcc:fileType>
      </xsl:if>
    </mcc:MD_BrowseGraphic>
  </xsl:template>

  <!-- ================================================================
       CHE_MD_LegalConstraints: useConstraints and otherConstraints
       ================================================================ -->
  <xsl:template match="eCH0271_1:CHE_MD_LegalConstraints" mode="legal-constraints">
    <mco:MD_LegalConstraints>
      <!-- useConstraints -->
      <xsl:if test="eCH0271_1:useConstraints">
        <mco:useConstraints>
          <mco:MD_RestrictionCode codeList="https://standards.iso.org/iso/19115/resources/Codelists/cat/codelists.xml#MD_RestrictionCode" codeListValue="{normalize-space(eCH0271_1:useConstraints)}">
            <xsl:value-of select="normalize-space(eCH0271_1:useConstraints)"/>
          </mco:MD_RestrictionCode>
        </mco:useConstraints>
      </xsl:if>
      <!-- otherConstraints (multilingual text) -->
      <xsl:if test="eCH0271_1:otherConstraints">
        <mco:otherConstraints>
          <xsl:apply-templates select="eCH0271_1:otherConstraints" mode="multilingual-text"/>
        </mco:otherConstraints>
      </xsl:if>
    </mco:MD_LegalConstraints>
  </xsl:template>

  <!-- ================================================================
       multilingual-text: Extract text from Localisation_V2:MultilingualMText
       ================================================================ -->
  <xsl:template match="Localisation_V2:MultilingualMText" mode="multilingual-text">
    <gco:CharacterString>
      <!-- Extract first available text (preferred: French, otherwise first available) -->
      <xsl:choose>
        <xsl:when test="Localisation_V2:LocalisedText/Localisation_V2:LocalisedMText[Localisation_V2:Language='fr']/Localisation_V2:Text">
          <xsl:value-of select="Localisation_V2:LocalisedText/Localisation_V2:LocalisedMText[Localisation_V2:Language='fr']/Localisation_V2:Text/text()"/>
        </xsl:when>
        <xsl:otherwise>
          <xsl:value-of select="Localisation_V2:LocalisedText[1]/Localisation_V2:LocalisedMText/Localisation_V2:Text/text()"/>
        </xsl:otherwise>
      </xsl:choose>
    </gco:CharacterString>
  </xsl:template>

</xsl:stylesheet>
