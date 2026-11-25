<?xml version="1.0" encoding="UTF-8"?>
<!-- eCH-0271-XTF → ISO 19115-3:2018 CHE: CI_Citation mapping
     Handles citation (title + alternateTitle + dates + identifiers) transformation
     XSLT 2.0, Saxon HE 9.1+ compatible -->
<xsl:stylesheet version="2.0"
  xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
  xmlns:xs="http://www.w3.org/2001/XMLSchema"
  xmlns:ili="http://www.interlis.ch/xtf/2.4/INTERLIS"
  xmlns:eCH0271="http://www.interlis.ch/xtf/2.4/eCH0271"
  xmlns:Localisation_V2="http://www.interlis.ch/xtf/2.4/Localisation_V2"
  xmlns:cit="http://standards.iso.org/iso/19115/-3/cit/2.0"
  xmlns:gco="http://standards.iso.org/iso/19115/-3/gco/1.0"
  xmlns:mcc="http://standards.iso.org/iso/19115/-3/mcc/1.0"
  xmlns:f271="urn:ech0271-functions"
  exclude-result-prefixes="#all">

  <!-- ================================================================
       citation: CI_Citation
       Callers select the citation object with f271:related, so nested
       structures and ili:ref references are handled the same way.
       ================================================================ -->
  <xsl:template match="eCH0271:CI_Citation" mode="citation">
    <cit:CI_Citation>
      <xsl:for-each select="eCH0271:title">
        <cit:title>
          <xsl:apply-templates select="." mode="multilingual-text"/>
        </cit:title>
      </xsl:for-each>
      <xsl:for-each select="eCH0271:alternateTitle">
        <cit:alternateTitle>
          <xsl:apply-templates select="." mode="multilingual-text"/>
        </cit:alternateTitle>
      </xsl:for-each>
      <xsl:for-each select="f271:related(., 'CI_Date', 'date')">
        <cit:date>
          <xsl:apply-templates select="." mode="date"/>
        </cit:date>
      </xsl:for-each>
      <xsl:for-each select="f271:related(., 'MD_Identifier', 'identifier')[eCH0271:code]">
        <cit:identifier>
          <mcc:MD_Identifier>
            <mcc:code>
              <xsl:apply-templates select="eCH0271:code" mode="multilingual-text"/>
            </mcc:code>
          </mcc:MD_Identifier>
        </cit:identifier>
      </xsl:for-each>
    </cit:CI_Citation>
  </xsl:template>

</xsl:stylesheet>
