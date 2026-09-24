<?xml version="1.0" encoding="UTF-8"?>
<!-- eCH-0271 → ISO 19115-3:2018 CHE: CHE_MD_DataIdentification mapping
     Handles dataset identification: title, abstract, status, contacts, extent, maintenance
     XSLT 2.0, Saxon HE 9.1+ compatible -->
<xsl:stylesheet version="2.0"
  xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
  xmlns:xs="http://www.w3.org/2001/XMLSchema"
  xmlns:ili="http://www.interlis.ch/xtf/2.4/INTERLIS"
  xmlns:eCH0271_1="http://www.interlis.ch/xtf/2.4/eCH0271_1"
  xmlns:che="http://geocat.ch/che"
  xmlns:cit="http://standards.iso.org/iso/19115/-3/cit/2.0"
  xmlns:gco="http://standards.iso.org/iso/19115/-3/gco/1.0"
  xmlns:mcc="http://standards.iso.org/iso/19115/-3/mcc/1.0"
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
        
        <!-- Point of Contact (dataset-level) -->
        <xsl:if test="eCH0271_1:pointOfContact[@ili:ref]">
          <mri:pointOfContact>
            <xsl:apply-templates select="eCH0271_1:pointOfContact[@ili:ref]" mode="data-point-of-contact"/>
          </mri:pointOfContact>
        </xsl:if>
        
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
        
        <!-- Extent -->
        <xsl:if test="eCH0271_1:extent[@ili:ref]">
          <mri:extent>
            <xsl:apply-templates select="eCH0271_1:extent[@ili:ref]" mode="extent"/>
          </mri:extent>
        </xsl:if>
        
        <!-- Resource Maintenance -->
        <xsl:if test="eCH0271_1:resourceMaintenance[@ili:ref]">
          <mri:resourceMaintenance>
            <xsl:apply-templates select="eCH0271_1:resourceMaintenance[@ili:ref]" mode="resource-maintenance"/>
          </mri:resourceMaintenance>
        </xsl:if>
        
        <!-- Graphic Overview -->
        <xsl:if test="eCH0271_1:graphicOverview[@ili:ref]">
          <mri:graphicOverview>
            <xsl:apply-templates select="eCH0271_1:graphicOverview[@ili:ref]" mode="browse-graphic"/>
          </mri:graphicOverview>
        </xsl:if>
        
        <!-- Resource Constraints -->
        <xsl:if test="eCH0271_1:resourceConstraints[@ili:ref]">
          <mri:resourceConstraints>
            <xsl:apply-templates select="eCH0271_1:resourceConstraints[@ili:ref]" mode="legal-constraints"/>
          </mri:resourceConstraints>
        </xsl:if>
        
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

</xsl:stylesheet>
