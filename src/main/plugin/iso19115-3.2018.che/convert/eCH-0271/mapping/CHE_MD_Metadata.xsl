<?xml version="1.0" encoding="UTF-8"?>
<!-- eCH-0271 → ISO 19115-3:2018 CHE: CHE_MD_Metadata root mapping
     Handles root metadata element: identifiers, contacts, scopes, standards
     XSLT 2.0, Saxon HE 9.1+ compatible -->
<xsl:stylesheet version="2.0"
  xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
  xmlns:xs="http://www.w3.org/2001/XMLSchema"
  xmlns:ili="http://www.interlis.ch/xtf/2.4/INTERLIS"
  xmlns:eCH0271_1="http://www.interlis.ch/xtf/2.4/eCH0271_1"
  xmlns:cat="http://standards.iso.org/iso/19115/-3/cat/1.0"
  xmlns:cit="http://standards.iso.org/iso/19115/-3/cit/2.0"
  xmlns:che="http://geocat.ch/che"
  xmlns:gcx="http://standards.iso.org/iso/19115/-3/gcx/1.0"
  xmlns:gco="http://standards.iso.org/iso/19115/-3/gco/1.0"
  xmlns:gex="http://standards.iso.org/iso/19115/-3/gex/1.0"
  xmlns:gfc="http://standards.iso.org/iso/19110/gfc/1.1"
  xmlns:gml="http://www.opengis.net/gml/3.2"
  xmlns:lan="http://standards.iso.org/iso/19115/-3/lan/1.0"
  xmlns:mcc="http://standards.iso.org/iso/19115/-3/mcc/1.0"
  xmlns:mco="http://standards.iso.org/iso/19115/-3/mco/1.0"
  xmlns:mdb="http://standards.iso.org/iso/19115/-3/mdb/2.0"
  xmlns:mmi="http://standards.iso.org/iso/19115/-3/mmi/1.0"
  xmlns:mrd="http://standards.iso.org/iso/19115/-3/mrd/1.0"
  xmlns:mri="http://standards.iso.org/iso/19115/-3/mri/1.0"
  xmlns:mrs="http://standards.iso.org/iso/19115/-3/mrs/1.0"
  xmlns:xlink="http://www.w3.org/1999/xlink"
  xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"
  exclude-result-prefixes="#all">

  <!-- ================================================================
       CHE_MD_Metadata root processor
       Maps eCH0271_1:CHE_MD_Metadata to ISO 19115-3:2018 che:CHE_MD_Metadata
       
       Input structure handling:
       - metadataIdentifier: ili:ref reference → resolves via key()
       - defaultLocale: contains PT_Locale child element
       - metadataScope: ili:ref reference → resolves via key()
       - contact: ili:ref reference → resolves via key()
       - dateInfo: contains CI_Date child element
       - standardUsedBymetadataStandard: ili:ref reference
       - referenceSystemInfo: ili:ref reference
       - identificationInfo: ili:ref reference
       - distributionInfo: ili:ref reference
       - legislationInformation: ili:ref reference
       ================================================================ -->
  <xsl:template match="eCH0271_1:CHE_MD_Metadata" mode="md-metadata">
    <xsl:variable name="mdTID" select="@ili:tid"/>
    <che:CHE_MD_Metadata gco:isoType="mdb:MD_Metadata">
      
      <!-- metadata identifier (ili:ref reference) -->
      <xsl:apply-templates select="eCH0271_1:metadataIdentifier[@ili:ref]" mode="identifier"/>

      <!-- default locale (inline PT_Locale child) -->
      <xsl:if test="eCH0271_1:defaultLocale">
        <xsl:apply-templates select="eCH0271_1:defaultLocale/eCH0271_1:PT_Locale" mode="locale"/>
      </xsl:if>

      <!-- Metadata scope (ili:ref reference) -->
      <xsl:if test="eCH0271_1:metadataScope">
        <xsl:apply-templates select="eCH0271_1:metadataScope" mode="metadata-scope"/>
      </xsl:if>

      <!-- Metadata contact (ili:ref reference) -->
      <xsl:if test="eCH0271_1:contact">
        <xsl:apply-templates select="eCH0271_1:contact" mode="contact"/>
      </xsl:if>

      <!-- Metadata date info (inline CI_Date child) -->
      <xsl:if test="eCH0271_1:dateInfo">
        <xsl:apply-templates select="eCH0271_1:dateInfo/eCH0271_1:CI_Date" mode="date-info"/>
      </xsl:if>

      <!-- Metadata standard citation (ili:ref reference) -->
      <xsl:if test="eCH0271_1:standardUsedBymetadataStandard">
        <xsl:apply-templates select="eCH0271_1:standardUsedBymetadataStandard" mode="metadata-standard"/>
      </xsl:if>

      <!-- Reference system info (ili:ref reference) -->
      <xsl:if test="eCH0271_1:referenceSystemInfo">
        <xsl:apply-templates select="eCH0271_1:referenceSystemInfo" mode="reference-system"/>
      </xsl:if>

      <!-- Data identification (ili:ref reference) -->
      <xsl:if test="eCH0271_1:identificationInfo[@ili:ref]">
        <xsl:variable name="dataIdRef" select="eCH0271_1:identificationInfo/@ili:ref"/>
        <xsl:variable name="dataIdObj" select="key('byTID', $dataIdRef)"/>
        <xsl:apply-templates select="$dataIdObj" mode="data-id"/>
      </xsl:if>

      <!-- Distribution info (ili:ref reference) -->
      <xsl:if test="eCH0271_1:distributionInfo">
        <xsl:apply-templates select="eCH0271_1:distributionInfo" mode="distribution"/>
      </xsl:if>

      <!-- Legislative/governance info (ili:ref reference) -->
      <xsl:if test="eCH0271_1:legislationInformation">
        <xsl:apply-templates select="eCH0271_1:legislationInformation" mode="legislation"/>
      </xsl:if>
    </che:CHE_MD_Metadata>
  </xsl:template>

</xsl:stylesheet>
