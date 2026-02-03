<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="2.0"
                xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
                xmlns:xs="http://www.w3.org/2001/XMLSchema"
                xmlns:che="http://geocat.ch/che"
                xmlns:mdb="http://standards.iso.org/iso/19115/-3/mdb/2.0"
                xmlns:mri="http://standards.iso.org/iso/19115/-3/mri/1.0"
                xmlns:mco="http://standards.iso.org/iso/19115/-3/mco/1.0"
                xmlns:rdf="http://www.w3.org/1999/02/22-rdf-syntax-ns#"
                xmlns:dct="http://purl.org/dc/terms/"
                xmlns:dcat="http://www.w3.org/ns/dcat#"
                xmlns:foaf="http://xmlns.com/foaf/0.1/"
                exclude-result-prefixes="#all">

  <xsl:import href="dcat-ap-ch-core.xsl"/>

  <!-- Main template to generate RDF/XML -->
  <xsl:template match="/" priority="2">
    <rdf:RDF>
      <xsl:call-template name="create-namespaces-dcat-ap-ch"/>
      
      <!-- Dataset only (no CatalogRecord in DCAT-AP CH) -->
      <xsl:apply-templates select="root/che:CHE_MD_Metadata|che:CHE_MD_Metadata" mode="iso19115-3-to-dcat"/>
      
      <!-- License statement at the end -->
      <xsl:call-template name="dcat-ap-ch-license-statement"/>
    </rdf:RDF>
  </xsl:template>
  
  <!-- License statement for DCAT-AP CH -->
  <xsl:template name="dcat-ap-ch-license-statement">
    <xsl:variable name="constraints" select="(root/che:CHE_MD_Metadata|che:CHE_MD_Metadata)/mdb:identificationInfo/*/mri:resourceConstraints/*[mco:useConstraints or mco:useLimitation or mco:otherConstraints]"/>
    
    <xsl:for-each select="$constraints[1]">
      <xsl:variable name="constraintsText" 
                    select="string-join(mco:useLimitation/*/text() | mco:otherConstraints//text(), ' ')"/>
      
      <xsl:variable name="licenseUri">
        <xsl:choose>
          <xsl:when test="contains($constraintsText, 'Freie Nutzung') and 
                          contains($constraintsText, 'Quellenangabe')">
            <xsl:text>http://dcat-ap.ch/vocabulary/licenses/terms_by</xsl:text>
          </xsl:when>
          <xsl:when test="contains($constraintsText, 'Freie Nutzung')">
            <xsl:text>http://dcat-ap.ch/vocabulary/licenses/terms_open</xsl:text>
          </xsl:when>
          <xsl:otherwise>
            <xsl:text>http://dcat-ap.ch/vocabulary/licenses/terms_by</xsl:text>
          </xsl:otherwise>
        </xsl:choose>
      </xsl:variable>
      
      <dct:RightsStatement rdf:about="{$licenseUri}">
        <rdf:type rdf:resource="http://purl.org/dc/terms/LicenseDocument"/>
      </dct:RightsStatement>
    </xsl:for-each>
  </xsl:template>

</xsl:stylesheet>