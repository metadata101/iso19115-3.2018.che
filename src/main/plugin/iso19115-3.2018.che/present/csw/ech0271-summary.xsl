<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="2.0"
                xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
                xmlns:mdb="http://standards.iso.org/iso/19115/-3/mdb/2.0"
                xmlns:mri="http://standards.iso.org/iso/19115/-3/mri/1.0"
                xmlns:gex="http://standards.iso.org/iso/19115/-3/gex/1.0"
                xmlns:cit="http://standards.iso.org/iso/19115/-3/cit/2.0"
                xmlns:lan="http://standards.iso.org/iso/19115/-3/lan/1.0"
                xmlns:gco="http://standards.iso.org/iso/19115/-3/gco/1.0"
                xmlns:che="http://geocat.ch/che">

  <!--
    Minimal summary representation of eCH-0271 metadata for CSW GetRecords responses.
    Includes: metadata identifier, title, abstract.
    Excludes: contacts, extent, data quality, keywords, spatial representation type, etc.
  -->
  <xsl:import href="../../convert/fromECH0271.xsl"/>

  <xsl:param name="metadata" as="node()?"/>

  <xsl:template match="/">
    <xsl:choose>
      <xsl:when test="$metadata">
        <xsl:apply-templates select="$metadata"/>
      </xsl:when>
      <xsl:otherwise>
        <xsl:apply-templates select="."/>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:template>

  <!-- Override MD_DataIdentification: strip all optional fields in summary mode -->
  <xsl:template name="ech0271:CHE_MD_DataIdentification" priority="10">
    <xsl:param name="diTID"/>
    <xsl:param name="basket"/>

    <!-- Only output: citation (title), abstract -->
    <mri:MD_DataIdentification>
      <!-- Citation with title only -->
      <mri:citation>
        <cit:CI_Citation>
          <cit:title>
            <xsl:copy-of select="(int:MD_DataIdentificationcitation/int:CI_Citation/int:CI_Citationtitle)[1]//@*"/>
            <gco:CharacterString>
              <xsl:value-of select="(int:MD_DataIdentificationcitation/int:CI_Citation/int:CI_Citationtitle/int:PT_FreeText/int:textGroup[1]/int:LocalisedCharacterString)[1]"/>
            </gco:CharacterString>
          </cit:title>
        </cit:CI_Citation>
      </mri:citation>

      <!-- Abstract only (no purpose, status, keywords, etc.) -->
      <xsl:if test="int:MD_DataIdentificationabstract">
        <mri:abstract>
          <xsl:call-template name="ech0271:PT_FreeText_content">
            <xsl:with-param name="freetextRecord" select="int:MD_DataIdentificationabstract/int:PT_FreeText"/>
          </xsl:call-template>
        </mri:abstract>
      </xsl:if>
    </mri:MD_DataIdentification>
  </xsl:template>

  <!-- Suppress all other detailed templates in summary mode -->
  <xsl:template name="ech0271:CI_Party" priority="10"/>
  <xsl:template name="ech0271:CI_Responsibility" priority="10"/>
  <xsl:template name="ech0271:contactInfo" priority="10"/>
  <xsl:template name="ech0271:MD_ReferenceSystem" priority="10"/>
  <xsl:template name="ech0271:EX_Extent" priority="10"/>
  <xsl:template name="ech0271:MD_Distribution" priority="10"/>
  <xsl:template name="ech0271:MD_MaintenanceInformation" priority="10"/>
  <xsl:template name="ech0271:DQ_DataQuality" priority="10"/>

</xsl:stylesheet>
