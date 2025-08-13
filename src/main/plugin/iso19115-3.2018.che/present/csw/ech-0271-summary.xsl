<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="2.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
                xmlns:csw="http://www.opengis.net/cat/csw/2.0.2"
                xmlns:mdb="http://standards.iso.org/iso/19115/-3/mdb/2.0"
                xmlns:mri="http://standards.iso.org/iso/19115/-3/mri/1.0"
                xmlns:cit="http://standards.iso.org/iso/19115/-3/cit/2.0"
                xmlns:mcc="http://standards.iso.org/iso/19115/-3/mcc/1.0"
                xmlns:gex="http://standards.iso.org/iso/19115/-3/gex/1.0"
                xmlns:srv="http://standards.iso.org/iso/19115/-3/srv/2.0"
                xmlns:mco="http://standards.iso.org/iso/19115/-3/mco/1.0"
                xmlns:mrd="http://standards.iso.org/iso/19115/-3/mrd/1.0"
                xmlns:lan="http://standards.iso.org/iso/19115/-3/lan/1.0"
                xmlns:mrl="http://standards.iso.org/iso/19115/-3/mrl/2.0"
                xmlns:mrs="http://standards.iso.org/iso/19115/-3/mrs/1.0"
                xmlns:gco="http://standards.iso.org/iso/19115/-3/gco/1.0"
                xmlns:ows="http://www.opengis.net/ows"
                xmlns:gn="http://www.fao.org/geonetwork"
                xmlns:che="http://geocat.ch/che"
                exclude-result-prefixes="#all">

  <xsl:import href="ech-0271-brief.xsl" />

  <xsl:template match="mri:MD_DataIdentification|
    *[contains(@gco:isoType, 'MD_DataIdentification')]|
    srv:SV_ServiceIdentification|
    *[contains(@gco:isoType, 'SV_ServiceIdentification')]
    " priority="199">
    <xsl:copy>
      <xsl:apply-templates select="@*" />
      <xsl:apply-templates select="mri:citation"/>
      <xsl:apply-templates select="mri:abstract"/>
      <xsl:apply-templates select="mri:graphicOverview"/>
      <xsl:apply-templates select="mri:extent[child::gex:EX_Extent[child::gex:geographicElement]]|
        srv:extent[child::gex:EX_Extent[child::gex:geographicElement]]"/>
      <xsl:apply-templates select="srv:serviceType"/>
      <xsl:apply-templates select="srv:serviceTypeVersion"/>
    </xsl:copy>
  </xsl:template>


</xsl:stylesheet>
