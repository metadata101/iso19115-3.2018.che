<?xml version="1.0" encoding="UTF-8"?>
<!-- eCH0271 XTF 2.4 → ISO 19115-3:2018 CHE
     Converts INTERLIS metadata format to modern ISO standard
     XSLT 2.0, Saxon HE 9.1+ compatible -->
<xsl:stylesheet version="2.0"
  xmlns:xsl  ="http://www.w3.org/1999/XSL/Transform"
  xmlns:xs   ="http://www.w3.org/2001/XMLSchema"
  xmlns:ili  ="http://www.interlis.ch/xtf/2.4/INTERLIS"
  xmlns:eCH0271="http://www.interlis.ch/xtf/2.4/eCH0271"
  xmlns:Localisation_V2="http://www.interlis.ch/xtf/2.4/Localisation_V2"
  xmlns:LocalisationCH_V2="http://www.interlis.ch/xtf/2.4/LocalisationCH_V2"
  xmlns:f271 ="urn:ech0271-functions"
  xmlns:che  ="http://geocat.ch/che"
  xmlns:cat  ="http://standards.iso.org/iso/19115/-3/cat/1.0"
  xmlns:cit  ="http://standards.iso.org/iso/19115/-3/cit/2.0"
  xmlns:gco  ="http://standards.iso.org/iso/19115/-3/gco/1.0"
  xmlns:gcx  ="http://standards.iso.org/iso/19115/-3/gcx/1.0"
  xmlns:gex  ="http://standards.iso.org/iso/19115/-3/gex/1.0"
  xmlns:gfc  ="http://standards.iso.org/iso/19110/gfc/1.1"
  xmlns:gml  ="http://www.opengis.net/gml/3.2"
  xmlns:lan  ="http://standards.iso.org/iso/19115/-3/lan/1.0"
  xmlns:mac  ="http://standards.iso.org/iso/19115/-3/mac/2.0"
  xmlns:mcc  ="http://standards.iso.org/iso/19115/-3/mcc/1.0"
  xmlns:mco  ="http://standards.iso.org/iso/19115/-3/mco/1.0"
  xmlns:md1  ="http://standards.iso.org/iso/19115/-3/md1/2.0"
  xmlns:md2  ="http://standards.iso.org/iso/19115/-3/md2/2.0"
  xmlns:mda  ="http://standards.iso.org/iso/19115/-3/mda/2.0"
  xmlns:mdb  ="http://standards.iso.org/iso/19115/-3/mdb/2.0"
  xmlns:mds  ="http://standards.iso.org/iso/19115/-3/mds/2.0"
  xmlns:mdt  ="http://standards.iso.org/iso/19115/-3/mdt/2.0"
  xmlns:mdq  ="http://standards.iso.org/iso/19157/-2/mdq/1.0"
  xmlns:dqm  ="http://standards.iso.org/iso/19157/-2/dqm/1.0"
  xmlns:mex  ="http://standards.iso.org/iso/19115/-3/mex/1.0"
  xmlns:mrc  ="http://standards.iso.org/iso/19115/-3/mrc/2.0"
  xmlns:mrd  ="http://standards.iso.org/iso/19115/-3/mrd/1.0"
  xmlns:mri  ="http://standards.iso.org/iso/19115/-3/mri/1.0"
  xmlns:mmi  ="http://standards.iso.org/iso/19115/-3/mmi/1.0"
  xmlns:mrl  ="http://standards.iso.org/iso/19115/-3/mrl/2.0"
  xmlns:mrs  ="http://standards.iso.org/iso/19115/-3/mrs/1.0"
  xmlns:msr  ="http://standards.iso.org/iso/19115/-3/msr/2.0"
  xmlns:srv  ="http://standards.iso.org/iso/19115/-3/srv/2.0"
  xmlns:xlink="http://www.w3.org/1999/xlink"
  xmlns:xsi  ="http://www.w3.org/2001/XMLSchema-instance"
  exclude-result-prefixes="#all">

  <xsl:output method="xml" version="1.0" encoding="UTF-8" indent="yes"/>
  <xsl:strip-space elements="*"/>

  <!-- ================================================================
       Modular mapping files — XTF 2.4 compatible versions -->
  <!-- Root metadata structure -->
  <xsl:include href="mapping/CHE_MD_Metadata.xsl"/>
  <!-- Data identification (title, abstract, extent, maintenance) -->
  <xsl:include href="mapping/CHE_MD_DataIdentification.xsl"/>
  <!-- Citation handling (with date resolution) -->
  <xsl:include href="mapping/CI_Citation.xsl"/>
  <!-- Date information (citation, creation, modification dates) -->
  <xsl:include href="mapping/CI_Date.xsl"/>
  <!-- Contact and responsibility information -->
  <xsl:include href="mapping/CI_Responsibility.xsl"/>
  <!-- Identifiers and metadata scope -->
  <xsl:include href="mapping/CI_Identifier.xsl"/>
  <!-- Language and locale information -->
  <xsl:include href="mapping/PT_Locale.xsl"/>
  <!-- Resource maintenance (frequency codes, notes) -->
  <xsl:include href="mapping/CHE_MD_MaintenanceInformation.xsl"/>
  <!-- Distribution and online resources -->
  <xsl:include href="mapping/MD_Distribution.xsl"/>
  <!-- Geographic and temporal extent -->
  <xsl:include href="mapping/EX_Extent.xsl"/>
  <!-- Resource lineage -->
  <xsl:include href="mapping/LI_Lineage.xsl"/>
  <!-- Utility templates -->
  <xsl:include href="utility/multilingual-text.xsl"/>
  <xsl:include href="utility/references.xsl"/>
  <xsl:include href="utility/languages.xsl"/>

  <!-- Optional UUID override -->
  <xsl:param name="uuid" as="xs:string?"/>

  <!-- Keys for reference resolution -->
  <xsl:key name="byTID"
    match="/ili:transfer/ili:datasection/eCH0271:eCH0271//*[@ili:tid]"
    use="@ili:tid"/>

  <xsl:key name="dataIdentByMetadataRef"
    match="//eCH0271:CHE_MD_DataIdentification"
    use="eCH0271:MD_Metadata/@ili:ref"/>

  <!-- ISO codelist base URLs -->
  <xsl:variable name="CL"
    select="'https://standards.iso.org/iso/19115/resources/Codelists/cat/codelists.xml#'"/>

  <!-- ================================================================
       Named templates for code elements with attributes
       ================================================================ -->
  
  <!-- Generate lan:LanguageCode with codeList and codeListValue -->
  <xsl:template name="language-code">
    <xsl:param name="value" as="xs:string"/>
    <xsl:variable name="langCode" select="f271:iso639-2($value)"/>
    <lan:LanguageCode codeList="{$CL}LanguageCode" codeListValue="{$langCode}">
      <xsl:value-of select="$langCode"/>
    </lan:LanguageCode>
  </xsl:template>

  <!-- Generate lan:MD_CharacterSetCode with codeList and codeListValue -->
  <xsl:template name="character-set-code">
    <xsl:param name="value" as="xs:string"/>
    <lan:MD_CharacterSetCode codeList="{$CL}MD_CharacterSetCode" codeListValue="{$value}">
      <xsl:value-of select="$value"/>
    </lan:MD_CharacterSetCode>
  </xsl:template>

  <!-- Generate mcc:MD_ScopeCode with codeList and codeListValue -->
  <xsl:template name="scope-code">
    <xsl:param name="value" as="xs:string"/>
    <mcc:MD_ScopeCode codeList="{$CL}MD_ScopeCode" codeListValue="{$value}">
      <xsl:value-of select="$value"/>
    </mcc:MD_ScopeCode>
  </xsl:template>

  <!-- Generate cit:CI_RoleCode with codeList and codeListValue -->
  <xsl:template name="role-code">
    <xsl:param name="value" as="xs:string"/>
    <cit:CI_RoleCode codeList="{$CL}CI_RoleCode" codeListValue="{$value}">
      <xsl:value-of select="$value"/>
    </cit:CI_RoleCode>
  </xsl:template>

  <!-- Generate cit:CI_DateTypeCode with codeList and codeListValue -->
  <xsl:template name="date-type-code">
    <xsl:param name="value" as="xs:string"/>
    <cit:CI_DateTypeCode codeList="{$CL}CI_DateTypeCode" codeListValue="{$value}">
      <xsl:value-of select="$value"/>
    </cit:CI_DateTypeCode>
  </xsl:template>

  <!-- Generate mdb:MD_MaintenanceFrequencyCode with codeList and codeListValue -->
  <xsl:template name="frequency-code">
    <xsl:param name="value" as="xs:string"/>
    <mmi:MD_MaintenanceFrequencyCode codeList="{$CL}MD_MaintenanceFrequencyCode" codeListValue="{$value}">
      <xsl:value-of select="$value"/>
    </mmi:MD_MaintenanceFrequencyCode>
  </xsl:template>

  <!-- ================================================================ -->

  <xsl:template match="/">
    <!-- Locate the eCH0271.eCH0271 basket (XTF 2.4 format). -->
    <xsl:variable name="basket"
      select="/ili:transfer/ili:datasection/eCH0271:eCH0271[1]"/>

    <!-- 
      IMPORTANT: This XSLT may be applied to:
      1. eCH0271 XTF files (source format) → transformation needed
      2. CHE_MD_Metadata XML files (MEF v2 import) → pass through
      
      When GeoNetwork imports MEF v2 ZIP, it may auto-detect schema and 
      apply this XSLT to metadata.xml files. Those contain CHE XML, not XTF,
      so $basket will be empty. In that case, pass through the input unchanged.
    -->
    
    <xsl:choose>
      <xsl:when test="not($basket)">
        <!-- Input is NOT XTF INTERLIS format (e.g., already CHE XML from MEF import) -->
        <!-- Pass through unchanged (return the root element as-is) -->
        <xsl:copy>
          <xsl:copy-of select="@*"/>
          <xsl:apply-templates mode="pass-through"/>
        </xsl:copy>
      </xsl:when>
      <xsl:otherwise>
        <!-- Input IS XTF INTERLIS format → perform eCH0271 → CHE transformation -->
        <xsl:variable name="mdRecords"
          select="$basket/eCH0271:CHE_MD_Metadata"/>

        <xsl:if test="not($mdRecords)">
          <xsl:message terminate="yes">
            ERROR: No eCH0271:CHE_MD_Metadata records found in the eCH0271 basket.
          </xsl:message>
        </xsl:if>

        <!-- Handle single vs multiple metadata records
             
             WORKFLOW A - Single record: returns CHE_MD_Metadata (can be imported via XSLT transform)
             WORKFLOW B - Multiple records: returns <root> wrapper (Java handles via MEF v2)
        -->
        <xsl:choose>
          <xsl:when test="count($mdRecords) = 1">
            <!-- Single record: return unwrapped CHE_MD_Metadata -->
            <xsl:apply-templates select="$mdRecords[1]" mode="md-metadata"/>
          </xsl:when>
          <xsl:otherwise>
            <!-- Multiple records: wrap in temporary root container (Java will handle) -->
            <root>
              <xsl:apply-templates select="$mdRecords" mode="md-metadata"/>
            </root>
          </xsl:otherwise>
        </xsl:choose>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:template>

  <!-- Pass-through mode: copy input unchanged -->
  <xsl:template match="node() | @*" mode="pass-through">
    <xsl:copy>
      <xsl:apply-templates select="node() | @*" mode="pass-through"/>
    </xsl:copy>
  </xsl:template>

  <!-- dateInfo processor -->
  <xsl:template match="eCH0271:CI_Date" mode="date-info">
    <mdb:dateInfo>
      <cit:CI_Date>
        <cit:date>
          <xsl:choose>
            <xsl:when test="normalize-space(eCH0271:date) != ''">
              <gco:Date>
                <xsl:value-of select="substring(string(eCH0271:date), 1, 10)"/>
              </gco:Date>
            </xsl:when>
            <xsl:otherwise>
              <gco:Date>
                <xsl:value-of select="substring(string(current-date()), 1, 10)"/>
              </gco:Date>
            </xsl:otherwise>
          </xsl:choose>
        </cit:date>
        <xsl:if test="eCH0271:dateType">
          <cit:dateType>
            <xsl:call-template name="date-type-code">
              <xsl:with-param name="value" select="normalize-space(eCH0271:dateType)"/>
            </xsl:call-template>
          </cit:dateType>
        </xsl:if>
      </cit:CI_Date>
    </mdb:dateInfo>
  </xsl:template>

  <!-- ================================================================
       referenceSystemInfo: MD_ReferenceSystem inline to mdb:referenceSystemInfo
       ================================================================ -->
  <xsl:template match="eCH0271:referenceSystemInfo[not(@ili:ref)]" mode="reference-system">
    <xsl:if test="eCH0271:MD_ReferenceSystem">
      <xsl:apply-templates select="eCH0271:MD_ReferenceSystem" mode="reference-system-inline"/>
    </xsl:if>
  </xsl:template>

  <!-- MD_ReferenceSystem (inline processing) -->
  <xsl:template match="eCH0271:MD_ReferenceSystem" mode="reference-system-inline">
    <mdb:referenceSystemInfo>
      <mrs:MD_ReferenceSystem>
        <xsl:if test="eCH0271:referenceSystemIdentifier[@ili:ref]">
          <xsl:variable name="rsIdentId" select="eCH0271:referenceSystemIdentifier/@ili:ref"/>
          <xsl:variable name="rsIdentObj" select="key('byTID', $rsIdentId)"/>
          <xsl:if test="$rsIdentObj">
            <mrs:referenceSystemIdentifier>
              <mcc:RS_Identifier>
                <mcc:code>
                  <xsl:apply-templates select="$rsIdentObj/eCH0271:code" mode="multilingual-text"/>
                </mcc:code>
              </mcc:RS_Identifier>
            </mrs:referenceSystemIdentifier>
          </xsl:if>
        </xsl:if>
      </mrs:MD_ReferenceSystem>
    </mdb:referenceSystemInfo>
  </xsl:template>

  <!-- ================================================================
       referenceSystemInfo: MD_ReferenceSystem reference (with ili:ref)
       ================================================================ -->
  <xsl:template match="eCH0271:referenceSystemInfo[@ili:ref]" mode="reference-system">
    <xsl:variable name="refSysId" select="@ili:ref"/>
    <xsl:variable name="refSysObj" select="key('byTID', $refSysId)"/>

    <xsl:if test="$refSysObj/self::eCH0271:MD_ReferenceSystem">
      <mdb:referenceSystemInfo>
        <mrs:MD_ReferenceSystem>
          <xsl:if test="$refSysObj/eCH0271:referenceSystemIdentifier[@ili:ref]">
            <xsl:variable name="rsIdentId" select="$refSysObj/eCH0271:referenceSystemIdentifier/@ili:ref"/>
            <xsl:variable name="rsIdentObj" select="key('byTID', $rsIdentId)"/>
            <xsl:if test="$rsIdentObj">
              <mrs:referenceSystemIdentifier>
                <mcc:MD_Identifier>
                  <mcc:code>
                    <xsl:apply-templates select="$rsIdentObj/eCH0271:code" mode="multilingual-text"/>
                  </mcc:code>
                </mcc:MD_Identifier>
              </mrs:referenceSystemIdentifier>
            </xsl:if>
          </xsl:if>
        </mrs:MD_ReferenceSystem>
      </mdb:referenceSystemInfo>
    </xsl:if>
  </xsl:template>

  <!-- ================================================================
       distribution: resolve @ili:ref → MD_Distribution via modular mapping
       ================================================================ -->
  <xsl:template match="eCH0271:distributionInfo[@ili:ref]" mode="distribution">
    <xsl:variable name="distId" select="@ili:ref"/>
    <xsl:variable name="distObj" select="key('byTID', $distId)"/>

    <xsl:if test="$distObj/self::eCH0271:MD_Distribution">
      <mdb:distributionInfo>
        <xsl:call-template name="f271:MD_Distribution">
          <xsl:with-param name="distRecord" select="$distObj"/>
          <xsl:with-param name="basket" select="/ili:transfer/ili:datasection/eCH0271:eCH0271[1]"/>
        </xsl:call-template>
      </mdb:distributionInfo>
    </xsl:if>
  </xsl:template>

  <!-- ================================================================
       basic-geodata-info: CHE_MD_BasicGeodataInformation
       ================================================================ -->
  <xsl:template match="eCH0271:basicGeodataInformation" mode="basic-geodata-info">
    <che:basicGeodataInformation>
      <xsl:if test="eCH0271:CHE_MD_BasicGeodataInformation">
        <che:CHE_MD_BasicGeodataInformation>
          <xsl:if test="eCH0271:CHE_MD_BasicGeodataInformation/eCH0271:basicGeodataID">
            <che:basicGeodataID>
              <gco:CharacterString>
                <xsl:value-of select="normalize-space(eCH0271:CHE_MD_BasicGeodataInformation/eCH0271:basicGeodataID)"/>
              </gco:CharacterString>
            </che:basicGeodataID>
          </xsl:if>
          <xsl:if test="eCH0271:CHE_MD_BasicGeodataInformation/eCH0271:basicGeodataLegalLevel">
            <che:basicGeodataLegalLevel>
              <che:CHE_MD_LevelCode codeList="mdLevelCode" codeListValue="{normalize-space(eCH0271:CHE_MD_BasicGeodataInformation/eCH0271:basicGeodataLegalLevel)}"/>
            </che:basicGeodataLegalLevel>
          </xsl:if>
        </che:CHE_MD_BasicGeodataInformation>
      </xsl:if>
    </che:basicGeodataInformation>
  </xsl:template>

</xsl:stylesheet>
