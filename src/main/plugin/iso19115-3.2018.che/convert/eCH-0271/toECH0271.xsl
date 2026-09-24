<?xml version="1.0" encoding="UTF-8"?>
<!-- ISO 19115-3:2018 CHE → eCH0271 XTF 2.4 reverse converter
     Generates flat basket structure with proper @ili:tid/@ili:ref linking -->
<xsl:stylesheet version="2.0"
  xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
  xmlns:xs="http://www.w3.org/2001/XMLSchema"
  xmlns:ili="http://www.interlis.ch/xtf/2.4/INTERLIS"
  xmlns:eCH0271_1="http://www.interlis.ch/xtf/2.4/eCH0271_1"
  xmlns:Localisation_V2="http://www.interlis.ch/xtf/2.4/Localisation_V2"
  xmlns:che="http://geocat.ch/che"
  xmlns:mdb="http://standards.iso.org/iso/19115/-3/mdb/2.0"
  xmlns:mri="http://standards.iso.org/iso/19115/-3/mri/1.0"
  xmlns:mrd="http://standards.iso.org/iso/19115/-3/mrd/1.0"
  xmlns:cit="http://standards.iso.org/iso/19115/-3/cit/2.0"
  xmlns:gex="http://standards.iso.org/iso/19115/-3/gex/1.0"
  xmlns:mdq="http://standards.iso.org/iso/19115/-3/mdq/1.0"
  xmlns:mcc="http://standards.iso.org/iso/19115/-3/mcc/1.0"
  xmlns:lan="http://standards.iso.org/iso/19115/-3/lan/1.0"
  xmlns:gco="http://standards.iso.org/iso/19115/-3/gco/1.0"
  xmlns:mrl="http://standards.iso.org/iso/19115/-3/mrl/2.0"
  xmlns:mrs="http://standards.iso.org/iso/19115/-3/mrs/1.0"
  xmlns:mco="http://standards.iso.org/iso/19115/-3/mco/1.0"
  exclude-result-prefixes="xsl xs che mdb mri mrd cit gex mdq mcc lan gco mrl mrs mco">

  <xsl:output method="xml" version="1.0" encoding="UTF-8" indent="yes"/>
  <xsl:strip-space elements="*"/>

  <xsl:param name="uuid" as="xs:string?"/>

  <!-- Root template: generate XTF transfer with flat basket -->
  <xsl:template match="/">
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
        <!-- Wrap all elements in eCH0271 basket container for XTF 2.4 compliance -->
        <eCH0271_1:eCH0271 ili:bid="eCH0271_1.eCH0271">
          <!-- Generate all elements from CHE_MD_Metadata in flat structure -->
          <xsl:apply-templates select="//che:CHE_MD_Metadata | //mdb:MD_Metadata" mode="flatten"/>
        </eCH0271_1:eCH0271>
      </ili:datasection>
    </ili:transfer>
  </xsl:template>

  <!-- Main CHE_MD_Metadata: flatten all contained elements -->
  <xsl:template match="che:CHE_MD_Metadata | mdb:MD_Metadata" mode="flatten">
    <xsl:variable name="mdTID" select="generate-id(.)"/>
    <xsl:variable name="mdUUID">
      <xsl:choose>
        <xsl:when test="normalize-space($uuid) != ''">
          <xsl:value-of select="$uuid"/>
        </xsl:when>
        <xsl:when test="mdb:metadataIdentifier/*/mcc:code/gco:CharacterString">
          <xsl:value-of select="normalize-space(mdb:metadataIdentifier/*/mcc:code/gco:CharacterString)"/>
        </xsl:when>
        <xsl:otherwise>
          <xsl:value-of select="concat('md-', generate-id(.))"/>
        </xsl:otherwise>
      </xsl:choose>
    </xsl:variable>

    <!-- Generate all referenced elements first (bottom-up) -->
    
    <!-- MD_Identifier for metadataIdentifier -->
    <xsl:if test="mdb:metadataIdentifier/*/mcc:code/gco:CharacterString">
      <xsl:variable name="mdIdTID" select="generate-id(mdb:metadataIdentifier)"/>
      <eCH0271_1:MD_Identifier ili:tid="MDID_{$mdIdTID}">
        <eCH0271_1:code>
          <xsl:value-of select="normalize-space(mdb:metadataIdentifier/*/mcc:code/gco:CharacterString)"/>
        </eCH0271_1:code>
      </eCH0271_1:MD_Identifier>
    </xsl:if>

    <!-- MD_MetadataScope -->
    <xsl:if test="mdb:metadataScope">
      <xsl:variable name="scopeTID" select="generate-id(mdb:metadataScope[1])"/>
      <eCH0271_1:MD_MetadataScope ili:tid="SCOPE_{$scopeTID}">
        <xsl:if test="mdb:metadataScope/mdb:MD_MetadataScope/mdb:resourceScope/mdb:MD_ScopeCode">
          <eCH0271_1:resourceScope>
            <xsl:value-of select="normalize-space(mdb:metadataScope/mdb:MD_MetadataScope/mdb:resourceScope/mdb:MD_ScopeCode)"/>
          </eCH0271_1:resourceScope>
        </xsl:if>
        <xsl:if test="mdb:metadataScope/mdb:MD_MetadataScope/mdb:name/gco:CharacterString">
          <eCH0271_1:name>
            <xsl:value-of select="normalize-space(mdb:metadataScope/mdb:MD_MetadataScope/mdb:name/gco:CharacterString)"/>
          </eCH0271_1:name>
        </xsl:if>
      </eCH0271_1:MD_MetadataScope>
    </xsl:if>

    <!-- Contact/Responsibility elements and associated organisations -->
    <xsl:for-each select="mdb:contact | mri:pointOfContact">
      <!-- Generate organisation first if referenced -->
      <xsl:variable name="partyElem" select="(cit:CI_Responsibility | cit:CI_ResponsibleParty)/cit:party[1]"/>
      <xsl:if test="$partyElem">
        <xsl:call-template name="generate-organisation">
          <xsl:with-param name="elem" select="$partyElem"/>
        </xsl:call-template>
      </xsl:if>
      <!-- Then generate responsibility -->
      <xsl:call-template name="generate-responsibility">
        <xsl:with-param name="elem" select="."/>
      </xsl:call-template>
    </xsl:for-each>

    <!-- Citation elements (from metadata standard and data identification) -->
    <xsl:for-each select="mdb:metadataStandard/*/descendant::cit:CI_Citation">
      <xsl:call-template name="generate-citation">
        <xsl:with-param name="elem" select="."/>
      </xsl:call-template>
    </xsl:for-each>
    <xsl:for-each select="mdb:identificationInfo/*/mri:citation/cit:CI_Citation">
      <xsl:call-template name="generate-citation">
        <xsl:with-param name="elem" select="."/>
      </xsl:call-template>
    </xsl:for-each>

    <!-- Extent and bounding boxes -->
    <xsl:for-each select="mdb:identificationInfo/*/mri:extent/gex:EX_Extent">
      <xsl:call-template name="generate-extent">
        <xsl:with-param name="elem" select="."/>
      </xsl:call-template>
    </xsl:for-each>

    <!-- Distribution elements -->
    <xsl:for-each select="mdb:distributionInfo/mrd:MD_Distribution">
      <xsl:call-template name="generate-distribution">
        <xsl:with-param name="elem" select="."/>
      </xsl:call-template>
    </xsl:for-each>

    <!-- Reference system -->
    <xsl:for-each select="mdb:referenceSystemInfo">
      <xsl:variable name="refSysTID" select="generate-id(.)"/>
      <eCH0271_1:MD_ReferenceSystem ili:tid="REFSYS_{$refSysTID}"/>
    </xsl:for-each>

    <!-- Point of contact from data identification -->
    <xsl:for-each select="mdb:identificationInfo/*/mri:pointOfContact">
      <xsl:variable name="partyElem" select="(cit:CI_Responsibility | cit:CI_ResponsibleParty)/cit:party[1]"/>
      <xsl:if test="$partyElem">
        <xsl:call-template name="generate-organisation">
          <xsl:with-param name="elem" select="$partyElem"/>
        </xsl:call-template>
      </xsl:if>
      <xsl:call-template name="generate-responsibility">
        <xsl:with-param name="elem" select="."/>
      </xsl:call-template>
    </xsl:for-each>

    <!-- CHE_MD_DataIdentification (main) -->
    <xsl:for-each select="mdb:identificationInfo">
      <xsl:variable name="diTID" select="generate-id(.)"/>
      <eCH0271_1:CHE_MD_DataIdentification ili:tid="DI_{$diTID}">
        <xsl:if test="*/mri:citation">
          <xsl:variable name="citTID" select="generate-id(*/mri:citation[1])"/>
          <eCH0271_1:MD_Metadata ili:ref="CIT_{$citTID}"/>
        </xsl:if>
        <xsl:if test="*/mri:abstract/gco:CharacterString | */mri:abstract/*/text()">
          <eCH0271_1:abstract>
            <xsl:value-of select="normalize-space((*/mri:abstract/gco:CharacterString | */mri:abstract/*/text())[1])"/>
          </eCH0271_1:abstract>
        </xsl:if>
        <xsl:if test="*/mri:status">
          <eCH0271_1:status>
            <xsl:value-of select="normalize-space((*/mri:status/mcc:MD_ProgressCode/@codeListValue | */mri:status/mcc:MD_ProgressCode/text())[1])"/>
          </eCH0271_1:status>
        </xsl:if>
        <xsl:if test="*/mri:pointOfContact">
          <xsl:variable name="poTID" select="generate-id(*/mri:pointOfContact[1])"/>
          <eCH0271_1:pointOfContact ili:ref="RESP_{$poTID}"/>
        </xsl:if>
        <xsl:if test="*/mri:topicCategory">
          <eCH0271_1:topicCategory>
            <xsl:value-of select="normalize-space((*/mri:topicCategory/mri:MD_TopicCategoryCode/text() | */mri:topicCategory/mri:MD_TopicCategoryCode)[1])"/>
          </eCH0271_1:topicCategory>
        </xsl:if>
        <xsl:if test="*/mri:extent">
          <xsl:variable name="extTID" select="generate-id(*/mri:extent[1]/gex:EX_Extent)"/>
          <eCH0271_1:extent ili:ref="EXT_{$extTID}"/>
        </xsl:if>
        <xsl:if test="*/mri:resourceMaintenance">
          <xsl:variable name="rmTID" select="generate-id(*/mri:resourceMaintenance[1])"/>
          <eCH0271_1:resourceMaintenance ili:ref="RM_{$rmTID}"/>
        </xsl:if>
        <xsl:if test="*/mri:graphicOverview">
          <xsl:variable name="goTID" select="generate-id(*/mri:graphicOverview[1])"/>
          <eCH0271_1:graphicOverview ili:ref="GO_{$goTID}"/>
        </xsl:if>
        <xsl:if test="*/mri:resourceConstraints">
          <xsl:variable name="rcTID" select="generate-id(*/mri:resourceConstraints[1])"/>
          <eCH0271_1:resourceConstraints ili:ref="RC_{$rcTID}"/>
        </xsl:if>
        <xsl:if test="*/mri:defaultLocale">
          <xsl:variable name="dlTID" select="generate-id(*/mri:defaultLocale[1])"/>
          <eCH0271_1:defaultLocale ili:ref="DL_{$dlTID}"/>
        </xsl:if>
      </eCH0271_1:CHE_MD_DataIdentification>
    </xsl:for-each>

    <!-- MD_Distribution -->
    <xsl:for-each select="mdb:distributionInfo/mrd:MD_Distribution">
      <xsl:variable name="distTID" select="generate-id(.)"/>
      <eCH0271_1:MD_Distribution ili:tid="DIST_{$distTID}">
        <xsl:for-each select="mrd:transferOptions/mrd:MD_DigitalTransferOptions/mrd:onLine/cit:CI_OnlineResource">
          <xsl:variable name="orTID" select="generate-id(.)"/>
          <eCH0271_1:transferOptions ili:ref="OR_{$orTID}"/>
        </xsl:for-each>
      </eCH0271_1:MD_Distribution>
    </xsl:for-each>

    <!-- Main CHE_MD_Metadata -->
    <eCH0271_1:CHE_MD_Metadata ili:tid="MD_{$mdTID}">
      <eCH0271_1:fileIdentifier>
        <xsl:value-of select="$mdUUID"/>
      </eCH0271_1:fileIdentifier>

      <xsl:if test="mdb:metadataIdentifier/*/mcc:code/gco:CharacterString">
        <xsl:variable name="mdIdTID" select="generate-id(mdb:metadataIdentifier)"/>
        <eCH0271_1:metadataIdentifier ili:ref="MDID_{$mdIdTID}"/>
      </xsl:if>

      <xsl:if test="mdb:defaultLocale">
        <eCH0271_1:defaultLocale>
          <eCH0271_1:PT_Locale>
            <xsl:variable name="langCode" select="normalize-space(mdb:defaultLocale/*/lan:language/*/text())"/>
            <eCH0271_1:language>
              <xsl:choose>
                <xsl:when test="$langCode = 'ger' or $langCode = 'deu'">deu</xsl:when>
                <xsl:when test="$langCode = 'fra' or $langCode = 'fre'">fre</xsl:when>
                <xsl:when test="$langCode = 'ita'">ita</xsl:when>
                <xsl:when test="$langCode = 'eng'">eng</xsl:when>
                <xsl:when test="$langCode = 'roh'">roh</xsl:when>
                <xsl:when test="$langCode = 'de'">deu</xsl:when>
                <xsl:when test="$langCode = 'fr'">fre</xsl:when>
                <xsl:when test="$langCode = 'it'">ita</xsl:when>
                <xsl:when test="$langCode = 'en'">eng</xsl:when>
                <xsl:when test="$langCode = 'rm'">roh</xsl:when>
                <xsl:otherwise><xsl:value-of select="$langCode"/></xsl:otherwise>
              </xsl:choose>
            </eCH0271_1:language>
            <xsl:variable name="charEncoding" select="normalize-space(mdb:defaultLocale/*/lan:characterEncoding/*/text())"/>
            <xsl:if test="$charEncoding != ''">
              <eCH0271_1:characterEncoding><xsl:value-of select="$charEncoding"/></eCH0271_1:characterEncoding>
            </xsl:if>
          </eCH0271_1:PT_Locale>
        </eCH0271_1:defaultLocale>
      </xsl:if>

      <xsl:if test="mdb:metadataScope">
        <xsl:variable name="scopeTID" select="generate-id(mdb:metadataScope[1])"/>
        <eCH0271_1:metadataScope ili:ref="SCOPE_{$scopeTID}"/>
      </xsl:if>

      <xsl:if test="mdb:contact[1]">
        <xsl:variable name="respTID" select="generate-id(mdb:contact[1])"/>
        <eCH0271_1:contact ili:ref="RESP_{$respTID}"/>
      </xsl:if>

      <xsl:if test="mdb:contact[1]">
        <xsl:variable name="respTID" select="generate-id(mdb:contact[1])"/>
        <eCH0271_1:pointOfContact ili:ref="RESP_{$respTID}"/>
      </xsl:if>

      <xsl:if test="mdb:dateInfo">
        <eCH0271_1:dateInfo>
          <xsl:variable name="dateTID" select="generate-id(mdb:dateInfo[1])"/>
          <eCH0271_1:CI_Date ili:tid="DATE_{$dateTID}">
            <eCH0271_1:date>
              <xsl:value-of select="normalize-space((mdb:dateInfo/*/cit:date/gco:Date | mdb:dateInfo/*/cit:date/gco:DateTime)[1])"/>
            </eCH0271_1:date>
            <xsl:variable name="dateTypeCode" select="normalize-space((mdb:dateInfo/*/cit:dateType/cit:CI_DateTypeCode/@codeListValue | mdb:dateInfo/*/cit:dateType/cit:CI_DateTypeCode/text())[1])"/>
            <xsl:if test="$dateTypeCode != ''">
              <eCH0271_1:dateType><xsl:value-of select="$dateTypeCode"/></eCH0271_1:dateType>
            </xsl:if>
          </eCH0271_1:CI_Date>
        </eCH0271_1:dateInfo>
      </xsl:if>

      <xsl:if test="mdb:metadataStandard/*/cit:title/gco:CharacterString">
        <eCH0271_1:metadataStandardName>
          <xsl:value-of select="normalize-space(mdb:metadataStandard/*/cit:title/gco:CharacterString)"/>
        </eCH0271_1:metadataStandardName>
      </xsl:if>

      <xsl:if test="mdb:referenceSystemInfo">
        <xsl:variable name="refSysTID" select="generate-id(mdb:referenceSystemInfo[1])"/>
        <eCH0271_1:referenceSystemInfo ili:ref="REFSYS_{$refSysTID}"/>
      </xsl:if>

      <xsl:if test="mdb:identificationInfo">
        <xsl:variable name="diTID" select="generate-id(mdb:identificationInfo[1])"/>
        <eCH0271_1:identificationInfo ili:ref="DI_{$diTID}"/>
      </xsl:if>

      <xsl:if test="mdb:distributionInfo">
        <xsl:variable name="distTID" select="generate-id(mdb:distributionInfo/mrd:MD_Distribution[1])"/>
        <eCH0271_1:distributionInfo ili:ref="DIST_{$distTID}"/>
      </xsl:if>

      <!-- Constraints/Legislation -->
      <xsl:for-each select="mdb:resourceConstraints/che:CHE_MD_Legislation">
        <xsl:call-template name="generate-legislation">
          <xsl:with-param name="elem" select="."/>
        </xsl:call-template>
      </xsl:for-each>
    </eCH0271_1:CHE_MD_Metadata>
  </xsl:template>

  <!-- Generate CHE_CI_Organisation with contact info -->
  <xsl:template name="generate-organisation">
    <xsl:param name="elem"/>
    <xsl:variable name="partyTID" select="generate-id($elem)"/>
    <xsl:if test="$elem/che:CHE_CI_Organisation | $elem/cit:CI_Organisation">
      <eCH0271_1:CHE_CI_Organisation ili:tid="PARTY_{$partyTID}">
        <xsl:if test="($elem/che:CHE_CI_Organisation | $elem/cit:CI_Organisation)/cit:name/gco:CharacterString">
          <eCH0271_1:name>
            <xsl:value-of select="normalize-space(($elem/che:CHE_CI_Organisation | $elem/cit:CI_Organisation)/cit:name/gco:CharacterString)"/>
          </eCH0271_1:name>
        </xsl:if>
        <!-- Contact info: handle CI_Contact if present -->
        <xsl:if test="($elem/che:CHE_CI_Organisation | $elem/cit:CI_Organisation)/cit:contactInfo/cit:CI_Contact">
          <xsl:variable name="contactTID" select="generate-id(($elem/che:CHE_CI_Organisation | $elem/cit:CI_Organisation)/cit:contactInfo/cit:CI_Contact)"/>
          <eCH0271_1:contactInfo ili:ref="CONTACT_{$contactTID}"/>
        </xsl:if>
        <xsl:if test="($elem/che:CHE_CI_Organisation | $elem/cit:CI_Organisation)/che:organisationAcronym/gco:CharacterString">
          <eCH0271_1:organisationAcronym>
            <xsl:value-of select="normalize-space(($elem/che:CHE_CI_Organisation | $elem/cit:CI_Organisation)/che:organisationAcronym/gco:CharacterString)"/>
          </eCH0271_1:organisationAcronym>
        </xsl:if>
      </eCH0271_1:CHE_CI_Organisation>
    </xsl:if>
  </xsl:template>

  <!-- Generate CI_Responsibility with CHE_CI_Organisation -->
  <xsl:template name="generate-responsibility">
    <xsl:param name="elem"/>
    <xsl:variable name="respTID" select="generate-id($elem)"/>
    <xsl:if test="$elem/cit:CI_Responsibility | $elem/cit:CI_ResponsibleParty">
      <eCH0271_1:CI_Responsibility ili:tid="RESP_{$respTID}">
        <!-- Extract role code -->
        <xsl:variable name="roleCode">
          <xsl:choose>
            <xsl:when test="($elem/cit:CI_Responsibility | $elem/cit:CI_ResponsibleParty)/cit:role/cit:CI_RoleCode/@codeListValue">
              <xsl:value-of select="normalize-space(($elem/cit:CI_Responsibility | $elem/cit:CI_ResponsibleParty)/cit:role/cit:CI_RoleCode/@codeListValue)"/>
            </xsl:when>
            <xsl:when test="($elem/cit:CI_Responsibility | $elem/cit:CI_ResponsibleParty)/cit:role/cit:CI_RoleCode/text()">
              <xsl:value-of select="normalize-space(($elem/cit:CI_Responsibility | $elem/cit:CI_ResponsibleParty)/cit:role/cit:CI_RoleCode/text())"/>
            </xsl:when>
          </xsl:choose>
        </xsl:variable>
        <xsl:if test="$roleCode != ''">
          <eCH0271_1:role><xsl:value-of select="$roleCode"/></eCH0271_1:role>
        </xsl:if>
        <!-- Party reference -->
        <xsl:if test="($elem/cit:CI_Responsibility | $elem/cit:CI_ResponsibleParty)/cit:party">
          <xsl:variable name="partyTID" select="generate-id(($elem/cit:CI_Responsibility | $elem/cit:CI_ResponsibleParty)/cit:party[1])"/>
          <eCH0271_1:party ili:ref="PARTY_{$partyTID}"/>
        </xsl:if>
        <!-- Organisation name inline (for simple cases) -->
        <xsl:if test="($elem/cit:CI_Responsibility | $elem/cit:CI_ResponsibleParty)/cit:party/che:CHE_CI_Organisation/cit:name/gco:CharacterString">
          <eCH0271_1:organisationName>
            <xsl:value-of select="normalize-space(($elem/cit:CI_Responsibility | $elem/cit:CI_ResponsibleParty)/cit:party/che:CHE_CI_Organisation/cit:name/gco:CharacterString)"/>
          </eCH0271_1:organisationName>
        </xsl:if>
      </eCH0271_1:CI_Responsibility>
    </xsl:if>
  </xsl:template>

  <!-- Generate CI_Citation -->
  <xsl:template name="generate-citation">
    <xsl:param name="elem"/>
    <xsl:variable name="citTID" select="generate-id($elem)"/>
    <eCH0271_1:CI_Citation ili:tid="CIT_{$citTID}">
      <xsl:if test="$elem/cit:title/gco:CharacterString">
        <eCH0271_1:title>
          <xsl:value-of select="normalize-space($elem/cit:title/gco:CharacterString)"/>
        </eCH0271_1:title>
      </xsl:if>
    </eCH0271_1:CI_Citation>
  </xsl:template>

  <!-- Generate EX_Extent -->
  <xsl:template name="generate-extent">
    <xsl:param name="elem"/>
    <xsl:variable name="extTID" select="generate-id($elem)"/>
    <eCH0271_1:EX_Extent ili:tid="EXT_{$extTID}">
      <xsl:for-each select="$elem/gex:geographicElement/gex:EX_GeographicBoundingBox">
        <xsl:variable name="bboxTID" select="generate-id(.)"/>
        <eCH0271_1:geographicElement ili:ref="BBOX_{$bboxTID}"/>
      </xsl:for-each>
    </eCH0271_1:EX_Extent>
    <!-- Generate bbox elements -->
    <xsl:for-each select="$elem/gex:geographicElement/gex:EX_GeographicBoundingBox">
      <xsl:call-template name="generate-bbox">
        <xsl:with-param name="elem" select="."/>
      </xsl:call-template>
    </xsl:for-each>
  </xsl:template>

  <!-- Generate EX_GeographicBoundingBox -->
  <xsl:template name="generate-bbox">
    <xsl:param name="elem"/>
    <xsl:variable name="bboxTID" select="generate-id($elem)"/>
    <eCH0271_1:EX_GeographicBoundingBox ili:tid="BBOX_{$bboxTID}">
      <eCH0271_1:westBoundLongitude>
        <xsl:value-of select="normalize-space($elem/gex:westBoundLongitude/gco:Decimal)"/>
      </eCH0271_1:westBoundLongitude>
      <eCH0271_1:eastBoundLongitude>
        <xsl:value-of select="normalize-space($elem/gex:eastBoundLongitude/gco:Decimal)"/>
      </eCH0271_1:eastBoundLongitude>
      <eCH0271_1:southBoundLatitude>
        <xsl:value-of select="normalize-space($elem/gex:southBoundLatitude/gco:Decimal)"/>
      </eCH0271_1:southBoundLatitude>
      <eCH0271_1:northBoundLatitude>
        <xsl:value-of select="normalize-space($elem/gex:northBoundLatitude/gco:Decimal)"/>
      </eCH0271_1:northBoundLatitude>
    </eCH0271_1:EX_GeographicBoundingBox>
  </xsl:template>

  <!-- Generate MD_Distribution with online resources and transfer options -->
  <xsl:template name="generate-distribution">
    <xsl:param name="elem"/>
    <xsl:variable name="distTID" select="generate-id($elem)"/>
    <!-- Generate transfer options and online resources first -->
    <xsl:for-each select="$elem/mrd:transferOptions/mrd:MD_DigitalTransferOptions/mrd:onLine/cit:CI_OnlineResource">
      <xsl:call-template name="generate-online-resource">
        <xsl:with-param name="elem" select="."/>
      </xsl:call-template>
    </xsl:for-each>
  </xsl:template>

  <!-- Generate CI_OnlineResource -->
  <xsl:template name="generate-online-resource">
    <xsl:param name="elem"/>
    <xsl:variable name="orTID" select="generate-id($elem)"/>
    <eCH0271_1:CI_OnlineResource ili:tid="OR_{$orTID}">
      <xsl:if test="$elem/cit:linkage/gco:CharacterString">
        <eCH0271_1:linkage>
          <xsl:value-of select="normalize-space($elem/cit:linkage/gco:CharacterString)"/>
        </eCH0271_1:linkage>
      </xsl:if>
      <xsl:if test="$elem/cit:protocol/gco:CharacterString">
        <eCH0271_1:protocol>
          <xsl:value-of select="normalize-space($elem/cit:protocol/gco:CharacterString)"/>
        </eCH0271_1:protocol>
      </xsl:if>
      <xsl:if test="$elem/cit:function/cit:CI_OnLineFunctionCode/@codeListValue | $elem/cit:function/cit:CI_OnLineFunctionCode/text()">
        <eCH0271_1:function>
          <xsl:value-of select="normalize-space(($elem/cit:function/cit:CI_OnLineFunctionCode/@codeListValue | $elem/cit:function/cit:CI_OnLineFunctionCode/text())[1])"/>
        </eCH0271_1:function>
      </xsl:if>
      <xsl:if test="$elem/cit:description/gco:CharacterString">
        <eCH0271_1:description>
          <xsl:value-of select="normalize-space($elem/cit:description/gco:CharacterString)"/>
        </eCH0271_1:description>
      </xsl:if>
      <xsl:if test="$elem/cit:name/gco:CharacterString">
        <eCH0271_1:name>
          <xsl:value-of select="normalize-space($elem/cit:name/gco:CharacterString)"/>
        </eCH0271_1:name>
      </xsl:if>
    </eCH0271_1:CI_OnlineResource>
  </xsl:template>

  <!-- Generate CHE_MD_Legislation -->
  <xsl:template name="generate-legislation">
    <xsl:param name="elem"/>
    <xsl:variable name="legTID" select="generate-id($elem)"/>
    <eCH0271_1:CHE_MD_Legislation ili:tid="LEG_{$legTID}">
      <xsl:if test="$elem/che:country/mcc:MD_CountryCode">
        <eCH0271_1:country>
          <xsl:choose>
            <xsl:when test="$elem/che:country/mcc:MD_CountryCode/@codeListValue">
              <xsl:value-of select="normalize-space($elem/che:country/mcc:MD_CountryCode/@codeListValue)"/>
            </xsl:when>
            <xsl:otherwise>
              <xsl:value-of select="normalize-space($elem/che:country/mcc:MD_CountryCode/text())"/>
            </xsl:otherwise>
          </xsl:choose>
        </eCH0271_1:country>
      </xsl:if>
      <xsl:if test="$elem/che:legislationType/che:CHE_CI_LegislationCode">
        <eCH0271_1:legislationType>
          <xsl:choose>
            <xsl:when test="$elem/che:legislationType/che:CHE_CI_LegislationCode/@codeListValue">
              <xsl:value-of select="normalize-space($elem/che:legislationType/che:CHE_CI_LegislationCode/@codeListValue)"/>
            </xsl:when>
            <xsl:otherwise>
              <xsl:value-of select="normalize-space($elem/che:legislationType/che:CHE_CI_LegislationCode/text())"/>
            </xsl:otherwise>
          </xsl:choose>
        </eCH0271_1:legislationType>
      </xsl:if>
      <xsl:if test="$elem/che:language/mcc:MD_LanguageCode">
        <eCH0271_1:language>
          <xsl:choose>
            <xsl:when test="$elem/che:language/mcc:MD_LanguageCode/@codeListValue">
              <xsl:value-of select="normalize-space($elem/che:language/mcc:MD_LanguageCode/@codeListValue)"/>
            </xsl:when>
            <xsl:otherwise>
              <xsl:value-of select="normalize-space($elem/che:language/mcc:MD_LanguageCode/text())"/>
            </xsl:otherwise>
          </xsl:choose>
        </eCH0271_1:language>
      </xsl:if>
      <xsl:if test="$elem/che:internalReference/gco:CharacterString">
        <eCH0271_1:internalReference>
          <xsl:value-of select="normalize-space($elem/che:internalReference/gco:CharacterString)"/>
        </eCH0271_1:internalReference>
      </xsl:if>
    </eCH0271_1:CHE_MD_Legislation>
  </xsl:template>

  <!-- Generate CI_Contact -->
  <xsl:template name="generate-contact">
    <xsl:param name="elem"/>
    <xsl:variable name="contactTID" select="generate-id($elem)"/>
    <eCH0271_1:CI_Contact ili:tid="CONTACT_{$contactTID}">
      <xsl:if test="$elem/cit:address/cit:CI_Address">
        <xsl:variable name="addressTID" select="generate-id($elem/cit:address/cit:CI_Address)"/>
        <eCH0271_1:address ili:ref="ADDR_{$addressTID}"/>
      </xsl:if>
      <xsl:if test="$elem/cit:phone/cit:CI_Telephone">
        <xsl:if test="$elem/cit:phone/cit:CI_Telephone/cit:number/gco:CharacterString">
          <eCH0271_1:phone>
            <xsl:value-of select="normalize-space($elem/cit:phone/cit:CI_Telephone/cit:number/gco:CharacterString)"/>
          </eCH0271_1:phone>
        </xsl:if>
      </xsl:if>
      <xsl:if test="$elem/cit:onlineResource/cit:CI_OnlineResource/cit:linkage/gco:CharacterString">
        <eCH0271_1:onlineResource>
          <xsl:value-of select="normalize-space($elem/cit:onlineResource/cit:CI_OnlineResource/cit:linkage/gco:CharacterString)"/>
        </eCH0271_1:onlineResource>
      </xsl:if>
    </eCH0271_1:CI_Contact>
  </xsl:template>

  <!-- Generate CI_Address -->
  <xsl:template name="generate-address">
    <xsl:param name="elem"/>
    <xsl:variable name="addressTID" select="generate-id($elem)"/>
    <eCH0271_1:CI_Address ili:tid="ADDR_{$addressTID}">
      <xsl:if test="$elem/cit:deliveryPoint/gco:CharacterString">
        <eCH0271_1:deliveryPoint>
          <xsl:value-of select="normalize-space($elem/cit:deliveryPoint/gco:CharacterString)"/>
        </eCH0271_1:deliveryPoint>
      </xsl:if>
      <xsl:if test="$elem/cit:city/gco:CharacterString">
        <eCH0271_1:city>
          <xsl:value-of select="normalize-space($elem/cit:city/gco:CharacterString)"/>
        </eCH0271_1:city>
      </xsl:if>
      <xsl:if test="$elem/cit:administrativeArea/gco:CharacterString">
        <eCH0271_1:administrativeArea>
          <xsl:value-of select="normalize-space($elem/cit:administrativeArea/gco:CharacterString)"/>
        </eCH0271_1:administrativeArea>
      </xsl:if>
      <xsl:if test="$elem/cit:postalCode/gco:CharacterString">
        <eCH0271_1:postalCode>
          <xsl:value-of select="normalize-space($elem/cit:postalCode/gco:CharacterString)"/>
        </eCH0271_1:postalCode>
      </xsl:if>
      <xsl:if test="$elem/cit:country/gco:CharacterString">
        <eCH0271_1:country>
          <xsl:value-of select="normalize-space($elem/cit:country/gco:CharacterString)"/>
        </eCH0271_1:country>
      </xsl:if>
      <xsl:if test="$elem/cit:electronicMailAddress/gco:CharacterString">
        <eCH0271_1:electronicMailAddress>
          <xsl:value-of select="normalize-space($elem/cit:electronicMailAddress/gco:CharacterString)"/>
        </eCH0271_1:electronicMailAddress>
      </xsl:if>
    </eCH0271_1:CI_Address>
  </xsl:template>

  <xsl:template match="text()|@*" priority="-10"/>
</xsl:stylesheet>
