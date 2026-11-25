<?xml version="1.0" encoding="UTF-8"?>
<!-- eCH-0271-XTF → ISO 19115-3:2018 CHE: CHE_MD_DataIdentification mapping
     Handles dataset identification: title, abstract, status, contacts, extent, maintenance
     XSLT 2.0, Saxon HE 9.1+ compatible -->
<xsl:stylesheet version="2.0"
  xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
  xmlns:xs="http://www.w3.org/2001/XMLSchema"
  xmlns:ili="http://www.interlis.ch/xtf/2.4/INTERLIS"
  xmlns:eCH0271="http://www.interlis.ch/xtf/2.4/eCH0271"
  xmlns:f271="urn:ech0271-functions"
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
  <xsl:template match="eCH0271:CHE_MD_DataIdentification" mode="data-id">
    <mdb:identificationInfo>
      <che:CHE_MD_DataIdentification gco:isoType="mri:MD_DataIdentification">
        <!-- Citation -->
        <xsl:for-each select="f271:related(., 'CI_Citation', 'citation')">
          <mri:citation>
            <xsl:apply-templates select="." mode="citation"/>
          </mri:citation>
        </xsl:for-each>
        
        <!-- Abstract -->
        <xsl:if test="eCH0271:abstract">
          <mri:abstract>
            <xsl:apply-templates select="eCH0271:abstract" mode="multilingual-text"/>
          </mri:abstract>
        </xsl:if>
        
        <!-- Status -->
        <xsl:if test="eCH0271:status">
          <mri:status>
            <mcc:MD_ProgressCode codeList="{$CL}MD_ProgressCode" codeListValue="{normalize-space(eCH0271:status)}">
              <xsl:value-of select="normalize-space(eCH0271:status)"/>
            </mcc:MD_ProgressCode>
          </mri:status>
        </xsl:if>
        
        <!-- Point of Contact (dataset-level) -->
        <xsl:for-each select="f271:related(., 'CI_Responsibility', 'pointOfContact')">
          <mri:pointOfContact>
            <xsl:apply-templates select="." mode="responsibility"/>
          </mri:pointOfContact>
        </xsl:for-each>
        
        <!-- Spatial Representation Type -->
        <xsl:for-each select="eCH0271:spatialRepresentationType[normalize-space() != '']">
          <mri:spatialRepresentationType>
            <mcc:MD_SpatialRepresentationTypeCode codeList="{$CL}MD_SpatialRepresentationTypeCode" codeListValue="{normalize-space()}">
              <xsl:value-of select="normalize-space()"/>
            </mcc:MD_SpatialRepresentationTypeCode>
          </mri:spatialRepresentationType>
        </xsl:for-each>

        <!-- Spatial Resolution: equivalent scale (1:denominator) -->
        <xsl:for-each select="f271:related(., 'MD_Resolution', 'spatialResolution', ('MD_DataIdentification', 'MD_Identification'))">
          <xsl:variable name="denominator"
            select="normalize-space(f271:related(., 'MD_RepresentativeFraction', 'equivalentScale')[1]/eCH0271:denominator)"/>
          <xsl:if test="$denominator != ''">
            <mri:spatialResolution>
              <mri:MD_Resolution>
                <mri:equivalentScale>
                  <mri:MD_RepresentativeFraction>
                    <mri:denominator>
                      <gco:Integer>
                        <xsl:value-of select="$denominator"/>
                      </gco:Integer>
                    </mri:denominator>
                  </mri:MD_RepresentativeFraction>
                </mri:equivalentScale>
              </mri:MD_Resolution>
            </mri:spatialResolution>
          </xsl:if>
        </xsl:for-each>
        
        <!-- Topic Category -->
        <xsl:for-each select="eCH0271:topicCategory[normalize-space()]">
          <mri:topicCategory>
            <mri:MD_TopicCategoryCode>
              <xsl:value-of select="normalize-space()"/>
            </mri:MD_TopicCategoryCode>
          </mri:topicCategory>
        </xsl:for-each>
        
        <!-- Extent -->
        <xsl:for-each select="f271:related(., 'EX_Extent', 'extent', ('MD_DataIdentification', 'MD_Identification'))">
          <mri:extent>
            <xsl:apply-templates select="." mode="extent"/>
          </mri:extent>
        </xsl:for-each>

        <!-- Resource Maintenance -->
        <xsl:for-each select="f271:related(., 'CHE_MD_MaintenanceInformation', 'resourceMaintenance', 'MD_Identification')">
          <mri:resourceMaintenance>
            <xsl:apply-templates select="." mode="maintenance-object"/>
          </mri:resourceMaintenance>
        </xsl:for-each>

        <!-- Graphic Overview -->
        <xsl:for-each select="f271:related(., 'MD_BrowseGraphic', 'graphicOverview', 'MD_Identification')">
          <mri:graphicOverview>
            <xsl:apply-templates select="." mode="browse-graphic"/>
          </mri:graphicOverview>
        </xsl:for-each>

        <!-- Descriptive Keywords, grouped by thesaurus -->
        <xsl:call-template name="descriptive-keywords"/>

        <!-- Resource Constraints -->
        <xsl:for-each select="f271:related(., 'CHE_MD_LegalConstraints', 'resourceConstraints', 'MD_Identification')">
          <mri:resourceConstraints>
            <xsl:apply-templates select="." mode="legal-constraints"/>
          </mri:resourceConstraints>
        </xsl:for-each>

        <!-- Default Locale -->
        <xsl:if test="eCH0271:defaultLocale">
          <mri:defaultLocale>
            <xsl:apply-templates select="eCH0271:defaultLocale" mode="data-locale"/>
          </mri:defaultLocale>
        </xsl:if>

        <!-- Other Locales: one mri:otherLocale per PT_Locale -->
        <xsl:for-each select="eCH0271:otherLocale/eCH0271:PT_Locale">
          <mri:otherLocale>
            <xsl:apply-templates select="." mode="data-locale"/>
          </mri:otherLocale>
        </xsl:for-each>
        
        <!-- CHE: Sub Topic Categories -->
        <xsl:for-each select="eCH0271:subTopicCategory[normalize-space()]">
          <che:subTopicCategory>
            <che:CHE_MD_SubTopicCategoryCode codeList="subTopicCategory"
                                             codeListValue="{normalize-space()}"/>
          </che:subTopicCategory>
        </xsl:for-each>

        <!-- CHE: Basic Geodata flag -->
        <xsl:if test="eCH0271:basicGeodata">
          <che:basicGeodata>
            <gco:Boolean>
              <xsl:value-of select="normalize-space(eCH0271:basicGeodata)"/>
            </gco:Boolean>
          </che:basicGeodata>
        </xsl:if>
        
        <!-- CHE: Basic Geodata Information -->
        <xsl:if test="eCH0271:basicGeodataInformation">
          <xsl:apply-templates select="eCH0271:basicGeodataInformation" mode="basic-geodata-info"/>
        </xsl:if>
      </che:CHE_MD_DataIdentification>
    </mdb:identificationInfo>
  </xsl:template>

  <!-- ================================================================
       MD_BrowseGraphic: filename (URL) for thumbnail/overview
       ================================================================ -->
  <xsl:template match="eCH0271:MD_BrowseGraphic" mode="browse-graphic">
    <mcc:MD_BrowseGraphic>
      <xsl:if test="eCH0271:fileName">
        <mcc:fileName>
          <gco:CharacterString>
            <xsl:value-of select="normalize-space(eCH0271:fileName)"/>
          </gco:CharacterString>
        </mcc:fileName>
      </xsl:if>
      <xsl:if test="eCH0271:fileDescription">
        <mcc:fileDescription>
          <gco:CharacterString>
            <xsl:value-of select="normalize-space(eCH0271:fileDescription)"/>
          </gco:CharacterString>
        </mcc:fileDescription>
      </xsl:if>
      <xsl:if test="eCH0271:fileType">
        <mcc:fileType>
          <gco:CharacterString>
            <xsl:value-of select="normalize-space(eCH0271:fileType)"/>
          </gco:CharacterString>
        </mcc:fileType>
      </xsl:if>
    </mcc:MD_BrowseGraphic>
  </xsl:template>

  <!-- ================================================================
       CHE_MD_LegalConstraints: useConstraints and otherConstraints
       ================================================================ -->
  <xsl:template match="eCH0271:CHE_MD_LegalConstraints" mode="legal-constraints">
    <mco:MD_LegalConstraints>
      <!-- useConstraints -->
      <xsl:if test="eCH0271:useConstraints">
        <mco:useConstraints>
          <mco:MD_RestrictionCode codeList="{$CL}MD_RestrictionCode" codeListValue="{normalize-space(eCH0271:useConstraints)}">
            <xsl:value-of select="normalize-space(eCH0271:useConstraints)"/>
          </mco:MD_RestrictionCode>
        </mco:useConstraints>
      </xsl:if>
      <!-- otherConstraints (multilingual text) -->
      <xsl:if test="eCH0271:otherConstraints">
        <mco:otherConstraints>
          <xsl:apply-templates select="eCH0271:otherConstraints" mode="multilingual-text"/>
        </mco:otherConstraints>
      </xsl:if>
    </mco:MD_LegalConstraints>
  </xsl:template>

</xsl:stylesheet>
