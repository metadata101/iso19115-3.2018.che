<?xml version="1.0" encoding="UTF-8"?>
<!-- eCH0271 XTF 2.4 → ISO 19115-3:2018 CHE
     Converts INTERLIS metadata format to modern ISO standard
     XSLT 2.0, Saxon HE 9.1+ compatible -->
<xsl:stylesheet version="2.0"
  xmlns:xsl  ="http://www.w3.org/1999/XSL/Transform"
  xmlns:xs   ="http://www.w3.org/2001/XMLSchema"
  xmlns:ili  ="http://www.interlis.ch/xtf/2.4/INTERLIS"
  xmlns:eCH0271_1="http://www.interlis.ch/xtf/2.4/eCH0271_1"
  xmlns:Localisation_V2="http://www.interlis.ch/xtf/2.4/Localisation_V2"
  xmlns:LocalisationCH_V2="http://www.interlis.ch/xtf/2.4/LocalisationCH_V2"
  xmlns:ech0271 ="urn:ech0271-functions"
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
  <!-- Contact and responsibility information -->
  <xsl:include href="mapping/CI_Responsibility.xsl"/>
  <!-- Identifiers and metadata scope -->
  <xsl:include href="mapping/CI_Identifier.xsl"/>
  <!-- Language and locale information -->
  <xsl:include href="mapping/PT_Locale.xsl"/>
  <!-- Resource maintenance (frequency codes, notes) -->
  <xsl:include href="mapping/maintenance-info.xsl"/>
  <!-- Distribution and online resources -->
  <xsl:include href="mapping/distribution.xsl"/>
  <!-- Geographic and temporal extent -->
  <xsl:include href="mapping/extent.xsl"/>
  <!-- Legislative information -->
  <xsl:include href="mapping/legislation.xsl"/>
  <!-- Utility templates -->
  <xsl:include href="utility/multilingual-text.xsl"/>

  <!-- Optional UUID override -->
  <xsl:param name="uuid" as="xs:string?"/>

  <!-- Keys for reference resolution -->
  <xsl:key name="byTID"
    match="/ili:transfer/ili:datasection/eCH0271_1:eCH0271//*[@ili:tid]"
    use="@ili:tid"/>

  <xsl:key name="dataIdentByMetadataRef"
    match="//eCH0271_1:CHE_MD_DataIdentification"
    use="eCH0271_1:MD_Metadata/@ili:ref"/>

  <!-- ISO codelist base URLs -->
  <xsl:variable name="CL"
    select="'https://standards.iso.org/iso/19115/resources/Codelists/cat/codelists.xml#'"/>
  <xsl:variable name="CL_lan"
    select="'http://standards.iso.org/iso/19115/resources/Codelist/lan/'"/>
  <xsl:variable name="CL_cit"
    select="'http://standards.iso.org/iso/19115/resources/Codelist/cit/'"/>
  <xsl:variable name="CL_mcc"
    select="'http://standards.iso.org/iso/19115/resources/Codelist/mcc/'"/>

  <!-- ================================================================
       Named templates for code elements with attributes
       ================================================================ -->
  
  <!-- Generate lan:LanguageCode with codeList and codeListValue -->
  <xsl:template name="language-code">
    <xsl:param name="value" as="xs:string"/>
    <lan:LanguageCode codeList="http://standards.iso.org/iso/19115/resources/Codelist/lan/LanguageCode.xml" codeListValue="{$value}">
      <xsl:value-of select="$value"/>
    </lan:LanguageCode>
  </xsl:template>

  <!-- Generate lan:MD_CharacterSetCode with codeList and codeListValue -->
  <xsl:template name="character-set-code">
    <xsl:param name="value" as="xs:string"/>
    <lan:MD_CharacterSetCode codeList="http://standards.iso.org/iso/19115/resources/Codelist/lan/MD_CharacterSetCode.xml" codeListValue="{$value}">
      <xsl:value-of select="$value"/>
    </lan:MD_CharacterSetCode>
  </xsl:template>

  <!-- Generate mcc:MD_ScopeCode with codeList and codeListValue -->
  <xsl:template name="scope-code">
    <xsl:param name="value" as="xs:string"/>
    <mcc:MD_ScopeCode codeList="http://standards.iso.org/iso/19115/resources/Codelist/mcc/MD_ScopeCode.xml" codeListValue="{$value}">
      <xsl:value-of select="$value"/>
    </mcc:MD_ScopeCode>
  </xsl:template>

  <!-- Generate cit:CI_RoleCode with codeList and codeListValue -->
  <xsl:template name="role-code">
    <xsl:param name="value" as="xs:string"/>
    <cit:CI_RoleCode codeList="http://standards.iso.org/iso/19115/resources/Codelist/cit/CI_RoleCode.xml" codeListValue="{$value}">
      <xsl:value-of select="$value"/>
    </cit:CI_RoleCode>
  </xsl:template>

  <!-- Generate cit:CI_DateTypeCode with codeList and codeListValue -->
  <xsl:template name="date-type-code">
    <xsl:param name="value" as="xs:string"/>
    <cit:CI_DateTypeCode codeList="http://standards.iso.org/iso/19115/resources/Codelist/cit/CI_DateTypeCode.xml" codeListValue="{$value}">
      <xsl:value-of select="$value"/>
    </cit:CI_DateTypeCode>
  </xsl:template>

  <!-- Generate mdb:MD_MaintenanceFrequencyCode with codeList and codeListValue -->
  <xsl:template name="frequency-code">
    <xsl:param name="value" as="xs:string"/>
    <mmi:MD_MaintenanceFrequencyCode codeList="https://www.isotc211.org/2005/resources/Codelist/gmxCodelists.xml#MD_MaintenanceFrequencyCode" codeListValue="{$value}">
      <xsl:value-of select="$value"/>
    </mmi:MD_MaintenanceFrequencyCode>
  </xsl:template>

  <!-- ================================================================ -->

  
  <xsl:template match="/">
    <!-- Locate the eCH0271_1.eCH0271 basket (XTF 2.4 format). -->
    <xsl:variable name="basket"
      select="/ili:transfer/ili:datasection/eCH0271_1:eCH0271[1]"/>

    <xsl:if test="not($basket)">
      <xsl:message terminate="yes">
        ERROR: No eCH0271_1:eCH0271 basket found in XTF 2.4 format.
      </xsl:message>
    </xsl:if>

    <xsl:variable name="mdRecords"
      select="$basket/eCH0271_1:CHE_MD_Metadata"/>

    <xsl:if test="not($mdRecords)">
      <xsl:message terminate="yes">
        ERROR: No eCH0271_1:CHE_MD_Metadata records found in the basket.
      </xsl:message>
    </xsl:if>

    <!-- Handle single vs multiple metadata records -->
    <xsl:choose>
      <xsl:when test="count($mdRecords) = 1">
        <xsl:apply-templates select="$mdRecords[1]" mode="md-metadata"/>
      </xsl:when>
      <xsl:otherwise>
        <che:CHE_MD_MetadataCollection>
          <xsl:apply-templates select="$mdRecords" mode="md-metadata"/>
        </che:CHE_MD_MetadataCollection>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:template>

  <!-- dateInfo processor -->
  <xsl:template match="eCH0271_1:CI_Date" mode="date-info">
    <mdb:dateInfo>
      <cit:CI_Date>
        <cit:date>
          <xsl:choose>
            <xsl:when test="normalize-space(eCH0271_1:date) != ''">
              <gco:Date>
                <xsl:value-of select="substring(string(eCH0271_1:date), 1, 10)"/>
              </gco:Date>
            </xsl:when>
            <xsl:otherwise>
              <gco:Date>
                <xsl:value-of select="substring(string(current-date()), 1, 10)"/>
              </gco:Date>
            </xsl:otherwise>
          </xsl:choose>
        </cit:date>
        <xsl:if test="eCH0271_1:dateType">
          <cit:dateType>
            <xsl:call-template name="date-type-code">
              <xsl:with-param name="value" select="normalize-space(eCH0271_1:dateType)"/>
            </xsl:call-template>
          </cit:dateType>
        </xsl:if>
      </cit:CI_Date>
    </mdb:dateInfo>
  </xsl:template>

  <!-- ================================================================
       metadataStandard: CI_Citation → mdb:metadataStandard
       ================================================================ -->
  <xsl:template match="eCH0271_1:standardUsedBymetadataStandard[@ili:ref]" mode="metadata-standard">
    <xsl:variable name="citId" select="@ili:ref"/>
    <xsl:variable name="citObj" select="key('byTID', $citId)"/>

    <xsl:if test="$citObj/self::eCH0271_1:CI_Citation">
      <mdb:metadataStandard>
        <cit:CI_Citation>
          <xsl:if test="$citObj/eCH0271_1:title">
            <cit:title>
              <xsl:apply-templates select="$citObj/eCH0271_1:title" mode="multilingual-text"/>
            </cit:title>
          </xsl:if>
          <xsl:if test="$citObj/eCH0271_1:date">
            <cit:date>
              <cit:CI_Date>
                <cit:date>
                  <xsl:value-of select="$citObj/eCH0271_1:date"/>
                </cit:date>
              </cit:CI_Date>
            </cit:date>
          </xsl:if>
        </cit:CI_Citation>
      </mdb:metadataStandard>
    </xsl:if>
  </xsl:template>

  <!-- ================================================================
       referenceSystemInfo: MD_ReferenceSystem inline to mdb:referenceSystemInfo
       ================================================================ -->
  <xsl:template match="eCH0271_1:referenceSystemInfo[not(@ili:ref)]" mode="reference-system">
    <xsl:if test="eCH0271_1:MD_ReferenceSystem">
      <xsl:apply-templates select="eCH0271_1:MD_ReferenceSystem" mode="reference-system-inline"/>
    </xsl:if>
  </xsl:template>

  <!-- MD_ReferenceSystem (inline processing) -->
  <xsl:template match="eCH0271_1:MD_ReferenceSystem" mode="reference-system-inline">
    <mdb:referenceSystemInfo>
      <mrs:MD_ReferenceSystem>
        <xsl:if test="eCH0271_1:referenceSystemIdentifier[@ili:ref]">
          <xsl:variable name="rsIdentId" select="eCH0271_1:referenceSystemIdentifier/@ili:ref"/>
          <xsl:variable name="rsIdentObj" select="key('byTID', $rsIdentId)"/>
          <xsl:if test="$rsIdentObj">
            <mrs:referenceSystemIdentifier>
              <mcc:RS_Identifier>
                <mcc:code>
                  <xsl:apply-templates select="$rsIdentObj/eCH0271_1:code" mode="multilingual-text"/>
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
  <xsl:template match="eCH0271_1:referenceSystemInfo[@ili:ref]" mode="reference-system">
    <xsl:variable name="refSysId" select="@ili:ref"/>
    <xsl:variable name="refSysObj" select="key('byTID', $refSysId)"/>

    <xsl:if test="$refSysObj/self::eCH0271_1:MD_ReferenceSystem">
      <mdb:referenceSystemInfo>
        <mrs:MD_ReferenceSystem>
          <xsl:if test="$refSysObj/eCH0271_1:referenceSystemIdentifier[@ili:ref]">
            <xsl:variable name="rsIdentId" select="$refSysObj/eCH0271_1:referenceSystemIdentifier/@ili:ref"/>
            <xsl:variable name="rsIdentObj" select="key('byTID', $rsIdentId)"/>
            <xsl:if test="$rsIdentObj">
              <mrs:referenceSystemIdentifier>
                <mcc:MD_Identifier>
                  <mcc:code>
                    <xsl:apply-templates select="$rsIdentObj/eCH0271_1:code" mode="multilingual-text"/>
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
  <xsl:template match="eCH0271_1:distributionInfo[@ili:ref]" mode="distribution">
    <xsl:variable name="distId" select="@ili:ref"/>
    <xsl:variable name="distObj" select="key('byTID', $distId)"/>

    <xsl:if test="$distObj/self::eCH0271_1:MD_Distribution">
      <mdb:distributionInfo>
        <xsl:call-template name="ech0271:MD_Distribution">
          <xsl:with-param name="distRecord" select="$distObj"/>
          <xsl:with-param name="basket" select="/ili:transfer/ili:datasection/eCH0271_1:eCH0271[1]"/>
        </xsl:call-template>
      </mdb:distributionInfo>
    </xsl:if>
  </xsl:template>

  <!-- ================================================================
       legislation: resolve @ili:ref → CHE_MD_Legislation via modular mapping
       ================================================================ -->
  <xsl:template match="eCH0271_1:legislationInformation[@ili:ref]" mode="legislation">
    <xsl:variable name="legisId" select="@ili:ref"/>
    <xsl:variable name="legisObj" select="key('byTID', $legisId)"/>

    <xsl:if test="$legisObj/self::eCH0271_1:CHE_MD_Legislation">
      <che:legislationInformation>
        <xsl:call-template name="ech0271:CHE_MD_Legislation">
          <xsl:with-param name="legisRecord" select="$legisObj"/>
          <xsl:with-param name="basket" select="/ili:transfer/ili:datasection/eCH0271_1:eCH0271[1]"/>
        </xsl:call-template>
      </che:legislationInformation>
    </xsl:if>
  </xsl:template>

  <!-- ================================================================
       extent: resolve @ili:ref → EX_Extent
       ================================================================ -->
  <xsl:template match="eCH0271_1:extent[@ili:ref]" mode="extent">
    <xsl:variable name="extentId" select="@ili:ref"/>
    <xsl:variable name="extentObj" select="key('byTID', $extentId)"/>
    
    <xsl:if test="$extentObj/self::eCH0271_1:EX_Extent">
      <gex:EX_Extent>
        <xsl:if test="$extentObj/eCH0271_1:description">
          <gex:description>
            <gco:CharacterString>
              <xsl:value-of select="normalize-space($extentObj/eCH0271_1:description)"/>
            </gco:CharacterString>
          </gex:description>
        </xsl:if>
        <xsl:if test="$extentObj/eCH0271_1:geographicElement[@ili:ref]">
          <gex:geographicElement>
            <xsl:apply-templates select="$extentObj/eCH0271_1:geographicElement[@ili:ref]" mode="geographic-element"/>
          </gex:geographicElement>
        </xsl:if>
      </gex:EX_Extent>
    </xsl:if>
  </xsl:template>

  <!-- ================================================================
       geographic-element: resolve @ili:ref → EX_GeographicBoundingBox
       ================================================================ -->
  <xsl:template match="eCH0271_1:geographicElement[@ili:ref]" mode="geographic-element">
    <xsl:variable name="bboxId" select="@ili:ref"/>
    <xsl:variable name="bboxObj" select="key('byTID', $bboxId)"/>
    
    <xsl:if test="$bboxObj/self::eCH0271_1:EX_GeographicBoundingBox">
      <gex:EX_GeographicBoundingBox>
        <gex:westBoundLongitude>
          <gco:Decimal>
            <xsl:value-of select="normalize-space($bboxObj/eCH0271_1:westBoundLongitude)"/>
          </gco:Decimal>
        </gex:westBoundLongitude>
        <gex:eastBoundLongitude>
          <gco:Decimal>
            <xsl:value-of select="normalize-space($bboxObj/eCH0271_1:eastBoundLongitude)"/>
          </gco:Decimal>
        </gex:eastBoundLongitude>
        <gex:southBoundLatitude>
          <gco:Decimal>
            <xsl:value-of select="normalize-space($bboxObj/eCH0271_1:southBoundLatitude)"/>
          </gco:Decimal>
        </gex:southBoundLatitude>
        <gex:northBoundLatitude>
          <gco:Decimal>
            <xsl:value-of select="normalize-space($bboxObj/eCH0271_1:northBoundLatitude)"/>
          </gco:Decimal>
        </gex:northBoundLatitude>
      </gex:EX_GeographicBoundingBox>
    </xsl:if>
  </xsl:template>

  <!-- ================================================================
       browse-graphic: resolve @ili:ref → MD_BrowseGraphic
       ================================================================ -->
  <xsl:template match="eCH0271_1:graphicOverview[@ili:ref]" mode="browse-graphic">
    <xsl:variable name="graphicId" select="@ili:ref"/>
    <xsl:variable name="graphicObj" select="key('byTID', $graphicId)"/>
    
    <xsl:if test="$graphicObj/self::eCH0271_1:MD_BrowseGraphic">
      <mcc:MD_BrowseGraphic>
        <xsl:if test="$graphicObj/eCH0271_1:fileName">
          <mcc:fileName>
            <gco:CharacterString>
              <xsl:value-of select="normalize-space($graphicObj/eCH0271_1:fileName)"/>
            </gco:CharacterString>
          </mcc:fileName>
        </xsl:if>
      </mcc:MD_BrowseGraphic>
    </xsl:if>
  </xsl:template>

  <!-- ================================================================
       legal-constraints: resolve @ili:ref → MD_LegalConstraints
       ================================================================ -->
  <xsl:template match="eCH0271_1:resourceConstraints[@ili:ref]" mode="legal-constraints">
    <xsl:variable name="constraintId" select="@ili:ref"/>
    <xsl:variable name="constraintObj" select="key('byTID', $constraintId)"/>
    
    <xsl:if test="$constraintObj/self::eCH0271_1:CHE_MD_LegalConstraints">
      <mco:MD_LegalConstraints>
        <xsl:if test="$constraintObj/eCH0271_1:useConstraints">
          <mco:useConstraints>
            <mco:MD_RestrictionCode codeList="{$CL}MD_RestrictionCode" codeListValue="{normalize-space($constraintObj/eCH0271_1:useConstraints)}">
              <xsl:value-of select="normalize-space($constraintObj/eCH0271_1:useConstraints)"/>
            </mco:MD_RestrictionCode>
          </mco:useConstraints>
        </xsl:if>
        <xsl:if test="$constraintObj/eCH0271_1:otherConstraints">
          <mco:otherConstraints>
            <gco:CharacterString>
              <xsl:value-of select="normalize-space($constraintObj/eCH0271_1:otherConstraints)"/>
            </gco:CharacterString>
          </mco:otherConstraints>
        </xsl:if>
      </mco:MD_LegalConstraints>
    </xsl:if>
  </xsl:template>



  <!-- ================================================================
       basic-geodata-info: CHE_MD_BasicGeodataInformation
       ================================================================ -->
  <xsl:template match="eCH0271_1:basicGeodataInformation" mode="basic-geodata-info">
    <che:basicGeodataInformation>
      <xsl:if test="eCH0271_1:CHE_MD_BasicGeodataInformation">
        <che:CHE_MD_BasicGeodataInformation>
          <xsl:if test="eCH0271_1:CHE_MD_BasicGeodataInformation/eCH0271_1:basicGeodataID">
            <che:basicGeodataID>
              <gco:CharacterString>
                <xsl:value-of select="normalize-space(eCH0271_1:CHE_MD_BasicGeodataInformation/eCH0271_1:basicGeodataID)"/>
              </gco:CharacterString>
            </che:basicGeodataID>
          </xsl:if>
          <xsl:if test="eCH0271_1:CHE_MD_BasicGeodataInformation/eCH0271_1:basicGeodataLegalLevel">
            <che:basicGeodataLegalLevel>
              <che:CHE_MD_LevelCode codeList="mdLevelCode" codeListValue="{normalize-space(eCH0271_1:CHE_MD_BasicGeodataInformation/eCH0271_1:basicGeodataLegalLevel)}"/>
            </che:basicGeodataLegalLevel>
          </xsl:if>
        </che:CHE_MD_BasicGeodataInformation>
      </xsl:if>
    </che:basicGeodataInformation>
  </xsl:template>

</xsl:stylesheet>
