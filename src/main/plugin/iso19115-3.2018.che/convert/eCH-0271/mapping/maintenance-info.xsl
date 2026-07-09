<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="2.0"
  xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
  xmlns:xs="http://www.w3.org/2001/XMLSchema"
  xmlns:int="http://www.interlis.ch/INTERLIS2.3"
  xmlns:ech0271="urn:ech0271-functions"
  xmlns:mdb="http://standards.iso.org/iso/19115/-3/mdb/2.0"
  xmlns:mcc="http://standards.iso.org/iso/19115/-3/mcc/1.0"
  xmlns:gco="http://standards.iso.org/iso/19115/-3/gco/1.0"
  xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"
  exclude-result-prefixes="xsl xs int ech0271">

  <!-- ================================================================
       MD_MaintenanceInformation
       Maps GM03 MD_MaintenanceInformation to ISO 19115-3:2018 mdb:MD_MaintenanceInformation
       
       INTERLIS source structure:
       - eCH0271_1.eCH0271.MD_MaintenanceInformation
         - maintenanceAndUpdateFrequency: CodeList value (annually, asNeeded, daily, etc.)
         - MD_Identification: back-reference to the data identification
       
       Output ISO 19115-3 structure:
       - mdb:MD_MaintenanceInformation
         - mdb:maintenanceAndUpdateFrequency: mcc:MD_MaintenanceFrequencyCode
         - mdb:maintenanceContact: cit:CI_Responsibility (optional)
         - mdb:maintenanceDate: gco:DateTime (optional)
         - mdb:maintenanceScope: mcc:MD_Scope (optional)
       ================================================================ -->

  <xsl:template name="ech0271:MD_MaintenanceInformation">
    <xsl:param name="maintRecord" as="element()"/>
    <xsl:param name="basket"      as="element()"/>

    <mdb:MD_MaintenanceInformation>
      <!-- maintenance and update frequency (codelist: annually, asNeeded, daily, etc.) -->
      <xsl:if test="normalize-space($maintRecord/int:maintenanceAndUpdateFrequency) != ''">
        <mdb:maintenanceAndUpdateFrequency>
          <mcc:MD_MaintenanceFrequencyCode codeList="https://standards.iso.org/iso/19115/resources/Codelists/cat/codelists.xml#MD_MaintenanceFrequencyCode"
            codeListValue="{normalize-space($maintRecord/int:maintenanceAndUpdateFrequency)}">
            <xsl:value-of select="normalize-space($maintRecord/int:maintenanceAndUpdateFrequency)"/>
          </mcc:MD_MaintenanceFrequencyCode>
        </mdb:maintenanceAndUpdateFrequency>
      </xsl:if>

      <!-- contact information for maintenance (if present in future extensions) -->
      <!-- maintenanceContact via back-reference (not currently used in test data) -->
      <!-- 
      <xsl:for-each select="$basket/int:eCH0271_1.eCH0271.CI_ResponsibleParty
                              [int:MD_MaintenanceInformation/@REF = $maintRecord/@TID]">
        <mdb:maintenanceContact>
          <xsl:call-template name="ech0271:CI_Responsibility">
            <xsl:with-param name="partyTID" select="@TID"/>
            <xsl:with-param name="roleCode" select="normalize-space(int:role)"/>
            <xsl:with-param name="basket" select="$basket"/>
          </xsl:call-template>
        </mdb:maintenanceContact>
      </xsl:for-each>
      -->

    </mdb:MD_MaintenanceInformation>
  </xsl:template>

</xsl:stylesheet>
