<?xml version="1.0" encoding="UTF-8"?>
<!-- eCH-0271-XTF → ISO 19115-3:2018 CHE: CHE_MD_Appraisal_AAP mapping
     Archiving and retention planning (AAP) of a resource maintenance
     XSLT 2.0, Saxon HE 9.1+ compatible -->
<xsl:stylesheet version="2.0"
  xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
  xmlns:eCH0271="http://www.interlis.ch/xtf/2.4/eCH0271"
  xmlns:che="http://geocat.ch/che"
  xmlns:gco="http://standards.iso.org/iso/19115/-3/gco/1.0"
  exclude-result-prefixes="#all">

  <!-- ================================================================
       appraisal: CHE_MD_Appraisal_AAP → che:appraisal
       In the XTF, the AAP object references its CHE_MD_MaintenanceInformation;
       in ISO CHE, it is nested in che:CHE_MD_MaintenanceInformation.
       ================================================================ -->
  <xsl:template match="eCH0271:CHE_MD_Appraisal_AAP" mode="appraisal">
    <che:appraisal>
      <che:CHE_MD_Appraisal_AAP>
        <xsl:for-each select="eCH0271:durationOfConservation">
          <che:durationOfConservation>
            <gco:Integer>
              <xsl:value-of select="normalize-space()"/>
            </gco:Integer>
          </che:durationOfConservation>
        </xsl:for-each>
        <xsl:for-each select="eCH0271:commentOnDurationOfConservation">
          <che:commentOnDurationOfConservation>
            <xsl:apply-templates select="." mode="multilingual-text"/>
          </che:commentOnDurationOfConservation>
        </xsl:for-each>
        <xsl:for-each select="eCH0271:appraisalOfArchivalValue">
          <che:appraisalOfArchivalValue>
            <che:CHE_AppraisalOfArchivalValueCode codeList="appraisalOfArchivalValueCode"
                                                  codeListValue="{normalize-space()}"/>
          </che:appraisalOfArchivalValue>
        </xsl:for-each>
        <xsl:for-each select="eCH0271:reasonForArchivingValue">
          <che:reasonForArchivingValue>
            <che:CHE_ReasonForArchivingValueCode codeList="reasonForArchivingValueCode"
                                                 codeListValue="{normalize-space()}"/>
          </che:reasonForArchivingValue>
        </xsl:for-each>
        <xsl:for-each select="eCH0271:commentOnArchivalValue">
          <che:commentOnArchivalValue>
            <xsl:apply-templates select="." mode="multilingual-text"/>
          </che:commentOnArchivalValue>
        </xsl:for-each>
      </che:CHE_MD_Appraisal_AAP>
    </che:appraisal>
  </xsl:template>

</xsl:stylesheet>
