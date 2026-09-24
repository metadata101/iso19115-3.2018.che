<?xml version="1.0" encoding="UTF-8"?>
<!-- eCH-0271 → ISO 19115-3:2018 CHE: CHE_MD_MaintenanceInformation mapping
     Handles resource maintenance with mmi: namespace
     XSLT 2.0, Saxon HE 9.1+ compatible -->
<xsl:stylesheet version="2.0"
  xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
  xmlns:xs="http://www.w3.org/2001/XMLSchema"
  xmlns:ili="http://www.interlis.ch/xtf/2.4/INTERLIS"
  xmlns:eCH0271_1="http://www.interlis.ch/xtf/2.4/eCH0271_1"
  xmlns:che="http://geocat.ch/che"
  xmlns:gco="http://standards.iso.org/iso/19115/-3/gco/1.0"
  xmlns:mmi="http://standards.iso.org/iso/19115/-3/mmi/1.0"
  exclude-result-prefixes="#all">

  <!-- ================================================================
       resourceMaintenance: CHE_MD_MaintenanceInformation → mri:resourceMaintenance
       
       Maps eCH0271 resource maintenance to ISO 19115-3:2018 CHE structure:
       - Source: eCH0271_1:CHE_MD_MaintenanceInformation
       - Output wrapper: che:CHE_MD_MaintenanceInformation with gco:isoType="mmi:MD_MaintenanceInformation"
       - Children: mmi: namespace (maintenance info module)
       
       Critical points:
       - Frequency code uses mmi:MD_MaintenanceFrequencyCode
       - Must be wrapped in che: container with isoType pointing to mmi:
       - All child elements use mmi: namespace prefix
       ================================================================ -->
  <xsl:template match="eCH0271_1:resourceMaintenance[@ili:ref]" mode="resource-maintenance">
    <xsl:variable name="maintId" select="@ili:ref"/>
    <xsl:variable name="maintObj" select="key('byTID', $maintId)"/>

    <xsl:if test="$maintObj/self::eCH0271_1:CHE_MD_MaintenanceInformation">
      <che:CHE_MD_MaintenanceInformation gco:isoType="mmi:MD_MaintenanceInformation">
        <!-- Maintenance and update frequency -->
        <xsl:if test="$maintObj/eCH0271_1:maintenanceAndUpdateFrequency">
          <mmi:maintenanceAndUpdateFrequency>
            <xsl:call-template name="frequency-code">
              <xsl:with-param name="value" select="normalize-space($maintObj/eCH0271_1:maintenanceAndUpdateFrequency)"/>
            </xsl:call-template>
          </mmi:maintenanceAndUpdateFrequency>
        </xsl:if>
        <!-- Maintenance note -->
        <xsl:if test="$maintObj/eCH0271_1:maintenanceNote">
          <mmi:maintenanceNote>
            <xsl:apply-templates select="$maintObj/eCH0271_1:maintenanceNote" mode="multilingual-text"/>
          </mmi:maintenanceNote>
        </xsl:if>
      </che:CHE_MD_MaintenanceInformation>
    </xsl:if>
  </xsl:template>

</xsl:stylesheet>
