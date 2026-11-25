<?xml version="1.0" encoding="UTF-8"?>
<!-- eCH-0271-XTF → ISO 19115-3:2018 CHE: LI_Lineage mapping
     XSLT 2.0, Saxon HE 9.1+ compatible -->
<xsl:stylesheet version="2.0"
  xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
  xmlns:eCH0271="http://www.interlis.ch/xtf/2.4/eCH0271"
  xmlns:mdb="http://standards.iso.org/iso/19115/-3/mdb/2.0"
  xmlns:mrl="http://standards.iso.org/iso/19115/-3/mrl/2.0"
  exclude-result-prefixes="#all">

  <!-- ================================================================
       LI_Lineage → mdb:resourceLineage
       ================================================================ -->
  <xsl:template match="eCH0271:LI_Lineage" mode="lineage">
    <mdb:resourceLineage>
      <mrl:LI_Lineage>
        <xsl:if test="eCH0271:statement">
          <mrl:statement>
            <xsl:apply-templates select="eCH0271:statement" mode="multilingual-text"/>
          </mrl:statement>
        </xsl:if>
      </mrl:LI_Lineage>
    </mdb:resourceLineage>
  </xsl:template>

</xsl:stylesheet>
