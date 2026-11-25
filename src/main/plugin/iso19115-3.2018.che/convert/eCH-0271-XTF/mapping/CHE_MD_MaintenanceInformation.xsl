<?xml version="1.0" encoding="UTF-8"?>
<!-- eCH-0271-XTF → ISO 19115-3:2018 CHE: CHE_MD_MaintenanceInformation mapping
     Handles resource maintenance with mmi: namespace
     XSLT 2.0, Saxon HE 9.1+ compatible -->
<xsl:stylesheet version="2.0"
  xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
  xmlns:xs="http://www.w3.org/2001/XMLSchema"
  xmlns:ili="http://www.interlis.ch/xtf/2.4/INTERLIS"
  xmlns:eCH0271="http://www.interlis.ch/xtf/2.4/eCH0271"
  xmlns:che="http://geocat.ch/che"
  xmlns:gco="http://standards.iso.org/iso/19115/-3/gco/1.0"
  xmlns:mmi="http://standards.iso.org/iso/19115/-3/mmi/1.0"
  xmlns:f271="urn:ech0271-functions"
  exclude-result-prefixes="#all">

  <!-- ================================================================
       resourceMaintenance: CHE_MD_MaintenanceInformation → mri:resourceMaintenance
       
       Maps eCH0271 resource maintenance to ISO 19115-3:2018 CHE structure:
       - Source: eCH0271:CHE_MD_MaintenanceInformation
       - Output wrapper: che:CHE_MD_MaintenanceInformation with gco:isoType="mmi:MD_MaintenanceInformation"
       - Children: mmi: namespace (maintenance info module)
       
       Critical points:
       - Frequency code uses mmi:MD_MaintenanceFrequencyCode
       - Must be wrapped in che: container with isoType pointing to mmi:
       - All child elements use mmi: namespace prefix
       ================================================================ -->
  <xsl:template match="eCH0271:CHE_MD_MaintenanceInformation" mode="maintenance-object">
    <che:CHE_MD_MaintenanceInformation gco:isoType="mmi:MD_MaintenanceInformation">
      <!-- Maintenance and update frequency -->
      <xsl:if test="eCH0271:maintenanceAndUpdateFrequency">
        <mmi:maintenanceAndUpdateFrequency>
          <xsl:call-template name="frequency-code">
            <xsl:with-param name="value" select="normalize-space(eCH0271:maintenanceAndUpdateFrequency)"/>
          </xsl:call-template>
        </mmi:maintenanceAndUpdateFrequency>
      </xsl:if>
      <!-- Maintenance note -->
      <xsl:if test="eCH0271:maintenanceNote">
        <mmi:maintenanceNote>
          <xsl:apply-templates select="eCH0271:maintenanceNote" mode="multilingual-text"/>
        </mmi:maintenanceNote>
      </xsl:if>
      <!-- CHE: AAP (the appraisal object references this maintenance) -->
      <xsl:apply-templates
        select="f271:related(., 'CHE_MD_Appraisal_AAP', 'appraisal', 'CHE_MD_MaintenanceInformation')[1]"
        mode="appraisal"/>
    </che:CHE_MD_MaintenanceInformation>
  </xsl:template>

</xsl:stylesheet>
