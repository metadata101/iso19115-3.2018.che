<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="2.0"
                xmlns:xsl="http://www.w3.org/1999/XSL/Transform">

  <!--
    Brief representation of eCH-0271 metadata for CSW GetRecords responses.
    Includes: metadata identifier, title, abstract, extent, update frequency.
    Excludes: detailed contacts, data quality, all nested references.
  -->
  <xsl:import href="../../convert/fromECH0271.xsl"/>

  <xsl:param name="metadata" as="node()?"/>

  <xsl:template match="/">
    <xsl:choose>
      <xsl:when test="$metadata">
        <xsl:apply-templates select="$metadata"/>
      </xsl:when>
      <xsl:otherwise>
        <!-- Process root document directly if no $metadata parameter provided -->
        <xsl:apply-templates select="."/>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:template>

  <!-- Override: suppress detailed contact information in brief mode -->
  <xsl:template name="ECH0271:CI_Party" priority="10">
    <!-- Brief mode: omit detailed party information -->
  </xsl:template>

  <!-- Override: suppress reference system details in brief mode -->
  <xsl:template name="ech0271:MD_ReferenceSystem" priority="10">
    <!-- Brief mode: omit reference system details -->
  </xsl:template>

  <!-- Override: suppress data quality details in brief mode -->
  <xsl:template name="ech0271:DQ_DataQuality" priority="10">
    <!-- Brief mode: omit data quality details -->
  </xsl:template>

</xsl:stylesheet>
