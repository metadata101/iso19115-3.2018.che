<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="2.0"
                xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
                xmlns:che="http://geocat.ch/che"
                xmlns:mdb="http://standards.iso.org/iso/19115/-3/mdb/2.0"
                xmlns:rdf="http://www.w3.org/1999/02/22-rdf-syntax-ns#">

  <!-- Import the DCAT-AP-CH formatter -->
  <xsl:import href="../../formatter/dcat-ap-ch/dcat-ap-ch-core.xsl"/>

  <xsl:output method="xml" indent="yes"/>

  <xsl:variable name="metadata" select="//che:CHE_MD_Metadata | //mdb:MD_Metadata"/>

  <!-- Main template to apply DCAT-AP-CH transformation -->
  <xsl:template match="/" priority="99">
    <rdf:RDF>
      <xsl:call-template name="create-namespaces-dcat-ap-ch"/>
      <xsl:apply-templates select="$metadata" mode="iso19115-3-to-dcat"/>
    </rdf:RDF>
  </xsl:template>

</xsl:stylesheet>
