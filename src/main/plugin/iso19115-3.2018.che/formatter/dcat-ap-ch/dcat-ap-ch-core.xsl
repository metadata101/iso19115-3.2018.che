<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="2.0"
                xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
                xmlns:xs="http://www.w3.org/2001/XMLSchema"
                xmlns:mdb="http://standards.iso.org/iso/19115/-3/mdb/2.0"
                xmlns:mri="http://standards.iso.org/iso/19115/-3/mri/1.0"
                xmlns:mcc="http://standards.iso.org/iso/19115/-3/mcc/1.0"
                xmlns:mrd="http://standards.iso.org/iso/19115/-3/mrd/1.0"
                xmlns:mco="http://standards.iso.org/iso/19115/-3/mco/1.0"
                xmlns:mrl="http://standards.iso.org/iso/19115/-3/mrl/1.0"
                xmlns:cit="http://standards.iso.org/iso/19115/-3/cit/2.0"
                xmlns:lan="http://standards.iso.org/iso/19115/-3/lan/1.0"
                xmlns:gco="http://standards.iso.org/iso/19115/-3/gco/1.0"
                xmlns:che="http://geocat.ch/che"
                xmlns:rdf="http://www.w3.org/1999/02/22-rdf-syntax-ns#"
                xmlns:dct="http://purl.org/dc/terms/"
                xmlns:dcat="http://www.w3.org/ns/dcat#"
                xmlns:foaf="http://xmlns.com/foaf/0.1/"
                xmlns:vcard="http://www.w3.org/2006/vcard/ns#"
                xmlns:skos="http://www.w3.org/2004/02/skos/core#"
                xmlns:adms="http://www.w3.org/ns/adms#"
                xmlns:dcatapch="http://dcat-ap.ch/ns/"
                exclude-result-prefixes="#all">

  <xsl:import href="../dcat/dcat-core.xsl"/>
  <xsl:import href="dcat-ap-ch-core-dataset.xsl"/>

  <!-- Allow multiple accrual periodicities -->
  <xsl:param name="multipleAccrualPeriodicityAllowed"
             as="xs:string"
             select="'false'"/>
  
  <!-- Preserve all resource constraints -->
  <xsl:variable name="isPreservingAllResourceConstraints"
                as="xs:boolean"
                select="false()"/>
  
  <!-- Preserve ISO type -->
  <xsl:variable name="isPreservingIsoType"
                as="xs:boolean"
                select="false()"/>

  <!-- Main template for DCAT-AP CH -->
  <xsl:template match="/">
    <xsl:apply-templates select="root/che:CHE_MD_Metadata|che:CHE_MD_Metadata" mode="iso19115-3-to-dcat"/>
  </xsl:template>

  <!-- Catalog Record for DCAT-AP CH -->
  <xsl:template mode="iso19115-3-to-dcat-catalog-record"
                name="iso19115-3-to-dcat-ap-ch-catalog-record"
                match="che:CHE_MD_Metadata"
                priority="10">
    
    <xsl:param name="additionalProperties" as="node()*"/>
    
    <xsl:variable name="properties" as="node()*">
      <!-- Languages -->
      <xsl:apply-templates mode="iso19115-3-to-dcat"
                           select="mdb:defaultLocale|mdb:otherLocale"/>
      
      <!-- Source metadata -->
      <xsl:apply-templates mode="iso19115-3-to-dcat-ap-ch"
                           select="mdb:metadataLinkage[*/cit:linkage/*/text() != '']"/>
      
      <xsl:copy-of select="$additionalProperties"/>
      
      <!-- Conformance to DCAT-AP CH -->
      <dct:conformsTo>
        <dct:Standard rdf:about="http://dcat-ap.ch/"/>
      </dct:conformsTo>
    </xsl:variable>
    
    <!-- Simplified CatalogRecord structure for DCAT-AP CH -->
    <!-- Don't use foaf:isPrimaryTopicOf wrapper - create flat structure -->
    <xsl:call-template name="rdf-build-dcat-ap-ch-catalogue-record">
      <xsl:with-param name="properties" select="$properties"/>
    </xsl:call-template>
  </xsl:template>

  <!-- Build simplified DCAT-AP CH CatalogRecord without foaf:isPrimaryTopicOf wrapper -->
  <xsl:template name="rdf-build-dcat-ap-ch-catalogue-record">
    <xsl:param name="properties" as="node()*"/>
    
    <!-- Note: The CatalogRecord is created as a sibling to the Dataset,
         not as a wrapper. The relationship is via foaf:primaryTopic -->
    <xsl:variable name="recordUri" select="concat(
      'https://www.geocat.ch/geonetwork/srv/eng/catalog.search#/metadata/',
      mdb:metadataIdentifier/*/mcc:code/*/text()
    )"/>
    
    <xsl:variable name="datasetUri" select="concat(
      'https://ckan.opendata.swiss/dataset/',
      mdb:metadataIdentifier/*/mcc:code/*/text()
    )"/>
    
    <!-- CatalogRecord (simplified, no wrapper) -->
    <dcat:CatalogRecord rdf:about="{$recordUri}">
      <xsl:apply-templates mode="iso19115-3-to-dcat"
                           select="mdb:metadataIdentifier
                                  |mdb:identificationInfo/*/mri:citation/*/cit:title
                                  |mdb:identificationInfo/*/mri:abstract
                                  |mdb:dateInfo/*[cit:dateType/*/@codeListValue = 'creation']/cit:date
                                  |mdb:dateInfo/*[cit:dateType/*/@codeListValue = 'revision']/cit:date"/>
      <xsl:copy-of select="$properties"/>
      <foaf:primaryTopic rdf:resource="{$datasetUri}"/>
    </dcat:CatalogRecord>
  </xsl:template>


  <!-- Source metadata (metadataLinkage) -->
  <xsl:template mode="iso19115-3-to-dcat-ap-ch"
                match="che:CHE_MD_Metadata/mdb:metadataLinkage">
    <dct:source>
      <rdf:Description rdf:about="{*/cit:linkage/*/text()}">
        <rdf:type rdf:resource="http://www.w3.org/ns/dcat#CatalogRecord"/>
        <xsl:apply-templates mode="iso19115-3-to-dcat"
                             select="ancestor::che:CHE_MD_Metadata/mdb:metadataStandard
                                    |mdb:dateInfo/*[cit:dateType/*/@codeListValue = 'creation']/cit:date
                                    |mdb:dateInfo/*[cit:dateType/*/@codeListValue = 'revision']/cit:date"/>
      </rdf:Description>
    </dct:source>
  </xsl:template>

  <!-- Provenance (resourceLineage) -->
  <xsl:template mode="iso19115-3-to-dcat"
                match="mdb:resourceLineage/*/mrl:statement">
    <dct:provenance>
      <dct:ProvenanceStatement>
        <xsl:call-template name="rdf-localised">
          <xsl:with-param name="nodeName" select="'dct:description'"/>
        </xsl:call-template>
      </dct:ProvenanceStatement>
    </dct:provenance>
  </xsl:template>

  <!-- Namespaces for DCAT-AP CH -->
  <xsl:template name="create-namespaces-dcat-ap-ch">
    <xsl:call-template name="create-namespaces"/>
    <xsl:namespace name="dcatapch" select="'http://dcat-ap.ch/ns/'"/>
  </xsl:template>

</xsl:stylesheet>