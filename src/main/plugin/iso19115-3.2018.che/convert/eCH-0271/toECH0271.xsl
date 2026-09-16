<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="2.0"
  xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
  xmlns:xs="http://www.w3.org/2001/XMLSchema"
  xmlns:iso19115-to-ech0271="urn:iso19115-to-ech0271-functions"
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
  exclude-result-prefixes="xsl xs che mdb mri mrd cit gex mdq mcc lan gco mrl mrs mco iso19115-to-ech0271">

  <xsl:output method="xml" version="1.0" encoding="UTF-8" indent="yes"/>
  <xsl:strip-space elements="*"/>

  <xsl:param name="uuid" as="xs:string?"/>

  <xsl:template match="/">
    <ili:transfer xmlns:ili="http://www.interlis.ch/xtf/2.4/INTERLIS" xmlns:eCH0271_1="http://www.interlis.ch/xtf/2.4/eCH0271_1" xmlns:Localisation_V2="http://www.interlis.ch/xtf/2.4/Localisation_V2" xmlns:geom="http://www.interlis.ch/geometry/1.0" xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance">
      <ili:headersection>
        <ili:models>
          <ili:model Name="eCH0271_1" Version="2024-01-01"/>
        </ili:models>
      </ili:headersection>
      <ili:datasection>
        <xsl:apply-templates select="//che:CHE_MD_Metadata | //mdb:MD_Metadata" mode="iso19115-to-ech0271"/>
      </ili:datasection>
    </ili:transfer>
  </xsl:template>

  <xsl:template match="che:CHE_MD_Metadata | mdb:MD_Metadata" mode="iso19115-to-ech0271">
    <xsl:variable name="mdTID" select="generate-id(.)"/>
    <xsl:variable name="mdUUID">
      <xsl:choose>
        <xsl:when test="normalize-space($uuid) != ''">
          <xsl:value-of select="$uuid"/>
        </xsl:when>
        <xsl:when test="mdb:metadataIdentifier/*/mcc:code/*/text()">
          <xsl:value-of select="normalize-space(mdb:metadataIdentifier/*/mcc:code/*/text())"/>
        </xsl:when>
        <xsl:otherwise>
          <xsl:value-of select="concat('MD_', generate-id(.))"/>
        </xsl:otherwise>
      </xsl:choose>
    </xsl:variable>

    <eCH0271_1:CHE_MD_Metadata ili:tid="MD_{$mdTID}">
      <eCH0271_1:fileIdentifier>
        <xsl:value-of select="$mdUUID"/>
      </eCH0271_1:fileIdentifier>

      <xsl:apply-templates select="mdb:defaultLocale | mdb:otherLocale" mode="iso19115-to-ech0271"/>
      <xsl:apply-templates select="mdb:contact" mode="iso19115-to-ech0271"/>

      <xsl:if test="mdb:dateInfo/*/cit:date/gco:Date | mdb:dateInfo/*/cit:date/gco:DateTime">
        <xsl:variable name="dateValue" select="(mdb:dateInfo/*/cit:date/gco:Date | mdb:dateInfo/*/cit:date/gco:DateTime)[1]"/>
        <eCH0271_1:dateStamp>
          <xsl:value-of select="normalize-space($dateValue)"/>
        </eCH0271_1:dateStamp>
      </xsl:if>

      <!-- Metadata standard -->
      <xsl:if test="mdb:metadataStandard/*/cit:title/gco:CharacterString">
        <eCH0271_1:metadataStandardName>
          <xsl:value-of select="normalize-space(mdb:metadataStandard/*/cit:title/gco:CharacterString)"/>
        </eCH0271_1:metadataStandardName>
      </xsl:if>
      <xsl:if test="mdb:metadataStandard/*/cit:edition/gco:CharacterString">
        <eCH0271_1:metadataStandardVersion>
          <xsl:value-of select="normalize-space(mdb:metadataStandard/*/cit:edition/gco:CharacterString)"/>
        </eCH0271_1:metadataStandardVersion>
      </xsl:if>

      <xsl:apply-templates select="mdb:identificationInfo" mode="iso19115-to-ech0271"/>
      <xsl:apply-templates select="mdb:distributionInfo" mode="iso19115-to-ech0271"/>
      <xsl:apply-templates select="mdb:dataQualityInfo" mode="iso19115-to-ech0271"/>
    </eCH0271_1:CHE_MD_Metadata>
  </xsl:template>

  <xsl:template match="mdb:defaultLocale | mdb:otherLocale" mode="iso19115-to-ech0271">
    <xsl:variable name="langCode" select="normalize-space(*/lan:language/*/text())"/>
    <eCH0271_1:language>
      <xsl:choose>
        <xsl:when test="$langCode = 'ger' or $langCode = 'deu'">de</xsl:when>
        <xsl:when test="$langCode = 'fra' or $langCode = 'fre'">fr</xsl:when>
        <xsl:when test="$langCode = 'ita'">it</xsl:when>
        <xsl:when test="$langCode = 'eng'">en</xsl:when>
        <xsl:when test="$langCode = 'roh'">rm</xsl:when>
        <xsl:when test="string-length($langCode) = 2"><xsl:value-of select="$langCode"/></xsl:when>
        <xsl:otherwise><xsl:value-of select="substring($langCode, 1, 2)"/></xsl:otherwise>
      </xsl:choose>
    </eCH0271_1:language>
  </xsl:template>

  <xsl:template match="mdb:identificationInfo" mode="iso19115-to-ech0271">
    <xsl:variable name="diTID" select="generate-id(.)"/>
    <eCH0271_1:MD_DataIdentification ili:tid="DI_{$diTID}">
      <xsl:if test="*/mri:citation">
        <xsl:apply-templates select="*/mri:citation" mode="iso19115-to-ech0271"/>
      </xsl:if>
      <xsl:if test="*/mri:abstract/gco:CharacterString">
        <eCH0271_1:abstract>
          <xsl:value-of select="normalize-space(*/mri:abstract/gco:CharacterString)"/>
        </eCH0271_1:abstract>
      </xsl:if>
      <xsl:if test="*/mri:purpose/gco:CharacterString">
        <eCH0271_1:purpose>
          <xsl:value-of select="normalize-space(*/mri:purpose/gco:CharacterString)"/>
        </eCH0271_1:purpose>
      </xsl:if>
      <xsl:if test="*/mri:status/mcc:MD_ProgressCode/@codeListValue">
        <eCH0271_1:status>
          <xsl:value-of select="normalize-space(*/mri:status/mcc:MD_ProgressCode/@codeListValue)"/>
        </eCH0271_1:status>
      </xsl:if>
      <xsl:apply-templates select="*/mri:pointOfContact" mode="iso19115-to-ech0271"/>
      <xsl:apply-templates select="*/mri:extent" mode="iso19115-to-ech0271"/>
      <xsl:apply-templates select="*/mri:keywords" mode="iso19115-to-ech0271"/>
      <xsl:apply-templates select="*/mri:resourceConstraints" mode="iso19115-to-ech0271"/>
    </eCH0271_1:MD_DataIdentification>
  </xsl:template>

  <xsl:template match="mri:citation | cit:CI_Citation" mode="iso19115-to-ech0271">
    <xsl:variable name="citTID" select="generate-id(.)"/>
    <eCH0271_1:CI_Citation ili:tid="CIT_{$citTID}">
      <xsl:if test="cit:title/gco:CharacterString">
        <eCH0271_1:title>
          <xsl:value-of select="normalize-space(cit:title/gco:CharacterString)"/>
        </eCH0271_1:title>
      </xsl:if>
      <!-- Publication date -->
      <xsl:if test="cit:date/cit:CI_Date[cit:dateType/cit:CI_DateTypeCode/@codeListValue='publication']/cit:date/gco:Date">
        <eCH0271_1:date>
          <xsl:value-of select="normalize-space(cit:date/cit:CI_Date[cit:dateType/cit:CI_DateTypeCode/@codeListValue='publication']/cit:date/gco:Date)"/>
        </eCH0271_1:date>
      </xsl:if>
      <!-- Revision date (fallback if publication not found) -->
      <xsl:if test="not(cit:date/cit:CI_Date[cit:dateType/cit:CI_DateTypeCode/@codeListValue='publication']/cit:date/gco:Date) and cit:date/cit:CI_Date[cit:dateType/cit:CI_DateTypeCode/@codeListValue='revision']/cit:date/gco:Date">
        <eCH0271_1:date>
          <xsl:value-of select="normalize-space(cit:date/cit:CI_Date[cit:dateType/cit:CI_DateTypeCode/@codeListValue='revision']/cit:date/gco:Date)"/>
        </eCH0271_1:date>
      </xsl:if>
    </eCH0271_1:CI_Citation>
  </xsl:template>

  <xsl:template match="mri:extent" mode="iso19115-to-ech0271">
    <xsl:variable name="extTID" select="generate-id(.)"/>
    <eCH0271_1:EX_Extent ili:tid="EXT_{$extTID}">
      <xsl:apply-templates select="gex:EX_Extent/gex:geographicElement" mode="iso19115-to-ech0271"/>
    </eCH0271_1:EX_Extent>
  </xsl:template>

  <xsl:template match="gex:geographicElement" mode="iso19115-to-ech0271">
    <xsl:variable name="bboxTID" select="generate-id(.)"/>
    <xsl:if test="gex:EX_GeographicBoundingBox">
      <eCH0271_1:EX_GeographicBoundingBox ili:tid="BBOX_{$bboxTID}">
        <eCH0271_1:westBoundLongitude>
          <xsl:value-of select="normalize-space(gex:EX_GeographicBoundingBox/gex:westBoundLongitude/gco:Decimal)"/>
        </eCH0271_1:westBoundLongitude>
        <eCH0271_1:eastBoundLongitude>
          <xsl:value-of select="normalize-space(gex:EX_GeographicBoundingBox/gex:eastBoundLongitude/gco:Decimal)"/>
        </eCH0271_1:eastBoundLongitude>
        <eCH0271_1:southBoundLatitude>
          <xsl:value-of select="normalize-space(gex:EX_GeographicBoundingBox/gex:southBoundLatitude/gco:Decimal)"/>
        </eCH0271_1:southBoundLatitude>
        <eCH0271_1:northBoundLatitude>
          <xsl:value-of select="normalize-space(gex:EX_GeographicBoundingBox/gex:northBoundLatitude/gco:Decimal)"/>
        </eCH0271_1:northBoundLatitude>
      </eCH0271_1:EX_GeographicBoundingBox>
    </xsl:if>
  </xsl:template>

  <xsl:template match="mdb:distributionInfo" mode="iso19115-to-ech0271">
    <xsl:variable name="distTID" select="generate-id(.)"/>
    <eCH0271_1:MD_Distribution ili:tid="DIST_{$distTID}"/>
  </xsl:template>

  <xsl:template match="mdb:dataQualityInfo" mode="iso19115-to-ech0271">
    <xsl:variable name="dqTID" select="generate-id(.)"/>
    <eCH0271_1:dataQualityInfo ili:tid="DQ_{$dqTID}"/>
  </xsl:template>

  <xsl:template match="mri:keywords" mode="iso19115-to-ech0271">
    <xsl:variable name="kwTID" select="generate-id(.)"/>
    <xsl:if test="mri:MD_Keywords/mri:keyword">
      <eCH0271_1:descriptiveKeywords ili:tid="KW_{$kwTID}">
        <xsl:for-each select="mri:MD_Keywords/mri:keyword/gco:CharacterString">
          <eCH0271_1:keyword>
            <xsl:value-of select="normalize-space(.)"/>
          </eCH0271_1:keyword>
        </xsl:for-each>
      </eCH0271_1:descriptiveKeywords>
    </xsl:if>
  </xsl:template>

  <xsl:template match="mdb:contact | mri:pointOfContact" mode="iso19115-to-ech0271">
    <xsl:variable name="respTID" select="generate-id(.)"/>
    <xsl:if test="cit:CI_Responsibility | cit:CI_ResponsibleParty">
      <eCH0271_1:CI_ResponsibleParty ili:tid="RESP_{$respTID}">
        <!-- Role -->
        <xsl:if test="(cit:CI_Responsibility | cit:CI_ResponsibleParty)/cit:role/cit:CI_RoleCode/@codeListValue">
          <eCH0271_1:role>
            <xsl:value-of select="normalize-space((cit:CI_Responsibility | cit:CI_ResponsibleParty)/cit:role/cit:CI_RoleCode/@codeListValue)"/>
          </eCH0271_1:role>
        </xsl:if>
        
        <!-- Organisation name (from party - both CHE and standard) -->
        <xsl:if test="(cit:CI_Responsibility | cit:CI_ResponsibleParty)/cit:party/che:CHE_CI_Organisation/cit:name/gco:CharacterString">
          <eCH0271_1:organisationName>
            <xsl:value-of select="normalize-space((cit:CI_Responsibility | cit:CI_ResponsibleParty)/cit:party/che:CHE_CI_Organisation/cit:name/gco:CharacterString)"/>
          </eCH0271_1:organisationName>
        </xsl:if>
        <xsl:if test="(cit:CI_Responsibility | cit:CI_ResponsibleParty)/cit:party/cit:CI_Organisation/cit:name/gco:CharacterString">
          <eCH0271_1:organisationName>
            <xsl:value-of select="normalize-space((cit:CI_Responsibility | cit:CI_ResponsibleParty)/cit:party/cit:CI_Organisation/cit:name/gco:CharacterString)"/>
          </eCH0271_1:organisationName>
        </xsl:if>
        
        <!-- Individual name (from individualMember or direct) -->
        <xsl:if test="(cit:CI_Responsibility | cit:CI_ResponsibleParty)/cit:party/che:CHE_CI_Organisation/che:individualMember/cit:CI_Individual/cit:name/gco:CharacterString">
          <eCH0271_1:individualName>
            <xsl:value-of select="normalize-space((cit:CI_Responsibility | cit:CI_ResponsibleParty)/cit:party/che:CHE_CI_Organisation/che:individualMember/cit:CI_Individual/cit:name/gco:CharacterString)"/>
          </eCH0271_1:individualName>
        </xsl:if>
        <xsl:if test="(cit:CI_Responsibility | cit:CI_ResponsibleParty)/cit:party/cit:CI_Individual/cit:name/gco:CharacterString">
          <eCH0271_1:individualName>
            <xsl:value-of select="normalize-space((cit:CI_Responsibility | cit:CI_ResponsibleParty)/cit:party/cit:CI_Individual/cit:name/gco:CharacterString)"/>
          </eCH0271_1:individualName>
        </xsl:if>

        <!-- Contact info -->
        <xsl:apply-templates select="(cit:CI_Responsibility | cit:CI_ResponsibleParty)/cit:party/*/cit:contactInfo" mode="iso19115-to-ech0271"/>
      </eCH0271_1:CI_ResponsibleParty>
    </xsl:if>
  </xsl:template>

  <!-- Contact info template -->
  <xsl:template match="cit:contactInfo" mode="iso19115-to-ech0271">
    <xsl:variable name="contactTID" select="generate-id(.)"/>
    <xsl:if test="cit:CI_Contact">
      <eCH0271_1:contactInfo ili:tid="CONT_{$contactTID}">
        <!-- Phone -->
        <xsl:if test="cit:CI_Contact/cit:phone/cit:CI_Telephone/cit:voice/gco:CharacterString">
          <eCH0271_1:phone>
            <xsl:value-of select="normalize-space(cit:CI_Contact/cit:phone/cit:CI_Telephone/cit:voice/gco:CharacterString)"/>
          </eCH0271_1:phone>
        </xsl:if>
        <!-- Address -->
        <xsl:apply-templates select="cit:CI_Contact/cit:address" mode="iso19115-to-ech0271"/>
        <!-- Online resource -->
        <xsl:if test="cit:CI_Contact/cit:onlineResource/cit:CI_OnlineResource/cit:linkage/gco:CharacterString">
          <eCH0271_1:onlineResource>
            <xsl:value-of select="normalize-space(cit:CI_Contact/cit:onlineResource/cit:CI_OnlineResource/cit:linkage/gco:CharacterString)"/>
          </eCH0271_1:onlineResource>
        </xsl:if>
      </eCH0271_1:contactInfo>
    </xsl:if>
  </xsl:template>

  <!-- Address template -->
  <xsl:template match="cit:address" mode="iso19115-to-ech0271">
    <eCH0271_1:address>
      <xsl:if test="cit:CI_Address/cit:deliveryPoint/gco:CharacterString">
        <eCH0271_1:streetName>
          <xsl:value-of select="normalize-space(cit:CI_Address/cit:deliveryPoint/gco:CharacterString)"/>
        </eCH0271_1:streetName>
      </xsl:if>
      <xsl:if test="cit:CI_Address/cit:city/gco:CharacterString">
        <eCH0271_1:city>
          <xsl:value-of select="normalize-space(cit:CI_Address/cit:city/gco:CharacterString)"/>
        </eCH0271_1:city>
      </xsl:if>
      <xsl:if test="cit:CI_Address/cit:administrativeArea/gco:CharacterString">
        <eCH0271_1:administrativeArea>
          <xsl:value-of select="normalize-space(cit:CI_Address/cit:administrativeArea/gco:CharacterString)"/>
        </eCH0271_1:administrativeArea>
      </xsl:if>
      <xsl:if test="cit:CI_Address/cit:postalCode/gco:CharacterString">
        <eCH0271_1:postalCode>
          <xsl:value-of select="normalize-space(cit:CI_Address/cit:postalCode/gco:CharacterString)"/>
        </eCH0271_1:postalCode>
      </xsl:if>
      <xsl:if test="cit:CI_Address/cit:country/gco:CharacterString">
        <eCH0271_1:country>
          <xsl:value-of select="normalize-space(cit:CI_Address/cit:country/gco:CharacterString)"/>
        </eCH0271_1:country>
      </xsl:if>
      <xsl:if test="cit:CI_Address/cit:electronicMailAddress/gco:CharacterString">
        <eCH0271_1:electronicMailAddress>
          <xsl:value-of select="normalize-space(cit:CI_Address/cit:electronicMailAddress/gco:CharacterString)"/>
        </eCH0271_1:electronicMailAddress>
      </xsl:if>
    </eCH0271_1:address>
  </xsl:template>

  <xsl:template match="mri:resourceConstraints" mode="iso19115-to-ech0271">
    <xsl:variable name="constraintTID" select="generate-id(.)"/>
    <xsl:if test="mco:MD_LegalConstraints/mco:useLimitation/gco:CharacterString">
      <eCH0271_1:resourceConstraints ili:tid="RC_{$constraintTID}">
        <eCH0271_1:useLimitation>
          <xsl:value-of select="normalize-space(mco:MD_LegalConstraints/mco:useLimitation/gco:CharacterString)"/>
        </eCH0271_1:useLimitation>
      </eCH0271_1:resourceConstraints>
    </xsl:if>
  </xsl:template>

  <!-- Language code conversion - inlined for Xalan compatibility -->

  <xsl:template match="text()|@*" priority="-10" mode="iso19115-to-ech0271"/>
  <xsl:template match="text()|@*" priority="-10"/>

</xsl:stylesheet>
