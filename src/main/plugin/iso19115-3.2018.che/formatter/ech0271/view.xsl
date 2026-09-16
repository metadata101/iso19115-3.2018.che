<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="2.0"
  xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
  xmlns:xs="http://www.w3.org/2001/XMLSchema"
  xmlns:ili="http://www.interlis.ch/xtf/2.4/INTERLIS"
  xmlns:eCH0271_1="http://www.interlis.ch/xtf/2.4/eCH0271_1"
  xmlns:Localisation_V2="http://www.interlis.ch/xtf/2.4/Localisation_V2"
  xmlns:mdb="http://standards.iso.org/iso/19115/-3/mdb/2.0"
  xmlns:mri="http://standards.iso.org/iso/19115/-3/mri/1.0"
  xmlns:cit="http://standards.iso.org/iso/19115/-3/cit/2.0"
  xmlns:gex="http://standards.iso.org/iso/19115/-3/gex/1.0"
  xmlns:mcc="http://standards.iso.org/iso/19115/-3/mcc/1.0"
  xmlns:lan="http://standards.iso.org/iso/19115/-3/lan/1.0"
  xmlns:gco="http://standards.iso.org/iso/19115/-3/gco/1.0"
  xmlns:mrl="http://standards.iso.org/iso/19115/-3/mrl/2.0"
  xmlns:mrd="http://standards.iso.org/iso/19115/-3/mrd/1.0"
  xmlns:che="http://geocat.ch/che"
  exclude-result-prefixes="#all">

  <xsl:import href="../../convert/eCH-0271/toECH0271.xsl"/>

  <xsl:output method="xml"
              indent="yes"
              encoding="UTF-8"/>

  <!-- Return raw XTF/XML with proper ili:transfer structure (no HTML wrapper) -->
  <xsl:template match="/" priority="10">
    <ili:transfer xmlns:ili="http://www.interlis.ch/xtf/2.4/INTERLIS" 
                   xmlns:eCH0271_1="http://www.interlis.ch/xtf/2.4/eCH0271_1" 
                   xmlns:Localisation_V2="http://www.interlis.ch/xtf/2.4/Localisation_V2" 
                   xmlns:geom="http://www.interlis.ch/geometry/1.0" 
                   xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance">
      <ili:headersection>
        <ili:models>
          <ili:model Name="eCH0271_1" Version="2024-01-01"/>
        </ili:models>
      </ili:headersection>
      <ili:datasection>
        <xsl:apply-templates select="root/mdb:MD_Metadata|mdb:MD_Metadata|root/che:CHE_MD_Metadata|che:CHE_MD_Metadata" mode="iso19115-to-ech0271"/>
      </ili:datasection>
    </ili:transfer>
  </xsl:template>

</xsl:stylesheet>
